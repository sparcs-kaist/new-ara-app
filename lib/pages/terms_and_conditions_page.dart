import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_ara_app/constants/colors_info.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(
          child: Text(
            "이용약관",
            style: const TextStyle(
              color: ColorsInfo.newara,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leadingWidth: 100,
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Navigator.pop(context),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              SvgPicture.asset(
                'assets/icons/left_chevron.svg',
                colorFilter: const ColorFilter.mode(
                    ColorsInfo.newara, BlendMode.srcATop),
                fit: BoxFit.fill,
                width: 35,
                height: 35,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: CupertinoScrollbar(
          thumbVisibility: true,
          controller: _controller,
          child: SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
