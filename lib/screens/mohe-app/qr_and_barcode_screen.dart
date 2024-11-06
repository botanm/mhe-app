import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mohe_app_1_x_x/constants/app_constants.dart';
import '../../utils/services/qr_and_barcode_service.dart';
import '../../widgets/toggle_buttons_widget.dart';

class QRBarcodeScannerScreen extends StatefulWidget {
  const QRBarcodeScannerScreen({Key? key, required this.onDetect})
      : super(key: key);

  /// Callback for when a code is detected
  final void Function(BarcodeCapture) onDetect;

  @override
  State<QRBarcodeScannerScreen> createState() => _QRBarcodeScannerScreenState();
}

class _QRBarcodeScannerScreenState extends State<QRBarcodeScannerScreen>
    with SingleTickerProviderStateMixin {
  late final QRBarcodeService _qrBarcodeService;
  bool _hasScanned = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _animationController;
  late Animation<double> _animation;
  final ImagePicker _imagePicker =
      ImagePicker(); // Image picker for selecting images
  bool _isQRCode = true; // Track the selected scan type (QR or Barcode)

  @override
  void initState() {
    super.initState();
    _qrBarcodeService = QRBarcodeService();

    // Initialize the animation controller and the animation
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true); // Loop the animation

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _qrBarcodeService.dispose();
    _animationController.dispose(); // Dispose animation controller
    super.dispose();
  }

  Future<void> _playBeepSound() async {
    await _audioPlayer.play(AssetSource('sounds/barcode-beep.mp3'));
  }

  /// Pick an image from the gallery and scan for a QR code or barcode
  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final MobileScannerController controller =
          _qrBarcodeService.scannerController;

      // Analyze the image for barcodes
      final BarcodeCapture? capture =
          await controller.analyzeImage(imageFile.path);

      // Check if a valid BarcodeCapture object is returned
      if (capture != null && capture.barcodes.isNotEmpty) {
        final List<Barcode> codes = capture.barcodes.where((barcode) {
          // Filter based on selected type (QR Code or Barcode)
          return _isQRCode
              ? barcode.format == BarcodeFormat.qrCode
              : barcode.format != BarcodeFormat.qrCode;
        }).toList();

        if (codes.isNotEmpty) {
          _playBeepSound(); // Play beep sound
          widget.onDetect(capture); // Trigger onDetect callback
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: kPrimaryColor,
              content: Text('No barcode or QR code found in the image.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: kPrimaryColor,
              content: Text('هیچ کۆدێك نەدۆزرایەوە',
                  textDirection: TextDirection.rtl)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scanBoxHeight = screenHeight * 0.4;
    final double scanBoxTop = screenHeight * 0.3;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildQRorBarcode,
          ),
          Expanded(
            child: Stack(
              children: [
                // The camera viewfinder
                MobileScanner(
                  controller: _qrBarcodeService.scannerController,
                  onDetect: (BarcodeCapture capture) async {
                    if (_hasScanned) return;

                    final List<Barcode> codes = capture.barcodes.where((code) {
                      return _isQRCode
                          ? code.format == BarcodeFormat.qrCode
                          : code.format != BarcodeFormat.qrCode;
                    }).toList();

                    if (codes.isNotEmpty) {
                      _hasScanned = true;
                      await _playBeepSound();
                      widget.onDetect(capture);
                      _qrBarcodeService.scannerController.stop();
                    }
                  },
                ),

                // Blurred outer area with a clear center for the scanning box
                _buildOverlayWithTransparentCenter(context),

                // Animated Red Line (Inside the scan box)
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final animatedPosition =
                        scanBoxTop + (scanBoxHeight - 2) * _animation.value;
                    return Positioned(
                      top: animatedPosition,
                      left: screenWidth * 0.1,
                      right: screenWidth * 0.1,
                      child: Container(
                        height: 0.5,
                        color: Colors.red, // The red scanning line
                      ),
                    );
                  },
                ),

                // Camera Controls (Flash, Camera Switch, and Pick Image)
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.flash_on, color: kPrimaryColor),
                        onPressed: _qrBarcodeService.toggleFlash,
                      ),
                      IconButton(
                        icon: const Icon(Icons.cameraswitch,
                            color: kPrimaryColor),
                        onPressed: _qrBarcodeService.switchCamera,
                      ),
                      IconButton(
                        icon: const Icon(Icons.image, color: kPrimaryColor),
                        onPressed: _pickImage, // Add image picker button here
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build an overlay with blurred edges but transparent center
  Widget _buildOverlayWithTransparentCenter(BuildContext context) {
    return Stack(
      children: [
        // Dark overlay with transparent scan box in the center
        Positioned.fill(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  // Full screen dark overlay
                  Container(
                    color: Colors.black.withOpacity(0.6),
                  ),
                  // Clear area for scanning box (center)
                  Positioned(
                    top: constraints.maxHeight * 0.3,
                    left: constraints.maxWidth * 0.1,
                    right: constraints.maxWidth * 0.1,
                    child: Container(
                      height: constraints.maxHeight * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  ToggleButtonsWidget get _buildQRorBarcode {
    List<String> trdTexts = ['QR Code', 'Barcode'];
    List<bool> initialSelected = [_isQRCode, !_isQRCode];
    return ToggleButtonsWidget(
      selectedColor: kPrimaryColor,
      texts: trdTexts,
      initialSelected: initialSelected,
      selectedHandler: (index) {
        setState(() {
          _isQRCode = index == 0; // Toggle based on selected index
        });
      },
      isEnabled: true,
    );
  }
}
