import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/basics.dart';
import '../providers/core.dart';
import '../providers/i18n.dart';
import '../utils/utils.dart';
import 'carousel_slider_widget.dart';
import 'gradient_button.dart';

class EquipmentDetailWidget extends StatefulWidget {
  const EquipmentDetailWidget({required this.id, super.key});
  final int id;

  @override
  State<EquipmentDetailWidget> createState() => _EquipmentDetailWidgetState();
}

class _EquipmentDetailWidgetState extends State<EquipmentDetailWidget> {
  bool _isInit = true;
  late final i18n i;
  late final Basics bpr;
  late final Core cpr;
  late final Map<String, dynamic> info;

  late Future<void> _futureInstance;

  Future<void> _getEquipmentData() async {
    info = cpr.findQuestionById(widget.id);

    return;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);
      cpr = Provider.of<Core>(context);

      _futureInstance = _getEquipmentData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureInstance,
        builder: (ctx, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return kCircularProgressIndicator;
          } else {
            if (asyncSnapshot.hasError) {
              // ...
              // Do error handling stuff
              return Center(child: Text('${asyncSnapshot.error}'));
              //return Center(child: Text('An error occurred!'));
            } else {
              return _buildDispaly();
            }
          }
        });
  }

  Column _buildDispaly() {
    return Column(
      children: [
        _buildSlider,
        _buildContent,
      ],
    );
  }

  CarouselSliderWidget get _buildSlider {
    return CarouselSliderWidget(
      imgUrls: [
        info['image0'] ?? 'images/researchers-01.jpg',
        info['image1'] ?? 'images/researchers-02.jpg',
        info['image2'] ?? 'images/researchers-03.jpg',
      ],
    );
  }

  Widget get _buildContent {
    return Column(
      children: [
        const SizedBox(height: defaultPadding * 2),
        Text(info[i.maSecBasicName[0]],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('${i.tr('Manufacturer')}: ${info['manufacturer']}',
            style: const TextStyle(fontSize: 13, color: Colors.black38)),
        Text('${i.tr('Model')}: ${info['model']}',
            style: const TextStyle(fontSize: 13, color: Colors.black38)),
        Text('${i.tr('Year')}: ${info['year']}',
            style: const TextStyle(fontSize: 13, color: Colors.black38)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildUrlLauncher(Icons.link, () {
              Utils.openBrowserUrl(url: info['detail_link'], inApp: true);
            }),
          ],
        ),
        const SizedBox(height: 16),
        const FractionallySizedBox(widthFactor: 0.8, child: Divider()),
        const SizedBox(height: 16),
        buildAbout,
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildUrlLauncher(IconData icon, void Function() onTap) =>
      GradientButton(onPressed: onTap, text: i.tr("Detail link"));

  Widget get buildAbout {
    final List<dynamic> tags = info['tags'] ?? [];
    List<dynamic> allTagTexts = [];
    final List<dynamic> generalSpecializationIds =
        info["general_specialization_id"];

    if (generalSpecializationIds.isNotEmpty) {
      List<String> generalSpecializationText = Utils.getTextById(
          generalSpecializationIds, bpr.categories, i.maSecBasicName[0]);
      allTagTexts = tags + generalSpecializationText;
    }
    List<int> allParents = info['organization_id'] == null
        ? []
        : Utils.getAllParents([], info['organization_id'], bpr.cities);

    final allParentsText =
        Utils.joinTexts(allParents, bpr.cities, i.maSecBasicName[0], ' >>');

    final String? aboutText = info[i.maSecAbout[0]];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(i.tr('About'),
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(allParentsText,
              style: const TextStyle(fontSize: 13, color: Colors.black38)),
          Text(allTagTexts.join(',  '),
              style: const TextStyle(fontSize: 13, color: Colors.black38)),
          const SizedBox(height: 16),
          if (aboutText != null)
            Text(aboutText, style: const TextStyle(fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }
}
