import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import 'chart.dart';
import 'rectangle_card.dart';

class ChartStatistics extends StatelessWidget {
  const ChartStatistics({
    super.key,
    required this.title,
    this.showChartSectionsTitle = false,
    required this.chartSectionsColor,
    required this.chartSectionsInfo,
    required this.rectangleCardsInfo,
  });
  final String title;
  final bool showChartSectionsTitle;
  final List<Color> chartSectionsColor;
  final List<Map<String, dynamic>> chartSectionsInfo;
  final List<Map<String, dynamic>> rectangleCardsInfo;

  @override
  Widget build(BuildContext context) {
    print('*************** chart_statistics build ***************');
    final bool isCsiEmpty = chartSectionsInfo.isEmpty;
    final bool isRciEmpty = rectangleCardsInfo.isEmpty;
    return Container(
      padding: EdgeInsets.all((isCsiEmpty && isRciEmpty) ? 0 : defaultPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCsiEmpty)
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: defaultPadding),
          if (!isCsiEmpty)
            Chart(
                showChartSectionsTitle: showChartSectionsTitle,
                chartSectionsColor: chartSectionsColor,
                chartSectionsInfo: chartSectionsInfo),
          if (!isRciEmpty)
            ...rectangleCardsInfo.map((e) => RectangleCard(
                  svgSrc: e['svgSrc'],
                  title: e['title'],
                  subtitle: e['subtitle'],
                  trailing: e['trailing'],
                ))
        ],
      ),
    );
  }
}
