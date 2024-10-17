import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/i18n.dart';
import 'responsive.dart';

class AdvancedSearchPickerMainAppbar extends StatefulWidget {
  const AdvancedSearchPickerMainAppbar({
    required this.advancedSearch,
    this.searchContainer,
    super.key,
  });

  final Widget advancedSearch;
  final Map<String, dynamic>? searchContainer;

  @override
  State<AdvancedSearchPickerMainAppbar> createState() =>
      _AdvancedSearchPickerMainAppbarState();
}

class _AdvancedSearchPickerMainAppbarState
    extends State<AdvancedSearchPickerMainAppbar> {
  late final i18n i;
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
              // filled: true,
              fillColor: kPrimaryLightColor,
              iconColor: kPrimaryColor,
              prefixIconColor: kPrimaryColor,
              suffixIconColor: kPrimaryMediumColor,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(color: kPrimaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(color: kPrimaryMediumColor),
              ))),
      child: TextField(
        readOnly: true,
        onTap: () => _onTap(context),
        decoration: InputDecoration(
          hintStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          hintText: i.tr(widget.searchContainer == null ? "Search" : "m83"),
          suffixIcon: InkWell(
            onTap: () => _onTap(context),
            child: Container(
              padding: const EdgeInsets.all(defaultPadding * 0.75),
              margin:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset("assets/icons/Search.svg"),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) async {
    final double w = Responsive.w(context);
    final bool isLargeTablet = Responsive.isLargeTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final bool isLargeDesktop = Responsive.isLargeDesktop(context);

    if (w < 1200) {
      await showModalBottomSheet(
        isScrollControlled: true, //to Maximize BottomSheet
        shape: kBuildTopRoundedRectangleBorder,
        context: context,
        builder: (ctx) => FractionallySizedBox(
            heightFactor: isLargeTablet ? 0.7 : 0.9,
            child: widget.advancedSearch),
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
                child: widget.advancedSearch,
              ),
            );
          });
    }
  }
}
