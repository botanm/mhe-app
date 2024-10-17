import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../widgets/responsive.dart';
import 'square_card.dart';

class SquareCardsStatistics extends StatelessWidget {
  const SquareCardsStatistics({
    super.key,
    required this.title,
    required this.btnLabel,
    required this.statsInfo,
  });
  final String title;
  final String btnLabel;
  final List<dynamic> statsInfo;

  @override
  Widget build(BuildContext context) {
    print('*************** square_cards_statistics build ***************');
    final double w = Responsive.w(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       title,
          //       style: Theme.of(context).textTheme.titleMedium,
          //     ),
          //     ElevatedButton.icon(
          //       style: TextButton.styleFrom(
          //           padding: EdgeInsets.symmetric(
          //             horizontal: defaultPadding * 1.5,
          //             vertical:
          //                 defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
          //           ),
          //           backgroundColor: kPrimaryColor),
          //       onPressed: () {},
          //       icon: const Icon(Icons.add, color: KScaffoldBackgroundColor),
          //       label: Text(btnLabel,
          //           style: const TextStyle(color: KScaffoldBackgroundColor)),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: defaultPadding),
          Responsive(
            mobile: (BuildContext context) => SquareCardsGridView(
              crossAxisCount: w < 650 ? 2 : 4,
              childAspectRatio: w < 650 && w > 350 ? 1.3 : 1,
              statsInfo: statsInfo,
            ),
            tablet: (BuildContext context) => SquareCardsGridView(
              crossAxisCount: 2,
              statsInfo: statsInfo,
            ),
            desktop: (BuildContext context) => SquareCardsGridView(
              childAspectRatio: w < 1400 ? 1.1 : 1.4,
              statsInfo: statsInfo,
            ),
          ),
        ],
      ),
    );
  }
}

class SquareCardsGridView extends StatelessWidget {
  const SquareCardsGridView({
    super.key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.statsInfo,
  });

  final int crossAxisCount;
  final double childAspectRatio;
  final List<dynamic> statsInfo;

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: statsInfo.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: isMobile ? defaultPadding / 3 : defaultPadding,
        mainAxisSpacing: isMobile ? defaultPadding / 3 : defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => SquareCard(info: statsInfo[index]),
    );
  }
}
