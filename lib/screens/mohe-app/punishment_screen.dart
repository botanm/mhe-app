import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/basics.dart';
import '../../providers/i18n.dart';
import '../../utils/utils.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/textformfield_widget.dart';

class PunishmentScreen extends StatefulWidget {
  static const routeName = '/punishment';
  const PunishmentScreen({super.key});

  @override
  State<PunishmentScreen> createState() => _PunishmentScreenState();
}

class _PunishmentScreenState extends State<PunishmentScreen> {
  bool _isInit = true;
  late final i18n i;
  late final Basics bpr;
  late final List<dynamic> punishments;

  late Future<void> _futureInstance;

  Future<void> _getData() async {
    await bpr.fetchAndSetPunishments();
    punishments = bpr.punishments;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);

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
          title: const Text("سزا"),
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
      itemCount: punishments.length,
      itemBuilder: (ctx, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientButton(
              text: punishments[index]['punishmentTypeName'],
              onPressed: () {},
            ),
            _buildTextField(
              'لایەنی سزادەر',
              punishments[index]['punishedSide'],
              Icons.topic,
            ),
            _buildTextField(
                'هۆکار', punishments[index]['reason'], Icons.category),
            if (punishments[index]['startDate'] != null)
              _buildTextField(
                  'بەرواری سەرەتا',
                  punishments[index]['startDate'].split(' ')[0],
                  Icons.date_range),
            if (punishments[index]['endDate'] != null)
              _buildTextField(
                  'بەرواری کۆتا',
                  punishments[index]['endDate'].split(' ')[0],
                  Icons.date_range),
            _buildTextField('ژمارەی نوسراو', punishments[index]['docNo'],
                Icons.insert_drive_file),
            _buildTextField('بەرواری نوسراو',
                punishments[index]['docDate'].split(' ')[0], Icons.date_range),

            if (punishments[index]['description'] != null)
              _buildTextField('ڕوونکردنەوە', punishments[index]['description'],
                  Icons.announcement_outlined),
            if (punishments[index]['attachment'] != null)
              _buildUrlLauncher(Icons.link, () {
                Utils.openBrowserUrl(
                    url: punishments[index]['attachment'], inApp: true);
              }),
            const SizedBox(height: 16), // Add spacing between items
          ],
        );
      },
    );
  }

  Widget _buildUrlLauncher(IconData icon, void Function() onTap) =>
      TextButton.icon(
        onPressed: onTap,
        label: const Text("هاوپێچ"),
        icon: const Icon(Icons.attach_file_outlined),
      );

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
