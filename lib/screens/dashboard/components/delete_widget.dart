import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';
import '../../../constants/app_constants.dart';
import '../../../providers/basics.dart';
import '../../../providers/core.dart';
import '../../../providers/i18n.dart';
import '../../../utils/services/http_exception.dart';
import '../../../widgets/submit_button.dart';

class DeleteWidget extends StatefulWidget {
  const DeleteWidget({super.key, required this.deletePayload});
  final Map<String, String> deletePayload;

  @override
  State<DeleteWidget> createState() => _DeleteWidgetState();
}

class _DeleteWidgetState extends State<DeleteWidget> {
  late final i18n i;
  bool _isDeleting = false;
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
    // print('*************** delete_widget build ***************');
    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Utils.handle(context),
          _buildBody,
        ],
      ),
    );
  }

  Flexible get _buildBody {
    return Flexible(
      child: ListView(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        children: [
          _buildHeader,
          const SizedBox(height: 16),
          _buildMessage,
          const SizedBox(height: 10),
          _buildDeleteActions,
        ],
      ),
    );
  }

  Row get _buildHeader {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black54),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Expanded(
            child: Center(
                child: Text(i.tr('m26'),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)))),
      ],
    );
  }

  Center get _buildMessage {
    return Center(child: Text(widget.deletePayload['message']!));
  }

  Column get _buildDeleteActions {
    return Column(children: [
      SubmitButton(
          isSubmitButtonDisabled: false,
          text: i.tr('Cancel'),
          height: 40,
          disabledText: i.tr('Cancel'),
          background: kPrimaryLightColor,
          foreground: Colors.black,
          onPressedHandler: () {
            Navigator.of(context).pop();
          }),
      SubmitButton(
          isSubmitButtonDisabled: _isDeleting,
          text: i.tr('Delete'),
          height: 40,
          disabledText: 'Deleting',
          // background: Colors.grey.shade400,
          // foreground: Colors.black,
          onPressedHandler: () => _onDelete(context))
    ]);
  }

  Future<void> _onDelete(context) async {
    setState(() => _isDeleting = true);

    final Basics bpr = Provider.of<Basics>(context, listen: false);
    final Core cpr = Provider.of<Core>(context, listen: false);

    final String typeName = widget.deletePayload['name']!;
    final String id = widget.deletePayload['id']!;

    try {
      if (typeName == "user") {
        cpr.deleteUser(id);
      } else if (typeName == "equipments") {
        cpr.deleteQuestion(id);
      }
      // else if (typeName == "answeredQuestions") {
      //   cpr.deleteQuestion(id, true);
      // } else if (typeName == "myquestions") {
      //   // remove it in shared preferences
      //   await SecureStorageService.removeInMyQuestion(context, id);
      // }
      else {
        await bpr.deleteBasic(typeName, id);
      }

      Navigator.of(context).pop(); // to pop off SMBS in the navigator.
    } on HttpException {
      Navigator.of(context).pop(); // to pop off SMBS in the navigator.
      var errorMessage = i.tr('m27');
      // String e = error.toString();
      // if (e.contains('username already exists')) {
      //   errorMessage = 'Username already exists';
      // }
      // if (e.contains('EMAIL_EXISTS')) {
      //   errorMessage = 'This email address is already in use.';
      // } else if (e.contains('INVALID_EMAIL')) {
      //   errorMessage = 'This is not a valid email address';
      // } else if (e.contains('WEAK_PASSWORD')) {
      //   errorMessage = 'This password is too weak.';
      // } else if (e.contains('EMAIL_NOT_FOUND')) {
      //   errorMessage = 'Could not find a user with that email.';
      // } else if (e.contains('INVALID_PASSWORD')) {
      //   errorMessage = 'Invalid password.';
      // }
      Utils.showErrorDialog(context, errorMessage);
    } catch (error) {
      // print('e: $error');
      Navigator.of(context).pop(); // to pop off SMBS in the navigator.
      var errorMessage = i.tr('m28');
      Utils.showErrorDialog(context, errorMessage);
    }
  }
}
