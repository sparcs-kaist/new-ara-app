import 'package:flutter/material.dart';
import 'package:new_ara_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class TextInfo extends StatelessWidget {
  final String infoStr;
  const TextInfo(this.infoStr, {super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      child: Text(
        infoStr,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: themeProvider.isDarkMode? Color.fromRGBO(91, 91, 91, 1) : Color.fromRGBO(191, 191, 191, 1)),
      ),
    );
  }
}