import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';

import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/user_profile_model.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:new_ara_app/providers/notification_provider.dart';
import 'package:new_ara_app/utils/profile_image.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false, _isCamClicked = false;
  XFile? _selectedImage;
  String? _changedNick, _retrieveDataError;

  @override
  void initState() {
    super.initState();
    context.read<NotificationProvider>().checkIsNotReadExist();
  }

  void setIsCamClicked(bool tf) {
    if (mounted) setState(() => _isCamClicked = tf);
  }

  void _setIsLoading(bool tf) {
    if (mounted) setState(() => _isLoading = tf);
  }

  Future<void> _retrieveLostData() async {
    final LostDataResponse response = await _imagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _selectedImage = response.file;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    if (!(context.mounted)) return;
    double diameter = MediaQuery.of(context).size.width - 70;
    final XFile? tmpImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: diameter,
      maxHeight: diameter,
      imageQuality: 100, // (2023.08.21) default 값으로 설정함. 추후 논의 필요
    );
    if (tmpImage != null) {
      setState(() => _selectedImage = tmpImage);
    }
  }

  Future<bool> _updateProfile(UserProvider userProvider) async {
    UserProfileModel userProfileModel = userProvider.naUser!;
    FormState? formState = _formKey.currentState;

    if (formState == null || !(formState.validate())) return false;

    debugPrint("_changedNick: $_changedNick");
    // (2023.08.20) 기준 payload. 바뀔 수 있으니 이상하면 브라우저 network에서 직접 보기.
    // swagger, redoc 정보와 다름.
    Map<String, dynamic> payload = {
      "nickname": _changedNick ?? userProfileModel.nickname,
      "see_sexual": userProfileModel.see_sexual,
      "see_social": userProfileModel.see_social,
    };
    if (_selectedImage != null) {
      final String imagePath = _selectedImage!.path;
      final String? mime = lookupMimeType(imagePath);
      debugPrint("mime: $mime");
      payload["picture"] = await MultipartFile.fromFile(
        imagePath,
        contentType: MediaType("image", mime!.split('/')[1]),
      );
    }
    var formData = FormData.fromMap(payload);
    var dio = Dio();
    dio.options.headers['Cookie'] = userProvider.getCookiesToString();
    try {
      var response = await dio.patch(
        "$newAraDefaultUrl/api/user_profiles/${userProfileModel.user}/",
        data: formData,
      );
      if (response.statusCode != 200) return false;
    } catch (error) {
      debugPrint("Error: $error");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    UserProvider userProviderData = context.watch<UserProvider>();

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double profileDiameter = mediaQueryData.size.width - 70;

    return _isLoading
        ? const LoadingIndicator()
        : Scaffold(
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
                  onPressed: () async {
                    _setIsLoading(true);
                    bool updateRes = await _updateProfile(userProvider);
                    debugPrint("updateRes: $updateRes");
                    _changedNick = null;
                    _selectedImage = null;
                    if (updateRes) {
                      await userProvider.apiMeUserInfo().then((getRes) {
                        if (getRes) Navigator.pop(context);
                      });
                    } else {
                      _setIsLoading(false);
                    }
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
                              child: !(Platform.isAndroid)
                                  ? _buildClippedImage(
                                      userProviderData, profileDiameter)
                                  : FutureBuilder<void>(
                                      future: _retrieveLostData(),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                          case ConnectionState.active:
                                          case ConnectionState.done:
                                            return _buildClippedImage(
                                                userProviderData,
                                                profileDiameter);
                                        }
                                      }),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 50,
                              child: AbsorbPointer(
                                absorbing: _isCamClicked,
                                child: InkWell(
                                  onTap: () async {
                                    if (_isCamClicked) return;
                                    setIsCamClicked(true);
                                    await _pickImage(context);
                                    setIsCamClicked(false);
                                  }, // (2023.08.19)프로필 사진 수정 기능 추후 구현 예정
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
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: mediaQueryData.size.width - 60,
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
                                  child: _buildForm(
                                      userProviderData.naUser!.nickname),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: mediaQueryData.size.width - 60,
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
                                  userProviderData.naUser!.email,
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

  /// 선택된 이미지 또는 기존의 프로필 이미지 위젯을 빌드하는 함수
  ClipOval _buildClippedImage(
      UserProvider userProviderData, double profileDiameter) {
    return ClipOval(
        child: _selectedImage != null
            ? Image.file(
                fit: BoxFit.cover,
                File(_selectedImage!.path),
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return const Center(
                      child: Text('This image type is not supported'));
                },
              )
            : buildProfileImage(userProviderData.naUser!.picture,
                profileDiameter - 5, profileDiameter - 5));
  }

  /// 닉네임 변경 필드를 빌드하는 함수
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
              // (2023.08.19) 나중에 글자 수 확인도 추가해야 함
              if (value == null || value.isEmpty) {
                return '닉네임이 작성되지 않았습니다!';
              }
              return null;
            },
            onChanged: (value) => _changedNick = value,
            onSaved: (value) => _changedNick = value ?? '',
          )),
    );
  }
}
