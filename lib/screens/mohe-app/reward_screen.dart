import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/basics.dart';
import '../../providers/core.dart';
import '../../providers/i18n.dart';
import '../../utils/utils.dart';
import '../../widgets/textformfield_widget.dart';
import 'colorful_line_widget.dart';

class RewardScreen extends StatefulWidget {
  static const routeName = '/reward';
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  bool _isInit = true;
  late final i18n i;
  late final Basics bpr;
  late final Core cpr;
  late final List<dynamic> rewards;

  late Future<void> _futureInstance;

  Future<void> _getData() async {
    await bpr.fetchAndSetRewards();
    rewards = bpr.rewards;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);
      cpr = Provider.of<Core>(context);

      _futureInstance = _getData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("پاداشت"),
        ),
        body: FutureBuilder(
          future: _futureInstance,
          builder: (ctx, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return kCircularProgressIndicator;
            } else if (asyncSnapshot.hasError) {
              return Center(
                  child: Text('An error occurred: ${asyncSnapshot.error}'));
            } else {
              return _buildDisplay();
            }
          },
        ),
      ),
    );
  }

  Widget _buildDisplay() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      itemCount: rewards.length,
      itemBuilder: (ctx, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ColorfulLine(
              height: 5,
              width: 300,
              colors: [
                kPrimaryLightColor,
                kPrimaryMediumColor,
                kPrimaryColor,
                Colors.orange,
              ],
            ),

            _buildTextField(
                'بڕی پارە', rewards[index]['amount'], Icons.category),

            _buildTextField('ژمارەی نوسراو', rewards[index]['docNo'],
                Icons.insert_drive_file),
            _buildTextField('بەرواری نوسراو',
                rewards[index]['docDate'].split(' ')[0], Icons.date_range),

            if (rewards[index]['description'] != null)
              _buildTextField('ڕوونکردنەوە', rewards[index]['description'],
                  Icons.announcement_outlined),
            if (rewards[index]['attachment'] != null)
              _buildUrlLauncher(Icons.link, () {
                Utils.openBrowserUrl(
                    url: rewards[index]['attachment'], inApp: true);
              }),
            const SizedBox(height: 16), // Add spacing between items
          ],
        );
      },
    );
  }

  Widget _buildUrlLauncher(IconData icon, void Function() onTap) =>
      TextButton(onPressed: onTap, child: const Text("هاوپێچ"));

  TextFormFieldWidget _buildTextField(
      String label, dynamic value, IconData icon) {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: value,
      icon: icon,
      label: label,
      enabled: false,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      maxLines: null,
      validatorHandler: (val) {
        if (val!.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
    );
  }
}
