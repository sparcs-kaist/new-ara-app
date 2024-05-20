import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_ara_app/translations/locale_keys.g.dart';
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
import 'package:new_ara_app/widgets/snackbar_noti.dart';

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
  String? _changedNick;

  // ignore: unused_field
  String? _retrieveDataError;

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = context.read<UserProvider>();
    context.read<NotificationProvider>().checkIsNotReadExist(userProvider);
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

  /// 수정된 프로필을 반영하기 api 요청을 보내는 함수
  /// API 요청이 성공하면 true를 반환
  /// 실패하면 false를 반환하며 [noticeUserBySnackBar]를 이용해 스낵바 알림을 생성함
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
    Response? response = await userProvider.patchApiRes(
      "user_profiles/${userProfileModel.user}/",
      data: formData,
    );
    if (response == null) {
      // TODO: 닉네임 변경 기한 관련 메시지 출력 기능 추가 (인터넷 에러 처리할 때 완료하기)
      return false;
    }
    // try {
    //   var response = await dio.patch(
    //     "$newAraDefaultUrl/api/user_profiles/${userProfileModel.user}/",
    //     data: formData,
    //   );
    //   if (response.statusCode != 200) return false;
    // } on DioException catch (e) {
    //   debugPrint("updateProfile failed with DioException: $e");
    //   // 서버에서 response를 보냈지만 invalid한 statusCode일 때
    //   String infoText = LocaleKeys.profileEditPage_settingInfoText.tr();
    //   if (e.response != null) {
    //     debugPrint("${e.response!.data['nickname'][0]}");
    //     debugPrint("${e.response!.headers}");
    //     debugPrint("${e.response!.requestOptions}");
    //     // 인터넷 문제가 아닌 경우 닉네임 관련 규정 설명을 추가함.
    //     infoText += ' ${e.response!.data['nickname'][0]}';
    //   }
    //   // request의 setting, sending에서 문제 발생
    //   // requestOption, message를 출력.
    //   else {
    //     debugPrint("${e.requestOptions}");
    //     debugPrint("${e.message}");
    //   }
    //   // 유저에게 스낵바 알림
    //   noticeUserBySnackBar(infoText);
    //   return false;
    // } catch (e) {
    //   debugPrint("updateProfile failed with error: $e");
    //   return false;
    // }
    return true;
  }

  /// infoText 매개변수를 전달받아 스낵바 메시지를 띄워주는 함수
  /// 프로필 설정 변경 시에 문제가 생겼을 때 알려주는 용도로 사용.
  void noticeUserBySnackBar(String infoText) {
    SnackBar araSnackBar = buildAraSnackBar(
      context,
      content: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/information.svg',
            colorFilter:
                const ColorFilter.mode(ColorsInfo.newara, BlendMode.srcIn),
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 8),
          Flexible(
              child: Text(
            infoText,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          )),
        ],
      ),
    );
    hideOldsAndShowAraSnackBar(context, araSnackBar);
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
              title: Text(
                LocaleKeys.profileEditPage_editProfile.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: ColorsInfo.newara,
                ),
              ),
              actions: [
                InkWell(
                  onTap: () async {
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        LocaleKeys.profileEditPage_complete.tr(),
                        style: const TextStyle(
                          color: ColorsInfo.newara,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
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
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
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
                              Text(
                                LocaleKeys.profileEditPage_nickname.tr(),
                                style: const TextStyle(
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
                        // 닉네임 정책 안내 문구
                        SizedBox(
                          width: mediaQueryData.size.width - 60,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: context.locale == const Locale('ko')
                                    ? 80
                                    : 110),
                            child: Text(
                              LocaleKeys.profileEditPage_nicknameInfo.tr(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(191, 191, 191, 1),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: mediaQueryData.size.width - 60,
                          child: Row(
                            children: [
                              Text(
                                LocaleKeys.profileEditPage_email.tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: Color.fromRGBO(99, 99, 99, 1),
                                ),
                              ),
                              SizedBox(
                                  width: context.locale == const Locale('ko')
                                      ? 45
                                      : 80),
                              Expanded(
                                child: Text(
                                  userProviderData.naUser!.email ??
                                      LocaleKeys.profileEditPage_noEmail.tr(),
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
            // 이미지 링크를 확인한 후 null인 이미지는 warning.svg를 빌드
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
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: LocaleKeys.profileEditPage_nicknameHintText.tr(),
            ),
            validator: (value) {
              // (2023.08.19) 나중에 글자 수 확인도 추가해야 함
              if (value == null || value.isEmpty) {
                return LocaleKeys.profileEditPage_nicknameEmptyInfo.tr();
              }
              return null;
            },
            onChanged: (value) => _changedNick = value,
            onSaved: (value) => _changedNick = value ?? '',
          )),
    );
  }
}
