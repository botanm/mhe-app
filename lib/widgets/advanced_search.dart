import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/i18n.dart';
import '../utils/utils.dart';
import 'responsive.dart';

class AdvancedSearch extends StatefulWidget {
  const AdvancedSearch({required this.searchForm, this.title, super.key});
  final Widget searchForm;
  final String? title;

  @override
  State<AdvancedSearch> createState() => _AdvancedSearchState();
}

class _AdvancedSearchState extends State<AdvancedSearch> {
  @override
  Widget build(BuildContext context) {
    final i18n i = Provider.of<i18n>(context, listen: false);
    final bool isMobile = Responsive.isMobile(context);
    String? title = widget.title ?? i.tr("Advanced Search");
    return Column(
      children: [
        Utils.handle(context),
        Text(
          title,
          style: TextStyle(
              fontSize: isMobile ? 16 : 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 12),
            child: widget.searchForm,
          ),
        )
      ],
    );
  }
}
