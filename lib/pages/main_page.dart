import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/constants.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: SvgPicture.asset(
          'assets/images/logo.svg',
          fit: BoxFit.cover,
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              color: ColorsInfo.newara,
              width: 20,
              height: 20,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 305,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ColorsInfo.gradBegin, ColorsInfo.gradEnd],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Container(
                  height: 800,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildTextButton(String name, bool isArrow) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 50,
      child: Row(
        children: [
          TextButton(
            onPressed: () {},
            child: Text(isArrow ? ('$name'.tr() + ' >') : ('$name'.tr()),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black,
                )),
          ),
        ],
      ),
    );
  }

  SizedBox _buildSizedBox(double height) {
    return SizedBox(
      height: height,
    );
  }
}
