import 'package:flutter/material.dart';

class BorderBoxes extends StatefulWidget {
  final double height;
  final List<Widget> widgetsList;
  const BorderBoxes(this.height, this.widgetsList);
  @override
  State<BorderBoxes> createState() => _BorderBoxesState();
}

class _BorderBoxesState extends State<BorderBoxes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: const Color.fromRGBO(240, 240, 240, 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.widgetsList,
      ),
    );
  }
}
