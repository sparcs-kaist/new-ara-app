import 'package:flutter/material.dart';
import 'package:new_ara_app/constants/theme_info.dart';
import 'package:new_ara_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class BorderBoxes extends StatefulWidget {
  final double height;
  final List<Widget> widgetsList;
  const BorderBoxes(this.height, this.widgetsList, {super.key});
  @override
  State<BorderBoxes> createState() => _BorderBoxesState();
}

class _BorderBoxesState extends State<BorderBoxes> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: themeProvider.isDarkMode? NewAraThemes.darkBRLine : NewAraThemes.lightBRLine,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.widgetsList,
      ),
    );
  }
}
