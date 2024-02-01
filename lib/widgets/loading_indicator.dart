import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:new_ara_app/constants/colors_info.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (Platform.isAndroid == true)
            ? const CircularProgressIndicator(color: ColorsInfo.newara)
            : const CupertinoActivityIndicator(color: ColorsInfo.newara),
      ),
    );
  }
}
