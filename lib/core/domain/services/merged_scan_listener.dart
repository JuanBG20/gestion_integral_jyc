import 'dart:async';

import 'package:gestion_integral_jyc/core/domain/services/item_scan_listener.dart';

// Combina varias fuentes de escaneo en un único ItemScanListener.
class MergedScanListener implements ItemScanListener {
  final List<ItemScanListener> _sources;
  final bool Function(ItemScanListener source, String code)? accept;

  final _controller = StreamController<String>.broadcast();
  final _subscriptions = <StreamSubscription<String>>[];

  MergedScanListener(this._sources, {this.accept}) {
    for (final source in _sources) {
      _subscriptions.add(
        source.scannedSku.listen((code) {
          if (accept?.call(source, code) ?? true) _controller.add(code);
        }),
      );
    }
  }

  @override
  Stream<String> get scannedSku => _controller.stream;

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    for (final source in _sources) {
      source.dispose();
    }
    _controller.close();
  }
}
