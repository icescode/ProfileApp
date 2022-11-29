import 'package:flutter/material.dart';

class RichTextPage extends StatefulWidget {
  final String url;
  const RichTextPage({super.key, required this.url});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _RichTextPage createState() => _RichTextPage(url);
}

class _RichTextPage extends State<RichTextPage> {
  final String url;
  _RichTextPage(this.url);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column();
  }
}
