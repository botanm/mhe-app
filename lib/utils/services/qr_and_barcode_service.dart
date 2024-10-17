import 'package:mobile_scanner/mobile_scanner.dart';

class QRBarcodeService {
  final MobileScannerController _scannerController = MobileScannerController();

  MobileScannerController get scannerController => _scannerController;

  /// Dispose the scanner controller when done
  void dispose() {
    _scannerController.dispose();
  }

  /// Toggle between camera flash on/off
  void toggleFlash() {
    _scannerController.toggleTorch();
  }

  /// Switch between front and back camera
  void switchCamera() {
    _scannerController.switchCamera();
  }
}
