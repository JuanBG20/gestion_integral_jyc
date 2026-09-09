import 'dart:async';

import 'package:gestion_integral_jyc/core/domain/services/item_scan_listener.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseScanListener implements ItemScanListener {
  final _controller = StreamController<String>.broadcast();
  RealtimeChannel? _channel;

  SupabaseScanListener() {
    _subscribe();
  }

  @override
  Stream<String> get scannedSku => _controller.stream;

  void _subscribe() {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) return;

    // Escuchamos el canal único de este usuario
    _channel = supabase.channel('scanner-$userId');
    _channel!
        .onBroadcast(
          event: 'sku_scanned',
          callback: (payload) {
            final sku = payload['sku'] as String?;
            if (sku != null) {
              _controller.add(sku);
            }
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    if (_channel != null) {
      Supabase.instance.client.removeChannel(_channel!);
    }
    _controller.close();
  }
}
