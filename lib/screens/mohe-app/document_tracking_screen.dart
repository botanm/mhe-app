import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/basics.dart';
import '../../providers/i18n.dart';
import '../../utils/services/http_exception.dart';
import '../../utils/utils.dart';
import '../../widgets/advanced_search.dart';
import '../../widgets/menu_picker.dart';
import '../../widgets/responsive.dart';
import 'colorful_line_widget.dart';
import 'doc_search_form.dart';
import 'document_tracking_stepper.dart';
import 'qr_and_barcode_screen.dart';

class DocumentTrackingScreen extends StatefulWidget {
  static const routeName = '/documentTracking';

  const DocumentTrackingScreen({super.key});

  @override
  State<DocumentTrackingScreen> createState() => _DocumentTrackingScreenState();
}

class _DocumentTrackingScreenState extends State<DocumentTrackingScreen> {
  late final i18n i;
  late final Basics bpr;

  bool _isLoading = false;
  late Future<void> _futureInstance;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      bpr = Provider.of<Basics>(context);
      i = Provider.of<i18n>(context, listen: false);
      _futureInstance = _runFetchAndSetInitialBasics();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _runFetchAndSetInitialBasics() async {
    // await Future.wait([
    //   bpr.initialBasicsFetchAndSet(),
    //   bpr.fetchAndSetDocHistoryMaps(),
    //   bpr.fetchDocHistorys(),
    // ]);

    return;
  }

  @override
  Widget build(BuildContext context) {
    print(
        '++++++++++++++++++++++++     DocumentTrackingScreen build     ++++++++++++++++++++++++');
    // final Basics bpr = Provider.of<Basics>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _futureInstance,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Column(
                  children: [
                    const SizedBox(height: 12),
                    const ColorfulLine(
                      height: 2,
                      colors: [
                        kPrimaryLightColor,
                        kPrimaryMediumColor,
                        kPrimaryColor,
                        Colors.orange,
                      ],
                    ),
                    // History Search Option
                    // _buildOptionCard(
                    //   context: context,
                    //   icon: Icons.history,
                    //   title: 'نوسراوەکانی پێشتر',
                    //   subtitle: 'ئەو نوسراوانەی پێشتر بەدوای گەڕاوی',
                    //   onTap: () {},
                    // ),

                    // Manual Enter Document Data Option
                    _buildOptionCard(
                      context: context,
                      icon: Icons.edit,
                      title: 'گەڕانی نوسراو',
                      subtitle: 'زانیاری نوسراو بنوسە',
                      onTap: () {
                        DocSearchForm qrAndBarCode = DocSearchForm(
                          onSelect: (Map<String, dynamic> docSearchData) {
                            _onSubmit(docSearchData);
                          },
                        );
                        _onTap(context, qrAndBarCode, "گەڕانی نوسراو");
                      },
                    ),

                    // QR and Barcode Scanner Option
                    _buildOptionCard(
                      context: context,
                      icon: Icons.qr_code_scanner,
                      title: 'کیو ئاڕکۆد',
                      subtitle: 'نوسراوەکە سکان بکە',
                      onTap: () {
                        QRBarcodeScannerScreen qrandBarCode =
                            QRBarcodeScannerScreen(
                          onDetect: (BarcodeCapture capture) {
                            final List<Barcode> barcodes = capture.barcodes;
                            final Barcode barcode = barcodes.first;
                            final code = barcode.rawValue ?? '---';

                            Map<String, String>? urlData =
                                Utils.extractDocSearchUrlData(code);
                            if (urlData != null) {
                              _onSubmit(urlData);
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('کۆدەکەت دروست نییە'),
                              ));
                            }
                          },
                        );
                        _onTap(context, qrandBarCode, "کیوئاڕکۆد");
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildHistoryMenuPicker,

                    const SizedBox(height: 16),
                    const DocumentTrackingStepper(),
                    if (bpr.searchedDocTrackingData.isNotEmpty)
                      _buildToggleHistoryStatus(),
                    const SizedBox(height: 16),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  FloatingActionButton _buildToggleHistoryStatus() {
    bool isDocInHistory = bpr.getDocHistoryStatus(bpr.docSearchData);

    IconData fabIcon = isDocInHistory ? Icons.delete : Icons.add;
    String fabText = isDocInHistory ? 'سڕینەوە' : 'زیادکردن';

    // then make the onPressed to call the function to toggle the status
    void toggleDocHistoryStatus() {
      setState(() {
        bpr.toggleDocHistoryStatus(bpr.docSearchData, true);
      });
    }

    // then return the floating action button
    return FloatingActionButton.extended(
      onPressed: toggleDocHistoryStatus,
      label: Text(
        fabText,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Plex Sans Regular',
        ),
      ),
      icon: Icon(fabIcon, color: Colors.white),
      backgroundColor: kPrimaryColor,
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

  MenuPicker get _buildHistoryMenuPicker {
    return MenuPicker(
      allElements: bpr.docHistoryMaps,
      maSecName: const ['refNo', 'refDate'],
      initialSelected: bpr.docSearchData['id'] == ''
          ? []
          : [
              bpr.docSearchData['id']
            ], // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          false, // Set to false to allow only single selection.
      // If set to true, ensure _authData['city'] is a List.
      // Otherwise, selectedHandler will return List<int> instead of int.
      selectedHandler: (selectedDocId) {
        Map<String, dynamic> selectedDoc = bpr.docHistoryMaps.firstWhere(
          (doc) => doc['id'] == selectedDocId,
          orElse: () => {},
        );
        _onSubmit(selectedDoc);
      },
      isScrollControlled:
          false, //to Maximize BottomSheet, if you set to "true", assign "heightFactor" < 1 ,ex 0.9 OTHERWISE 1
      heightFactor: 1,
      title: "گەڕانەکانی پێشتر",
      // borderRadius: 40.0, // default
      selectedColorOfPicker: kPrimaryColor,
      selectButtonText: i.tr('Continue'),
      searchVisible: false,
      isSecondaryVisible: true,
      isEnabled: !_isLoading,
      isValidated: true,
    );
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
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Plex Sans Medium',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Plex Sans Regular',
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        dense: true,
        onTap: onTap,
      ),
    );
  }

  Future<void> _onSubmit(Map<String, dynamic> data) async {
    // if (!_formKey.currentState!.validate()) {
    //   // Invalid!
    //   return;
    // }
    // _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      await bpr.searchDoc(data);

      // Navigator.of(context)
      //     .pop(); // to pop off in the navigator
    } on HttpException {
      var errorMessage = i.tr('m58');
      // String e = error.toString();
      // if (e.contains('username already exists')) {
      //   errorMessage = i.tr('m45');
      // }
      // if (e.contains('EMAIL_EXISTS')) {
      //   errorMessage = 'This email address is already in use.';
      // } else if (e.contains('INVALID_EMAIL')) {
      //   errorMessage = 'This is not a valid email address';
      // } else if (e.contains('WEAK_PASSWORD')) {
      //   errorMessage = 'This password is too weak.';
      // } else if (e.contains('EMAIL_NOT_FOUND')) {
      //   errorMessage = 'Could not find a user with that email.';
      // } else if (e.contains('INVALID_PASSWORD')) {
      //   errorMessage = 'Invalid password.';
      // }
      Utils.showErrorDialog(context, errorMessage);
    } catch (error) {
      String errorMessage = error.toString(); // i.tr('m14');
      Utils.showErrorDialog(context, errorMessage);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
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
