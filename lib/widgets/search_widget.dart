import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final String searchWord;
  final ValueChanged<String> onChangedSearchTextHandler;
  final String hintText;
  final bool autofocus;

  const SearchWidget({
    required this.searchWord,
    required this.onChangedSearchTextHandler,
    required this.hintText,
    this.autofocus = false,
    super.key,
  });

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.text = widget.searchWord;
  }

  @override
  Widget build(BuildContext context) {
    // print('*************** search_widget build ***************');
    const styleActive = TextStyle(color: Colors.black);
    const styleHint = TextStyle(color: Colors.black54);
    final style = widget.searchWord.isEmpty ? styleHint : styleActive;

    return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: style.color),
          suffixIcon: widget.searchWord.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, color: style.color),
                  onTap: () {
                    _controller.clear();
                    widget.onChangedSearchTextHandler('');
                    FocusScope.of(context).unfocus(); // hide keyboard
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: style,
        autofocus: widget.autofocus,
        onChanged: widget.onChangedSearchTextHandler,
      ),
    );
  }
}
