import 'package:flutter/material.dart';

import 'package:new_ara_app/constants/constants.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: ColorsInfo.newara),
    );
  }
}
