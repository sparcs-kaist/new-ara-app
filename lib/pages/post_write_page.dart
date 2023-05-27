import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class PostWritePage extends StatefulWidget {
  const PostWritePage({Key? key}) : super(key: key);

  @override
  State<PostWritePage> createState() => _PostWritePageState();
}

enum FileType {
  Image,
  Other,
}

class AttachmentsFormat {
  FileType fileType;
  bool isNewFile;
  String? filePath;
  Map<String, dynamic>? json;
  AttachmentsFormat({
    required this.fileType,
    required this.isNewFile,
    this.filePath,
    this.json,
  });
}

class _PostWritePageState extends State<PostWritePage> {
  List<bool?> selectedCheckboxes = [true, false, false];
  bool isFileMenuBarSelected = false;
  String? _chosenBoardValue = "학생 단체";
  String? _chosenTopicValue = "학생 단체";
  File? imagePickerFile;
  File? filePickerFile;
  var imagePickerResult;
  FilePickerResult? filePickerResult;
  
  List<AttachmentsFormat> attachmentsList = [];

  late String _localPath;
  late bool _permissionReady;
  late TargetPlatform? platform;  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }
  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      debugPrint("Android");
      if (status != PermissionStatus.granted) {
        debugPrint("not granted");
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
        debugPrint("not granted again");
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
   Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
  }
  
  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserProvider>();

    Future<void> _filePick() async {
      filePickerResult = await FilePicker.platform.pickFiles();
      if (filePickerResult != null) {
        debugPrint(filePickerResult!.files.single.path!);
        setState(() {
          isFileMenuBarSelected = true;
          attachmentsList.add(AttachmentsFormat(fileType: FileType.Other, isNewFile: true, filePath: filePickerResult!.files.single.path!));
        });
      }
    }
    Future<void> _imagePick()async{
      imagePickerResult = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagePickerResult != null) {
        debugPrint(imagePickerResult.path);
        setState(() {
          imagePickerFile =File(imagePickerResult.path);
        });
      }
    }

    String formatBytes(int bytes) {
      if (bytes < 1024) {
        return '$bytes B'; // 바이트 단위로 표시
      } else if (bytes < 1024 * 1024) {
        double kb = bytes / 1024;
        return '${kb.toStringAsFixed(2)} KB'; // 킬로바이트(KB) 단위로 표시
      } else if (bytes < 1024 * 1024 * 1024) {
        double mb = bytes / (1024 * 1024);
        return '${mb.toStringAsFixed(2)} MB'; // 메가바이트(MB) 단위로 표시
      } else {
        double gb = bytes / (1024 * 1024 * 1024);
        return '${gb.toStringAsFixed(2)} GB'; // 기가바이트(GB) 단위로 표시
      }
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 100,
        leading: Row(
          children: [
            SizedBox(
              width: 35,
              child: IconButton(
                color: ColorsInfo.newara,
                icon: SizedBox(
                  width: 11.58,
                  height: 21.87,
                  child: SvgPicture.asset(
                    'assets/icons/left_chevron.svg',
                    color: ColorsInfo.newara,
                    fit: BoxFit.fill,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        title: SizedBox(
          child: Text(
            "글 쓰기",
            style: const TextStyle(
              color: ColorsInfo.newara,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Dio dio = Dio();
              dio.options.headers['Cookie'] = userProvider.getCookiesToString();
              try {
                var response = await dio.post(
                  '$newAraDefaultUrl/api/articles/',
                  data: {
                    'title': 'post 테스트 03:11',
                    'content': '<p><img src="https://sparcs-newara-dev.s3.amazonaws.com/files/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-05-24_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_6.01.21.png" width="500" data-attachment="170"></p>',
                    'attachments': [170],
                    'parent_topic': '',
                    'is_content_sexual': false,
                    'is_content_social': false,
                    'parent_board': 2,
                    'name_type': 'REGULAR'
                  },
                );
                debugPrint('Response data: ${response.data}');
              } catch (e) {
                debugPrint('Error: $e');
              }
            },
            child: Text("게시물 내용"),
          ),
          MaterialButton(
            onPressed: () async {
              if (imagePickerFile != null) {
                var filePath = imagePickerResult.path;
                var filename = filePath.split("/").last;
                var formData = FormData.fromMap({"file": await MultipartFile.fromFile(filePath, filename: filename)});
                Dio dio = Dio();
                dio.options.headers['Cookie'] = userProvider.getCookiesToString();
                try {
                  var response = await dio.post('$newAraDefaultUrl/api/attachments/', data: formData);
                  print('Post request successful');
                  print('Response: $response.data');
                } catch (error) {
                  // Request failed
                  print('Post request failed with status code $error');
                  //  print('Response: $responseData');
                }
              }
            },
            // 버튼이 클릭되었을 때 수행할 동작
            padding: EdgeInsets.zero, // 패딩 제거
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: ColorsInfo.newara,
              ),
              child: Container(
                constraints: BoxConstraints(maxWidth: 65.0, maxHeight: 35.0),
                alignment: Alignment.center,
                child: Text(
                  '올리기',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (filePickerResult != null) {
                filePickerFile = File(filePickerResult!.files.single.path!);
                debugPrint("!null");
                // Create dio
                var dio = Dio();
                dio.options.headers['Cookie'] = userProvider.getCookiesToString();

                // Create FormData
                var formData = FormData.fromMap({
                  "file": await MultipartFile.fromFile(filePickerFile!.path, filename: filePickerFile!.path.split('/').last), // You may need to replace '/' with '\\' if you're using Windows.
                });

                // Post data with dio
                try {
                  var response = await dio.post("$newAraDefaultUrl/api/attachments/", data: formData);
                  print(response.data);
                } catch (error) {
                  debugPrint("$error");
                }
              }
            },
            child: Text("파일"),
          ),
          ElevatedButton(
            onPressed: () async {
                  final String fileUrl = "https://sparcs-newara-dev.s3.amazonaws.com/files/lizard-7938887_1280_eAHShfM.webp";

                
                  _permissionReady = await _checkPermission();
                  debugPrint("Click");
          if (_permissionReady) {
            await _prepareSaveDir();
            debugPrint("Downloading");
            try {
              await Dio().download(fileUrl,
                  _localPath + "/" + "filename.jpg");
              debugPrint("Download Completed.");
            } catch (e) {
              debugPrint("Download Failed.\n\n" + e.toString());
            }
          }
            },
            child: Text("파일 다운"),
          ),
          
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 34,
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          //  isDense: true,
                          //isExpanded: true,

                          onTap: () {
                            debugPrint("d");
                          },
                          //isExpanded: true,
                          value: _chosenBoardValue,
                          style: TextStyle(color: Colors.red),
                          items: <String>['학생 단체', '구인구직', '중고거래', '교내업체피드백'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: value == "말머리 없음" ? Color(0xFFBBBBBB) : ColorsInfo.newara,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _chosenBoardValue = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          //  isDense: true,
                          //isExpanded: true,

                          onTap: () {
                            debugPrint("d");
                          },
                          //isExpanded: true,
                          value: _chosenTopicValue,
                          style: TextStyle(color: Colors.red),
                          items: <String>['말머리 없음', '학생 단체', '구인구직', '중고거래', '교내업체피드백'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: value == "말머리 없음" ? Color(0xFFBBBBBB) : ColorsInfo.newara,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _chosenTopicValue = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Expanded(
                  //   child: Placeholder(),
                  // )
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextField(
                    minLines: 1,
                    maxLines: 1,
                    style: TextStyle(
                      height: 1,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      hintText: "제목을 입력하세요",
                      hintStyle: TextStyle(fontSize: 22, color: Color(0xFFBBBBBB), fontWeight: FontWeight.w700),

                      filled: true,
                      fillColor: Colors.white,

                      isDense: true,
                      // contentPadding: const EdgeInsets.fromLTRB(
                      //     10.0, 10.0, 10.0, 10.0), // 모서리를 둥글게 설정
                      enabledBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.transparent, // 테두리 색상 설정
                        ), // 모서리를 둥글게 설정
                      ),
                      focusedBorder: OutlineInputBorder(
                        //  borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.transparent, // 테두리 색상 설정
                        ), // 모서리를 둥글게 설정
                      ),
                    ),
                    cursorColor: Colors.transparent,
                  ),
                  Container(
                    height: 1,
                    color: Color(0xFFF0F0F0),
                  ),
                  Text(
                    "내용도 입력해봐=ㅆ어ㅛ내용도 입력해봐=ㅆ어ㅛ내용도 입력해봐=ㅆ어ㅛ내용도 입력해봐=ㅆ어ㅛ내용도 입력해봐=ㅆ어ㅛ내용도 입력해봐=ㅆ어ㅛ내용도 입력해봐=ㅆ어ㅛ내용도 입력해봐=ㅆ어ㅛ내용도 입력해봐=ㅆ어ㅛ내용도 입력해봐=ㅆ어ㅛ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (imagePickerFile != null) Image.file(imagePickerFile!),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  if (attachmentsList.length == 0)
                    Row(
                      children: [
                        // InkWell(
                        //   onTap: () async {
                        //     imagePickerResult = await ImagePicker()
                        //         .pickImage(source: ImageSource.gallery);
                        //     if (imagePickerResult != null) {
                        //       setState(() {
                        //         imagePickerFile =
                        //             File(imagePickerResult.path);
                        //       });
                        //     }
                        //   },
                        //   child: Text("첨부파일 추가"),
                        // ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: _filePick,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/clip.svg',
                                    color: Color(0xFF636363),
                                    width: 34,
                                    height: 34,
                                  ),
                                  Text(
                                    "첨부파일 추가",
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xFF636363)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    AnimatedSize(
                      duration: Duration(milliseconds: 100),
                      alignment: AlignmentDirectional.topCenter,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "첨부파일",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                attachmentsList.length.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsInfo.newara,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isFileMenuBarSelected = !isFileMenuBarSelected;
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/chevron_down.svg',
                                  width: 20,
                                  height: 20,
                                  color: Colors.red,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () => _filePick(),
                                child: SvgPicture.asset(
                                  'assets/icons/add.svg',
                                  width: 34,
                                  height: 34,
                                  color: Color(0xFFED3A3A),
                                ),
                              ),
                              SizedBox(
                                width: 14,
                              ),
                            ],
                          ),
                          if (isFileMenuBarSelected) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: attachmentsList.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          if (index != 0)
                                            SizedBox(
                                              height: 5,
                                            ),
                                          Container(
                                            height: 44,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color(0xFFF0F0F0), // #F0F0F0 색상
                                                width: 1, // 테두리 두께 1픽셀
                                              ),
                                              borderRadius: BorderRadius.circular(15), // 반지름 15
                                            ),
                                            child: Row(
                                              children: [
                                                // SvgPicture.asset(
                                                //   'assets/icons/pdf.svg',
                                                //   width: 16,
                                                //   height: 16,
                                                //   color: Colors.black,
                                                // ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                SvgPicture.asset(
                                                  'assets/icons/pdf.svg',
                                                  width: 30,
                                                  height: 30,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    path.basename(attachmentsList[index].filePath!),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  formatBytes(File(attachmentsList[index].filePath!).lengthSync()),
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFBBBBBB)),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    setState((){
                                                      attachmentsList.removeAt(index);
                                                    });
                                                  },
                                                  child: SvgPicture.asset(
                                                    'assets/icons/close.svg',
                                                    width: 30,
                                                    height: 30,
                                                    color: Color(0xFFBBBBBB),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8.52,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCheckboxes[0] = !selectedCheckboxes[0]!;
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: selectedCheckboxes[0]! ? ColorsInfo.newara : Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/icons/check.svg',
                            width: 16,
                            height: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "익명",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: selectedCheckboxes[0]! ? ColorsInfo.newara : Color(0xFFBBBBBB),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCheckboxes[1] = !selectedCheckboxes[1]!;
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: selectedCheckboxes[1]! ? ColorsInfo.newara : Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/icons/check.svg',
                            width: 16,
                            height: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "성인",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: selectedCheckboxes[1]! ? ColorsInfo.newara : Color(0xFFBBBBBB),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCheckboxes[2] = !selectedCheckboxes[2]!;
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: selectedCheckboxes[2]! ? ColorsInfo.newara : Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/icons/check.svg',
                            width: 16,
                            height: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "정치",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: selectedCheckboxes[2]! ? ColorsInfo.newara : Color(0xFFBBBBBB),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: _imagePick,
                        child: Text(
                          "이용약관",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFBBBBBB),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}