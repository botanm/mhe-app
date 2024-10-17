import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/spalsh';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // print('*************** splash_screen build ***************');
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          const SizedBox(
            child: Icon(
              Icons.devices_other_outlined,
              color: kPrimaryColor,
              size: 80,
            ),
          ),
          SizedBox(
            child: Column(
              children: [
                const Text(
                  'from',
                  style: TextStyle(color: kPrimaryMediumColor),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 1, bottom: 1, right: 4, left: 4),
                      decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'M',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Text(
                      ' OHE',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
