import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/basics.dart';
import '../../widgets/advanced_search.dart';
import '../../widgets/responsive.dart';
import '../../widgets/user_search_form.dart';
import 'colorful_line_widget.dart';
import 'qr_and_barcode_screen.dart';

class DocumentTrackingScreen extends StatelessWidget {
  static const routeName = '/documentTracking';

  const DocumentTrackingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final Basics bpr = Provider.of<Basics>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            const ColorfulLine(
              height: 2,
              // width: 300,
              colors: [
                kPrimaryLightColor,
                kPrimaryMediumColor,
                kPrimaryColor,
                Colors.orange,
              ],
            ),
            // History Search Option
            _buildOptionCard(
              context: context,
              icon: Icons.history,
              title: 'نوسراوەکانی پێشتر',
              subtitle: 'ئەو نوسراوانەی پێشتر بەدوای گەڕاوی',
              onTap: () {
                // Navigate to History Search Page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistorySearchPage()));
              },
            ),

            // Manual Enter Document Data Option
            _buildOptionCard(
              context: context,
              icon: Icons.edit,
              title: 'گەڕانی نوسراو',
              subtitle: 'زانیاری نوسراو بنوسە',
              onTap: () {
                UserSearchForm qrandBarCode = const UserSearchForm();
                _onTap(context, qrandBarCode, "گەڕانی نوسراو");
              },
            ),

            // QR and Barcode Scanner Option
            _buildOptionCard(
              context: context,
              icon: Icons.qr_code_scanner,
              title: 'کیو ئاڕکۆد',
              subtitle: 'نوسراوەکە سکان بکە',
              onTap: () {
                QRBarcodeScannerScreen qrandBarCode = QRBarcodeScannerScreen(
                  onDetect: (BarcodeCapture capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    final Barcode barcode = barcodes.first;
                    final code = barcode.rawValue ?? '---';
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Scanned Code: $code'),
                    ));

                    Navigator.pop(context);
                    // print('Scanned Code: $code');

                    // for (final barcode in barcodes) {
                    //   print(barcode.rawValue);
                    // }
                  },
                );
                _onTap(context, qrandBarCode, "کیوئاڕکۆد");
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, Widget theForm, String? title) async {
    final double w = Responsive.w(context);
    final bool isLargeTablet = Responsive.isLargeTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final bool isLargeDesktop = Responsive.isLargeDesktop(context);

    if (w < 1200) {
      await showModalBottomSheet(
        isScrollControlled: true, //to Maximize BottomSheet
        shape: kBuildTopRoundedRectangleBorder,
        context: context,
        builder: (ctx) {
          return FractionallySizedBox(
              heightFactor: isLargeTablet ? 0.7 : 0.9,
              child: AdvancedSearch(
                searchForm: theForm,
                title: title,
              ));
        },
      );
    } else {
      showDialog(
          // barrierColor: kPrimaryLightColor.withOpacity(0.2),
          barrierColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              elevation: 35,
              shadowColor: kPrimaryColor,
              alignment: Alignment.topCenter,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: FractionallySizedBox(
                heightFactor: 0.7,
                widthFactor: isDesktop ? 0.5 : (isLargeDesktop ? 0.4 : 0.7),
                child: AdvancedSearch(
                  searchForm: theForm,
                  title: title,
                ),
              ),
            );
          });
    }
  }

  // Widget for each search option
  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: ListTile(
        iconColor: kPrimaryColor,
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        dense: true,
        onTap: onTap,
      ),
    );
  }
}

// Placeholder for History Search Page
class HistorySearchPage extends StatelessWidget {
  const HistorySearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History Search')),
      body: const Center(child: Text('History Search Page')),
    );
  }
}
