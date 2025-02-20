import 'package:flutter/material.dart';

import '../constants/app_constants.dart' as app_constants;
import '../constants/app_constants.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    this.isSubmitButtonDisabled = false,
    required this.text,
    this.height = 50.0,
    this.disabledText,
    this.background = kPrimaryColor,
    this.foreground = kPrimaryLightColor,
    this.keepOrigin = false,
    required this.onPressedHandler,
  });

  final bool isSubmitButtonDisabled;
  final String text;
  final double height;
  final String? disabledText;
  final Color? background;
  final Color? foreground;
  final bool keepOrigin;
  final VoidCallback? onPressedHandler;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: !isSubmitButtonDisabled ? onPressedHandler : null,
        style: ElevatedButton.styleFrom(
          maximumSize: keepOrigin ? null : Size(double.infinity, height),
          minimumSize: keepOrigin ? null : Size(double.infinity, height),
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: kPrimaryLightColor,
          elevation: keepOrigin ? null : 5,
          shape: keepOrigin ? null : const StadiumBorder(),
          // : RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(24.0),
          //   ),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              isSubmitButtonDisabled ? disabledText ?? '' : text,
              style: keepOrigin
                  ? null
                  : const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Plex Sans Regular',
                    ),
            ),
            const Spacer(),
            if (isSubmitButtonDisabled)
              const SizedBox(
                height: 20.0,
                width: 20.0,
                child: app_constants.kCircularProgressIndicator,
              ),
          ],
        ),
      );
}
