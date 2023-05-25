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
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class PostWritePage extends StatefulWidget {
  const PostWritePage({Key? key}) : super(key: key);

  @override
  State<PostWritePage> createState() => _PostWritePageState();
}

class _PostWritePageState extends State<PostWritePage> {
  List<bool?> selectedCheckboxes = [true, false, false];
  bool? isChecked = true;
  String? _chosenBoardValue = "학생 단체";
  String? _chosenTopicValue = "학생 단체";
  File? imagePickerFile;
  File? filePickerFile;
  var imagePickerResult;
  FilePickerResult? filePickerResult;

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserProvider>();
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
/*
              Dio dio =Dio();
              dio.options.headers['Cookie']=userProvider.getCookiesToString();
              try {
                var response = await dio.post(
                  '$newAraDefaultUrl/api/articles/',
                  data: {
                    'title': 'post 테스트 03:11',
                    'content':
                    '<p><img src="https://sparcs-newara-dev.s3.amazonaws.com/files/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-05-24_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_6.01.21.png" width="500" data-attachment="170"></p>',
                    'attachments': [170],
                    'parent_topic': '',
                    'is_content_sexual': false,
                    'is_content_social': false,
                    'parent_board': 2,
                  },
                );

                debugPrint('Response data: ${response.data}');
              } catch (e) {
                debugPrint('Error: $e');
              }

*/
              var url = Uri.parse("$newAraDefaultUrl/api/articles/");
              var headers = {
                'Content-Type': 'application/json',
                'Cookie': userProvider.getCookiesToString()
              };

              var requestBody = jsonEncode({
                'title': 'post 테스트 03:16',
                'content':
                    '<p></p>',
                'attachments': [187],
                'parent_topic': '',
                'is_content_sexual': false,
                'is_content_social': false,
                'parent_board': 2,
              });

              var response =
                  await http.post(url, headers: headers, body: requestBody);

              if (response.statusCode == 200) {
                // Request successful
                print('Post request successful');
                print('Response: ${response.body}');
              } else {
                // Request failed
                print(
                    'Post request failed with status code ${response.statusCode}');
                print('Response: ${response.body}');
              }
            },
            child: Text("게시물 등록 테스트"),
          ),
          MaterialButton(
            onPressed: () async {
              if (imagePickerFile != null) {
                var filePath = imagePickerResult.path;
                var filename = filePath.split("/").last;
                var formData = FormData.fromMap({
                  "file":
                      await MultipartFile.fromFile(filePath, filename: filename)
                });
                Dio dio = Dio();
                dio.options.headers['Cookie'] =
                    userProvider.getCookiesToString();
                try {
                  var response = await dio.post(
                      '$newAraDefaultUrl/api/attachments/',
                      data: formData);
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
                dio.options.headers['Cookie'] =
                    userProvider.getCookiesToString();

                // Create FormData
                var formData = FormData.fromMap({
                  "file": await MultipartFile.fromFile(filePickerFile!.path,
                      filename: filePickerFile!.path
                          .split('/')
                          .last), // You may need to replace '/' with '\\' if you're using Windows.
                });

                // Post data with dio
                try {
                  var response = await dio.post(
                      "$newAraDefaultUrl/api/attachments/",
                      data: formData);
                  print(response.data);
                } catch (error) {
                  debugPrint("$error");
                }
              }
            },
            child: Text("파일 테스트"),
          )
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
                          items: <String>['학생 단체', '구인구직', '중고거래', '교내업체피드백']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: value == "말머리 없음"
                                        ? Color(0xFFBBBBBB)
                                        : ColorsInfo.newara,
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
                          items: <String>[
                            '말머리 없음',
                            '학생 단체',
                            '구인구직',
                            '중고거래',
                            '교내업체피드백'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: value == "말머리 없음"
                                        ? Color(0xFFBBBBBB)
                                        : ColorsInfo.newara,
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
                  TextField(
                    minLines: 1,
                    maxLines: 1,
                    style: const TextStyle(
                      height: 1,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      hintText: "제목을 입력하세요",
                      hintStyle: TextStyle(
                          fontSize: 22,
                          color: Color(0xFFBBBBBB),
                          fontWeight: FontWeight.w700),

                      filled: true,
                      fillColor: Colors.white,

                      isDense: true,
                      // contentPadding: const EdgeInsets.fromLTRB(
                      //     10.0, 10.0, 10.0, 10.0), // 모서리를 둥글게 설정
                      enabledBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.transparent, // 테두리 색상 설정
                        ), // 모서리를 둥글게 설정
                      ),
                      focusedBorder: OutlineInputBorder(
                        //  borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
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
            SizedBox(
              height: 40,
              //하단
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          imagePickerResult = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (imagePickerResult != null) {
                            setState(() {
                              imagePickerFile = File(imagePickerResult.path);
                            });
                          }
                        },
                        child: Text("사진 파일 추가"),
                      ),
                      InkWell(
                        onTap: () async {
                          filePickerResult =
                              await FilePicker.platform.pickFiles();
                          setState(() {});
                        },
                        child: Text("첨부 파일 추가"),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
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
                            height: 20.0,
                            width: 20.0,
                            decoration: BoxDecoration(
                              color: selectedCheckboxes[0]!
                                  ? ColorsInfo.newara
                                  : Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(5.0),
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
                            color: selectedCheckboxes[0]!
                                ? ColorsInfo.newara
                                : Color(0xFFF0F0F0),
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
                            height: 20.0,
                            width: 20.0,
                            decoration: BoxDecoration(
                              color: selectedCheckboxes[1]!
                                  ? ColorsInfo.newara
                                  : Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Icon(
                              Icons.check,
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
                            color: selectedCheckboxes[1]!
                                ? ColorsInfo.newara
                                : Color(0xFFF0F0F0),
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
                            height: 20.0,
                            width: 20.0,
                            decoration: BoxDecoration(
                              color: selectedCheckboxes[2]!
                                  ? ColorsInfo.newara
                                  : Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(5.0),
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
                            color: selectedCheckboxes[2]!
                                ? ColorsInfo.newara
                                : Color(0xFFF0F0F0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
