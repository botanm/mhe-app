import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/auth.dart';
import '../../providers/basics.dart';
import '../../providers/i18n.dart';
import '../../widgets/advanced_search.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/responsive.dart';
import 'salary_search_form.dart';
import 'textformfieldlike_widget.dart';

class SalaryScreen extends StatefulWidget {
  static const routeName = '/salary';
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  bool _isInit = true;
  late final i18n i;
  late final Basics bpr;
  late final Auth apr;
  late final Map<String, dynamic> info;
  late final Map<String, dynamic> personalInfo;

  late Future<void> _futureInstance;

  Future<void> _getData() async {
    await bpr.fetchAndSetSalary(null, null);
    info = bpr.salary;
    personalInfo = apr.me!;

    return;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(context);
      apr = Provider.of<Auth>(context);

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
          title: const Text("مووچە و دەرماڵە"),
          actions: [
            IconButton(
                onPressed: () {
                  _onTap(context);
                },
                icon: const Icon(
                  Icons.search,
                  color: kPrimaryColor,
                ))
          ],
        ),
        body: FutureBuilder(
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
            }),
      ),
    );
  }

  void _onTap(BuildContext context) async {
    final double w = Responsive.w(context);
    final bool isLargeTablet = Responsive.isLargeTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final bool isLargeDesktop = Responsive.isLargeDesktop(context);
    const ssf = SalarySearchForm();

    if (w < 1200) {
      await showModalBottomSheet(
        isScrollControlled: true, //to Maximize BottomSheet
        shape: kBuildTopRoundedRectangleBorder,
        context: context,
        builder: (ctx) {
          return FractionallySizedBox(
              heightFactor: isLargeTablet ? 0.7 : 0.9,
              child: const AdvancedSearch(searchForm: ssf));
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
                child: const AdvancedSearch(searchForm: ssf),
              ),
            );
          });
    }
  }

  SingleChildScrollView _buildDispaly() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
        child: Column(
          children: [
            _buildTextField(
                'زنجیرە',
                bpr.salary['code'].toString(),
                const Icon(Icons.confirmation_number_outlined,
                    color: kPrimaryColor),
                true),
            if (bpr.salary['accountNo'] != null)
              _buildTextField(
                  'ژمارەی هەژمار',
                  bpr.salary['accountNo'],
                  const Icon(Icons.account_box_outlined, color: kPrimaryColor),
                  true),
            _buildTextField('مانگ', bpr.salary['month'],
                const Icon(Icons.calendar_month, color: kPrimaryColor), true),
            _buildTextField('ساڵ', bpr.salary['year'],
                const Icon(Icons.date_range, color: kPrimaryColor), true),
            _buildTextField(
                'جۆر',
                bpr.salary['employeeSalaryType'],
                const Icon(Icons.merge_type_outlined, color: kPrimaryColor),
                true),
            if (bpr.salary['sabbaticalType'] != null)
              _buildTextField(
                  'جۆری تفرغ',
                  bpr.salary['sabbaticalType'],
                  const Icon(Icons.merge_type_rounded, color: kPrimaryColor),
                  true),
            _buildTextField(
                'مووچەی بنەڕەتی',
                formatWithCommas(bpr.salary['totalBasicSalary']),
                const Icon(Icons.attach_money, color: kPrimaryColor),
                true),
            if (bpr.salary['totalIncrease'] > 0)
              _buildTextField(
                  'کۆی دەرماڵەکان',
                  formatWithCommas(bpr.salary['totalIncrease']),
                  const Icon(Icons.attach_money, color: kPrimaryColor),
                  true),
            _buildTextField('شایستە', formatWithCommas(bpr.salary['netAmount']),
                const Icon(Icons.attach_money, color: kPrimaryColor), true),
            _buildTextField(
                'خانەنشینی',
                formatWithCommas(bpr.salary['retirement']),
                const Icon(Icons.attach_money, color: kPrimaryColor),
                true),
            _buildTextField(
                'بڕی چەك بەبێ لێبڕین',
                formatWithCommas(bpr.salary['chequeAmount']),
                const Icon(Icons.attach_money, color: kPrimaryColor),
                true),
            if (bpr.salary['totalDecrease'] > 0)
              _buildTextField(
                  'بڕی لێبڕین',
                  formatWithCommas(bpr.salary['totalDecrease']),
                  const Icon(Icons.attach_money, color: kPrimaryColor),
                  true),
            _buildTextField(
                'بڕی مووچە دوای لێبڕینەکان',
                formatWithCommas(bpr.salary['paidAmount']),
                const Icon(Icons.attach_money, color: kPrimaryColor),
                true),
            const SizedBox(height: 20),
            _buildIncreaseSalary(),
            const SizedBox(height: 20),
            _buildAllowances(),
            const SizedBox(height: 20),
            _buildDeacreases()
          ],
        ),
      ),
    );
  }

  TextFormFieldLikeWidget _buildTextField(
      String label, dynamic value, Widget icon, bool isTextRtl) {
    return TextFormFieldLikeWidget(
      label: label,
      value: value,
      icon: icon,
      // suffixIcon: Icon(Icons.info_outline),
      isTextRtl: isTextRtl,
    );
  }

  Widget _buildIncreaseSalary() {
    return Column(
      children: [
        GradientButton(
          text: "سەرمووچە",
          onPressed: () {},
        ),
        _buildTextField(
            'سەرمووچەی داهاتوو',
            personalInfo['nextSalaryIncreaseDate'].split(' ')[0],
            const Icon(Icons.date_range, color: kPrimaryColor),
            true),
        _buildTextField('پلەی داهاتوو', personalInfo['nextGrade'].split(' ')[0],
            const Icon(Icons.grade_outlined, color: kPrimaryColor), true),
        _buildTextField(
            'مەرتەبەی داهاتوو',
            personalInfo['nextRank'].split(' ')[0],
            const Icon(Icons.leaderboard_outlined, color: kPrimaryColor),
            true),
      ],
    );
  }

  Widget _buildAllowances() {
    return Column(
      children: [
        GradientButton(
          text: "دەرماڵەکان",
          onPressed: () {},
        ),
        if (bpr.salary['gravity'] > 0)
          _buildAllowance(
              title: 'ترسناکی',
              value: bpr.salary['gravity'],
              rate: bpr.salary['gravityRate']),
        if (bpr.salary['engineering'] > 0)
          _buildAllowance(
              title: 'ئەندازیاری',
              value: bpr.salary['engineering'],
              rate: bpr.salary['engineeringRate']),
        if (bpr.salary['certificate'] > 0)
          _buildAllowance(
              title: 'بڕوانامە',
              value: bpr.salary['certificate'],
              rate: bpr.salary['certificateRate']),
        if (bpr.salary['rankRate'] > 0)
          _buildAllowance(
              title: 'پایە',
              value: bpr.salary['rankRate'],
              rate: bpr.salary['rankRate']),
        if (bpr.salary['emptied'] > 0)
          _buildAllowance(
              title: 'تفرغ',
              value: bpr.salary['emptied'],
              rate: bpr.salary['emptiedRate']),
        if (bpr.salary['scientificTitle'] > 0)
          _buildAllowance(
              title: 'نازناوی زانستی',
              value: bpr.salary['scientificTitle'],
              rate: bpr.salary['scientificTitleRate']),
        if (bpr.salary['children'] > 0)
          _buildAllowance(
              title: 'منداڵ', value: bpr.salary['children'], rate: null),
        if (bpr.salary['family'] > 0)
          _buildAllowance(
              title: 'خێزانداری', value: bpr.salary['family'], rate: null),
        if (bpr.salary['exception'] > 0)
          _buildAllowance(
              title: 'استثناء', value: bpr.salary['exception'], rate: null),
        if (bpr.salary['allocation'] > 0)
          _buildAllowance(
              title: 'بڕاوە', value: bpr.salary['allocation'], rate: null),
        if (bpr.salary['geographical'] > 0)
          _buildAllowance(
              title: 'شوێنی جوگرافی',
              value: bpr.salary['geographical'],
              rate: null),
      ],
    );
  }

  Widget _buildDeacreases() {
    return Column(
      children: [
        GradientButton(
          text: "لێبڕاوەکان",
          onPressed: () {},
        ),
        if (bpr.salary['apartmentRentRate'] > 0)
          _buildTextField(
              'ڕێژەی کرێی شووقە',
              formatWithCommas(bpr.salary['apartmentRentRate']),
              const Icon(Icons.attach_money, color: kPrimaryColor),
              true),
        if (bpr.salary['apartmentRent'] > 0)
          _buildTextField(
              'ڕێژەی کرێی شووقە',
              formatWithCommas(bpr.salary['apartmentRent']),
              const Icon(Icons.attach_money, color: kPrimaryColor),
              true),
        if (bpr.salary['generalJusticeChambers'] > 0)
          _buildTextField(
              'ب.جێ بەجێ کردنی هەولێر',
              formatWithCommas(bpr.salary['generalJusticeChambers']),
              const Icon(Icons.attach_money, color: kPrimaryColor),
              true),
        if (bpr.salary['loanGeneralJusticeChambers'] > 0)
          _buildTextField(
              'ب.جێ بەجێ کردنی قەرزی هەولێر',
              formatWithCommas(bpr.salary['loanGeneralJusticeChambers']),
              const Icon(Icons.attach_money, color: kPrimaryColor),
              true),
        if (bpr.salary['erbilBankEstate1'] > 0)
          _buildTextField(
              'بانکی خانووبەرەی هەولێر ١',
              formatWithCommas(bpr.salary['erbilBankEstate1']),
              const Icon(Icons.attach_money, color: kPrimaryColor),
              true),
        if (bpr.salary['erbilBankEstate2'] > 0)
          _buildTextField(
              'بانکی خانووبەرەی هەولێر ٢',
              formatWithCommas(bpr.salary['erbilBankEstate2']),
              const Icon(Icons.attach_money, color: kPrimaryColor),
              true),
        if (bpr.salary['sulaymaniyahBankEstate'] > 0)
          _buildTextField(
              'بانکی خانووبەرەی سلێمانی',
              formatWithCommas(bpr.salary['sulaymaniyahBankEstate']),
              const Icon(Icons.attach_money, color: kPrimaryColor),
              true),
        if (bpr.salary['advanceMarriage'] > 0)
          _buildTextField(
              'پێشینەی هاوسەرگیری',
              formatWithCommas(bpr.salary['advanceMarriage']),
              const Icon(Icons.attach_money, color: kPrimaryColor),
              true),
        if (bpr.salary['directorateTreasury'] > 0)
          _buildTextField(
              'بەڕێوبەرایەتی گەنجینەی هەرێم',
              formatWithCommas(bpr.salary['directorateTreasury']),
              const Icon(Icons.attach_money, color: kPrimaryColor),
              true),
        if (bpr.salary['leaveAmount'] > 0)
          _buildTextField(
              'دابڕانی بێ هۆ بۆ ${bpr.salary['noOfDaysLeave']} ڕۆژ',
              formatWithCommas(bpr.salary['leaveAmount']),
              const Icon(Icons.attach_money, color: kPrimaryColor),
              true),
        if (bpr.salary['childExpenseGeneralJusticeChamber'] > 0)
          _buildTextField(
              'خەرجی منداڵ',
              formatWithCommas(bpr.salary['childExpenseGeneralJusticeChamber']),
              const Icon(Icons.attach_money, color: kPrimaryColor),
              true),
      ],
    );
  }

  TextFormFieldLikeWidget _buildAllowance(
      {required String title, required num value, double? rate}) {
    String formattedValue = formatWithCommas(value);
    String formattedRate = rate == null ? '' : formatToPercentage(rate);

    return _buildTextField(
        title,
        formattedValue,
        rate == null
            ? const Icon(Icons.lock_outline, color: kPrimaryColor)
            : Text(formattedRate, style: const TextStyle(color: kPrimaryColor)),
        true);
  }

  String formatWithCommas(num value) {
    // Convert the number to a string and split it at the decimal point
    String numString = value.toStringAsFixed(0); // Keep only the integer part
    int length = numString.length;

    // Iterate over the string and insert commas
    StringBuffer formatted = StringBuffer();
    for (int i = 0; i < length; i++) {
      // Append the character
      formatted.write(numString[i]);

      // Insert a comma every 3 digits from the right, except at the start
      if ((length - i - 1) % 3 == 0 && i != length - 1) {
        formatted.write(',');
      }
    }

    return formatted.toString();
  }

  String formatToPercentage(double value) {
    int percentage = (value * 100).round();
    return '$percentage%';
  }
}
