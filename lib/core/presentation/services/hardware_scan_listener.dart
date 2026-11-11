import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gestion_integral_jyc/core/domain/services/item_scan_listener.dart';

// Escucha lectores de códigos físicos que funcionan como teclado HID
// Tipean el código muy rápido y terminan con Enter
class HardwareScanListener implements ItemScanListener {
  HardwareScanListener({
    this.isActive,
    this.maxInterKeyDelay = const Duration(milliseconds: 50),
    this.maxTerminatorDelay = const Duration(milliseconds: 100),
    this.minLength = 3,
  }) {
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  final bool Function()? isActive;
  final Duration maxInterKeyDelay;
  final Duration maxTerminatorDelay;
  final int minLength;

  static final _terminators = {
    LogicalKeyboardKey.enter,
    LogicalKeyboardKey.numpadEnter,
    LogicalKeyboardKey.tab,
  };

  final _controller = StreamController<String>.broadcast();
  final _buffer = StringBuffer();
  final _clock = Stopwatch()..start();
  Duration? _lastKeyAt;
  _FocusedTextSnapshot? _snapshot;

  @override
  Stream<String> get scannedSku => _controller.stream;

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    final now = event.timeStamp == Duration.zero
        ? _clock.elapsed
        : event.timeStamp;
    final last = _lastKeyAt;
    final gap = last == null ? null : now - last;

    if (_terminators.contains(event.logicalKey)) {
      final code = _buffer.toString().trim();
      final looksLikeScan =
          code.length >= minLength && gap != null && gap <= maxTerminatorDelay;
      final snapshot = _snapshot;
      _reset();

      if (!looksLikeScan || !(isActive?.call() ?? true)) return false;

      snapshot?.restore();
      _controller.add(code);
      return true;
    }

    final char = event.character;
    if (char == null || char.isEmpty || char.codeUnitAt(0) < 0x20) {
      return false;
    }

    if (_buffer.isEmpty || gap == null || gap > maxInterKeyDelay) {
      _reset();
      _snapshot = _FocusedTextSnapshot.capture();
    }

    _buffer.write(char);
    _lastKeyAt = now;
    return false;
  }

  void _reset() {
    _buffer.clear();
    _lastKeyAt = null;
    _snapshot = null;
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _controller.close();
  }
}

class _FocusedTextSnapshot {
  final EditableTextState _editable;
  final TextEditingValue _value;

  _FocusedTextSnapshot._(this._editable, this._value);

  static _FocusedTextSnapshot? capture() {
    final context = FocusManager.instance.primaryFocus?.context;
    final editable = context?.findAncestorStateOfType<EditableTextState>();
    if (editable == null) return null;
    return _FocusedTextSnapshot._(editable, editable.widget.controller.value);
  }

  void restore() {
    if (!_editable.mounted) return;
    _editable.widget.controller.value = _value;
  }
}
