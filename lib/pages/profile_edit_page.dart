import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/user_profile_model.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final GlobalKey _formKey = GlobalKey();
  String _changedNick = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    UserProfileModel userProfileModel = userProvider.naUser!;

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double profileDiameter = mediaQueryData.size.width - 70;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/icons/close-2.svg",
            color: ColorsInfo.newara,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "프로필 수정",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: ColorsInfo.newara,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // 추후 구현 예정
            },
            icon: const Text(
              '완료',
              style: TextStyle(
                color: ColorsInfo.newara,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: SizedBox(
              width: mediaQueryData.size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        width: profileDiameter,
                        height: profileDiameter,
                        child: ClipOval(
                          child: userProvider.naUser?.picture == null
                              ? Container()
                              : Image.network(
                              fit: BoxFit.cover,
                              userProvider.naUser!.picture.toString()),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 50,
                        child: InkWell(
                          onTap: () {},  // (2023.08.19)프로필 사진 수정 기능 추후 구현 예정
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(51, 51, 51, 1),
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/camera.svg",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: mediaQueryData.size.width - 80,
                    child: Row(
                      children: [
                        const Text(
                          '닉네임',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: Color.fromRGBO(99, 99, 99, 1),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(235, 235, 235, 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                            child: _buildForm(userProfileModel.nickname),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: mediaQueryData.size.width - 80,
                    child: Row(
                      children: [
                        const Text(
                          '이메일',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: Color.fromRGBO(99, 99, 99, 1),
                          ),
                        ),
                        const SizedBox(width: 45),
                        Expanded(
                          child: Text(
                            userProfileModel.email,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color.fromRGBO(177, 177, 177, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Form _buildForm(String initialNick) {
    return Form(
      key: _formKey,
      child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: TextFormField(
            cursorColor: ColorsInfo.newara,
            initialValue: initialNick,
            maxLines: 1,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '변경하실 닉네임을 입력해주세요.',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '댓글이 작성되지 않았습니다!';
              } else if (value == initialNick) {
                return '닉네임이 변경되지 않았습니다!';
              }
              return null;
            },
            onChanged: (value) => _changedNick = value,
            onSaved: (value) =>  _changedNick = value ?? '',
          )),
    );
  }
}
