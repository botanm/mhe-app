import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    this.showChartSectionsTitle = false,
    required this.chartSectionsColor,
    required this.chartSectionsInfo,
  });
  final bool showChartSectionsTitle;
  final List<Color> chartSectionsColor;
  final List<Map<String, dynamic>> chartSectionsInfo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: paiChartSelectionDatas(showChartSectionsTitle,
                  chartSectionsColor, chartSectionsInfo),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding),
                Text(
                  chartSectionsInfo[0]['value'].toString(),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                Text(
                  chartSectionsInfo[0]['chartCenterSubtitle'].toString(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> paiChartSelectionDatas(
      bool showTitle, List<Color> colors, List<Map<String, dynamic>> info) {
    final List<double> radiuses = [25, 22, 19, 16, 13];
    return info.map(
      (e) {
        int i = info.indexOf(e);
        return PieChartSectionData(
          title: e['title'],
          color: colors[i],
          value: e['value'].toDouble(),
          showTitle: showTitle,
          radius: radiuses[i],
        );
      },
    ).toList();
  }
}
