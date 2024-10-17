import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/basics.dart';
import '../providers/core.dart';
import '../providers/i18n.dart';
import '../utils/services/http_exception.dart';
import '../utils/utils.dart';
import '../widgets/recorder_and_player.dart';
import '../widgets/submit_button.dart';
import 'package:path/path.dart' as p;

class NewAnswerScreen extends StatefulWidget {
  // static const routeName = '/newanswer';
  const NewAnswerScreen({
    super.key,
    required this.qID,
    this.args,
  });
  final int qID;
  final Map<String, dynamic>? args;

  @override
  State<NewAnswerScreen> createState() => _NewAnswerScreenState();
}

class _NewAnswerScreenState extends State<NewAnswerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late final i18n i;
  late final Basics bpr;
  late final Core cpr;
  late final String qContent;
  late final int _dialectID;
  late final bool _isTheQuestionRTL;

  // ignore: prefer_final_fields
  Map<String, dynamic> _formData = {
    "id": null,
    "audio": null,
    "question": null
  };

  bool _isInit = true;
  bool _isLoading = false;

  late final Map<String, dynamic>? _editedElement;
  late String title;
  bool _isEdit = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);
      cpr = Provider.of<Core>(context, listen: false);

      if (widget.args != null && widget.args!['answeredQuestionID'] != null) {
        _isEdit = true;

        final answeredQuestion = cpr.findAnsweredQuestionById(widget.qID);
        qContent = answeredQuestion['content'];
        _editedElement = answeredQuestion['answer'];
        _dialectID = answeredQuestion['dialect'];
      } else {
        final theQuestion = cpr.findQuestionById(widget.qID);
        qContent = theQuestion['content'];
        _dialectID = theQuestion['dialect'];
      }
      final Map<String, dynamic> theQuestionDialectData =
          bpr.findBasicById('dialect', _dialectID);
      _isTheQuestionRTL =
          i.getLocaleIsRtl(theQuestionDialectData['language_code']);

      // final qid = ModalRoute.of(context)?.settings.arguments as int?;
      // _isEdit = qid != null;

      if (_isEdit) {
        _formData = {
          "id": _editedElement!['id'],
          "audio": _editedElement['audio'],
          "question": _editedElement['question'],
        };
      } else {
        _formData["question"] = widget.qID.toString();
      }
      title = i.tr(_isEdit ? 'Re-answer' : 'Answer');
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // print('*************** new_answer_screen build ***************');
    return Scaffold(
      appBar: _buildAppBar,
      persistentFooterButtons: [
        if (_formData['audio'] != null && p.isAbsolute(_formData['audio']))
          _buildSubmitButton
      ],
      body: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (ctx, constraints) => SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                .onDrag, // to hide (pop off in the navigator) soft input keyboard with tap on screen
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: _buildFormElements,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column get _buildFormElements {
    return Column(
      children: <Widget>[
        _buildQuestionContent,
        RecorderAndPlayer(
          initialAudioPath: _formData['audio'],
          suggestFleName: '${cpr.userId}-${_formData["question"]}',
          onStopHandler: (String audioPath) =>
              setState(() => _formData['audio'] = audioPath),
          isLoading: _isLoading,
        ),
      ],
    );
  }

  PreferredSize get _buildAppBar {
    return PreferredSize(
      preferredSize: const Size.fromHeight(112), // default appBar height: 56,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13), topRight: Radius.circular(13))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Utils.buildHandle(context),
            _buildTitleAndClose,
            const SizedBox(height: 6),
            const Divider(
              thickness: 1.0,
              height: 0.0,
            ),
          ],
        ),
      ),
    );
  }

  Padding get _buildTitleAndClose {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            // '${widget.title}',
            'ID: ${widget.qID}',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Container get _buildQuestionContent {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.white,
          Color(0xffF3F2F8),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Text(qContent,
          textAlign: _isTheQuestionRTL ? TextAlign.right : TextAlign.left),
    );
  }

  SubmitButton get _buildSubmitButton {
    String text = _isEdit ? 'Edit' : 'Send';
    String disabledText = _isEdit ? 'Editing' : 'Sending';
    return SubmitButton(
        isSubmitButtonDisabled: _isLoading,
        text: text,
        disabledText: disabledText,
        onPressedHandler: _onSubmit);
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      await cpr.newAnswer(_formData);
      Navigator.of(context)
          .pop(); // to pop off in the navigator, AND show "AccountListScreen"
    } on HttpException {
      var errorMessage = _isEdit ? 'Re-answering failed' : 'Answering failed';
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
      // print('Error: $error');
      var errorMessage =
          'Could not ${_isEdit ? 're-answer' : 'answer'} . Please try again later.';
      Utils.showErrorDialog(context, errorMessage);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
