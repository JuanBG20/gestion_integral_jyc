import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    // TODO: Ajustar a tipo de código específico
  );

  bool _isProcessing = false;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _setupSupabaseChannel();
  }

  void _setupSupabaseChannel() {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId != null) {
      // Nos suscribimos al mismo canal que escucha la PC
      _channel = supabase.channel('scanner-$userId');
      _channel!.subscribe();
    }
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    // Evitamos enviar lecturas duplicadas en el mismo instante
    if (_isProcessing || _channel == null) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? skuEscaneado = barcodes.first.rawValue;
    if (skuEscaneado == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Enviamos el mensaje por Broadcast a la PC
      await _channel!.sendBroadcastMessage(
        event: 'sku_scanned',
        payload: {'sku': skuEscaneado},
      );

      if (mounted) {
        // Feedback visual en el celular
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('SKU enviado: $skuEscaneado'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
      }
    } finally {
      // Hacemos una pausa de 2 segundos antes de permitir el próximo escaneo
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    if (_channel != null) {
      Supabase.instance.client.removeChannel(_channel!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Escanear Producto"),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: _scannerController,
              builder: (context, state, child) {
                switch (state.torchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                  case TorchState.unavailable:
                  case TorchState.auto:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                }
              },
            ),
            onPressed: () => _scannerController.toggleTorch(),
          ),
        ],
      ),

      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _handleBarcode,
          ),

          Center(
            child: Container(
              width: 250,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
