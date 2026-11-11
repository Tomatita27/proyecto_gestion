
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _isProcessing = false;

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing || !mounted) return;

    for (final barcode in capture.barcodes) {
      final String? code = barcode.rawValue;

      if (code == null || code.isEmpty) continue;

      _isProcessing = true;

      Navigator.pop(context, code);
      return;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: controller,
              onDetect: _onDetect,
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Escanea un código QR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}