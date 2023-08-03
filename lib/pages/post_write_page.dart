import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/attachment_model.dart';
import 'package:new_ara_app/models/board_detail_action_model.dart';
import 'package:new_ara_app/models/board_group_model.dart';
import 'package:new_ara_app/models/board_model.dart';
import 'package:new_ara_app/models/simple_board_model.dart';
import 'package:new_ara_app/models/topic_model.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/user_provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as html;

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
  bool isNewFile; // 수정 시에 추가한 파일인가?
  String? filePath;
  Map<String, dynamic>? json;
  String? uuid;
  AttachmentsFormat({
    required this.fileType,
    required this.isNewFile,
    this.filePath,
    this.json,
    this.uuid,
  });
}

class _PostWritePageState extends State<PostWritePage> {
  final MALNO = TopicModel(
    id: -1,
    slug: "",
    ko_name: "말머리 없음",
    en_name: "No Topic",
  );
  final SELECTBOARD = BoardDetailActionModel(
    id: -1,
    topics: [],
    user_readable: true,
    user_writable: true,
    slug: '',
    ko_name: '게시판을 선택하세요',
    en_name: 'No Board',
    group: SimpleBoardModel(id: -1, slug: '', ko_name: '', en_name: ''),
  );

  List<bool?> _selectedCheckboxes = [true, false, false];
  bool _isFileMenuBarSelected = false; // 첨부파일 메뉴바가 선택되었는가?

  BoardDetailActionModel? _chosenBoardValue;
  TopicModel? _chosenTopicValue;

  List<BoardDetailActionModel> _boardList = [];
  List<TopicModel> _specTopicList = [];

  File? imagePickerFile;
  File? filePickerFile;
  bool _isLoading = true;
  var imagePickerResult;
  FilePickerResult? filePickerResult;

  List<AttachmentsFormat> attachmentList = [];

  late String _localPath;

  late bool _permissionReady;
  late TargetPlatform? platform;

  var _titleController = TextEditingController();
  final HtmlEditorController _htmlController = HtmlEditorController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    _getBoardList();
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

  Future<void> _getBoardList() async {
    var userProvider = context.read<UserProvider>();
    try {
      Dio dio = Dio();
      dio.options.headers['Cookie'] = userProvider.getCookiesToString();
      var response = await dio.get('$newAraDefaultUrl/api/boards/');
      debugPrint(response.data.toString());

      _boardList = [SELECTBOARD];
      for (Map<String, dynamic> json in response.data) {
        try {
          BoardDetailActionModel boardDetail =
              BoardDetailActionModel.fromJson(json);

          if (boardDetail.user_writable == true) {
            _boardList.add(boardDetail);
          } else {
            // Optionally, you can do something with entries where user_writable is false
            // For example, you can skip them or perform any other action
          }
        } catch (error) {
          debugPrint(
              "refreshBoardList BoardDetailActionModel.fromJson failed: $error");
          return;
        }
      }
    } catch (error) {
      return;
    }
    setState(() {
      _specTopicList.add(MALNO);

      _chosenTopicValue = _specTopicList[0];
      _chosenBoardValue = _boardList[0];
      _isLoading = false;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return LoadingIndicator();
    var userProvider = context.watch<UserProvider>();

    String updateImgSrc(htmlString, uuid, fileUrl) {
      
      var document = parse(htmlString);
      debugPrint(document.body?.innerHtml ?? '');
      List<html.Element> imgTags = document.getElementsByTagName('img');

      for (var imgTag in imgTags) {
        if (imgTag.attributes['data-uuid'] == uuid) {
          if (fileUrl != null) {
            imgTag.attributes['src'] = fileUrl;
          } else {
            // fileUrl이 null인 경우 이미지 태그를 삭제
            imgTag.remove();
          }
        }
      }
      debugPrint(document.body?.innerHtml ?? '');
      return document.body?.innerHtml ?? '';
    }

    Future<void> _filePick() async {
      filePickerResult = await FilePicker.platform.pickFiles();
      if (filePickerResult != null) {
        debugPrint(filePickerResult!.files.single.path!);
        File file = File(filePickerResult!.files.single.path!);
        if (Platform.isIOS) {
          // iOS에서는 파일을 복사해서 사용해야 함. 캐쉬로 날라가는 문제 발생.
          final documentPath = (await getApplicationDocumentsDirectory()).path;
          file = await file.copy('$documentPath/${path.basename(file.path)}');
          debugPrint("IOS run");
          debugPrint(file.path);
          debugPrint(filePickerResult!.files.single.path);
        }

        setState(() {
          _isFileMenuBarSelected = true;
          attachmentList.add(AttachmentsFormat(
            fileType: FileType.Other,
            isNewFile: true,
            filePath: file.path,
          ));
        });
      }
    }

    Future<void> _imagePick() async {
      imagePickerResult =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagePickerResult != null) {
        debugPrint(imagePickerResult.path);
        setState(() {
          imagePickerFile = File(imagePickerResult.path);
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
          // ElevatedButton(
          //   onPressed: () async {
          //     Dio dio = Dio();
          //     dio.options.headers['Cookie'] = userProvider.getCookiesToString();
          //     try {
          //       var response = await dio.post(
          //         '$newAraDefaultUrl/api/articles/',
          //         data: {
          //           'title': 'post 테스트 03:11',
          //           'content':
          //               '<p><img src="https://sparcs-newara-dev.s3.amazonaws.com/files/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-05-24_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_6.01.21.png" width="500" data-attachment="210"></p>',
          //           'attachments': [210],
          //           'parent_topic': '',
          //           'is_content_sexual': false,
          //           'is_content_social': false,
          //           'parent_board': 2,
          //           'name_type': 'REGULAR'
          //         },
          //       );
          //       debugPrint('Response data: ${response.data}');
          //     } catch (e) {
          //       debugPrint('Error: $e');
          //     }
          //   },
          //   child: Text("게시물 내용"),
          // ),
          MaterialButton(
            onPressed: () async {
              String titleValue;
              String contentValue;
              List<int> attachmentIds = [];
              try {
                titleValue = _titleController.text;
                contentValue = await _htmlController.getText();
                debugPrint("title: $titleValue");
                debugPrint("content: $contentValue");
              } catch (error) {
                debugPrint(error.toString());
                return;
              }

              try {
                Dio dio = Dio();
                dio.options.headers['Cookie'] =
                    userProvider.getCookiesToString();
                for (int i = 0; i < attachmentList.length; i++) {
                  var attachFile = File(attachmentList[i].filePath!);
                  //이 파일 uuid 에 해당하는 img 태그가 html 안에 있다면 변경해야한다.

                  // 파일이 존재하는지 확인
                  if (attachFile.existsSync()) {
                    var dio = Dio();
                    dio.options.headers['Cookie'] =
                        userProvider.getCookiesToString();
                    var formData = FormData.fromMap({
                      "file": await MultipartFile.fromFile(attachFile.path,
                          filename: attachFile.path
                              .split('/')
                              .last), // You may need to replace '/' with '\\' if you're using Windows.
                    });
                    try {
                      var response = await dio.post(
                          "$newAraDefaultUrl/api/attachments/",
                          data: formData);
                      debugPrint("Response: ${response.data}");
                      final attachmentModel =
                          AttachmentModel.fromJson(response.data);
                      attachmentIds.add(attachmentModel.id);
                      contentValue = updateImgSrc(contentValue,
                          attachmentList[i].uuid, attachmentModel.file);
                    } catch (error) {
                      debugPrint("$error");
                    }
                  } else {
                    debugPrint("File does not exist: ${attachFile.path}");
                  }
                }

                var response = await dio.post(
                  '$newAraDefaultUrl/api/articles/',
                  data: {
                    'title': titleValue,
                    'content': contentValue,
                    'attachments': attachmentIds,
                    'parent_topic': _chosenTopicValue!.id == -1
                        ? ''
                        : _chosenTopicValue!.id,
                    'is_content_sexual': false,
                    'is_content_social': false,
                    'parent_board': _chosenBoardValue!.id,
                    'name_type': 'REGULAR'
                  },
                );
                debugPrint('Response data: ${response.data}');
              } on DioException catch (error) {
                debugPrint('post Error: ${error.response!.data}');
                return;
              }
              // htmlController.getText().then((value) {
              //   debugPrint(value);S
              // });
              // if (imagePickerFile != null) {S
              //   var filePath = imagePickerResult.path;
              //   var filename = filePath.split("/").last;
              //   var formData = FormData.fromMap({
              //     "file":
              //         await MultipartFile.fromFile(filePath, filename: filename)
              //   });
              //   Dio dio = Dio();
              //   dio.options.headers['Cookie'] =
              //       userProvider.getCookiesToString();
              //   try {
              //     var response = await dio.post(
              //         '$newAraDefaultUrl/api/attachments/',
              //         data: formData);
              //     print('Post request successful');
              //     print('Response: $response.data');
              //   } catch (error) {
              //     // Request failed
              //     print('Post request failed with status code $error');
              //     //  print('Response: $responseData');
              //   }
              // }
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
          // ElevatedButton(
          //   onPressed: () async {
          //     for (int i = 0; i < attachmentsList.length; i++) {
          //       var attachFile = File(attachmentsList[i].filePath!);

          //       // 파일이 존재하는지 확인
          //       if (attachFile.existsSync()) {
          //         var dio = Dio();
          //         dio.options.headers['Cookie'] =
          //             userProvider.getCookiesToString();
          //         var formData = FormData.fromMap({
          //           "file": await MultipartFile.fromFile(attachFile.path,
          //               filename: attachFile.path
          //                   .split('/')
          //                   .last), // You may need to replace '/' with '\\' if you're using Windows.
          //         });
          //         try {
          //           var response = await dio.post(
          //               "$newAraDefaultUrl/api/attachments/",
          //               data: formData);
          //           print(response.data);
          //         } catch (error) {
          //           debugPrint("$error");
          //         }
          //       } else {
          //         debugPrint("File does not exist: ${attachFile.path}");
          //       }
          //     }
          //   },
          //   child: Text("파일 올리기 테스트"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     final String fileUrl =
          //         "https://sparcs-newara-dev.s3.amazonaws.com/files/lizard-7938887_1280_eAHShfM.webp";

          //     _permissionReady = await _checkPermission();
          //     debugPrint("Click");
          //     if (_permissionReady) {
          //       await _prepareSaveDir();
          //       debugPrint("Downloading");
          //       try {
          //         await Dio()
          //             .download(fileUrl, _localPath + "/" + "filename.jpg");
          //         debugPrint("Download Completed.");
          //       } catch (e) {
          //         debugPrint("Download Failed.\n\n" + e.toString());
          //       }
          //     }
          //   },
          //   child: Text("파일 다운"),
          // ),
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
                        child: DropdownButton<BoardDetailActionModel>(
                          //  isDense: true,
                          //isExpanded: true,

                          onTap: () {
                            debugPrint("d");
                          },
                          //isExpanded: true,
                          value: _chosenBoardValue,
                          style: TextStyle(color: Colors.red),
                          items: _boardList
                              .map<DropdownMenuItem<BoardDetailActionModel>>(
                                  (BoardDetailActionModel value) {
                            return DropdownMenuItem<BoardDetailActionModel>(
                              enabled: value.id != -1,
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  value.ko_name,
                                  style: TextStyle(
                                    color: value.id == -1
                                        ? Color(0xFFBBBBBB)
                                        : ColorsInfo.newara,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (BoardDetailActionModel? value) {
                            setState(() {
                              _specTopicList = [];
                              _specTopicList.add(MALNO);
                              for (TopicModel topic in value!.topics) {
                                _specTopicList.add(topic);
                              }
                              _chosenTopicValue = _specTopicList[0];
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
                        child: DropdownButton<TopicModel>(
                          //  isDense: true,
                          //isExpanded: true,

                          onTap: () {
                            debugPrint("d");
                          },
                          //isExpanded: true,
                          value: _chosenTopicValue,
                          style: TextStyle(color: Colors.red),
                          items: _specTopicList
                              .map<DropdownMenuItem<TopicModel>>(
                                  (TopicModel value) {
                            return DropdownMenuItem<TopicModel>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  value.ko_name,
                                  style: TextStyle(
                                    color: value.id == -1
                                        ? Color(0xFFBBBBBB)
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (TopicModel? value) {
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
                    controller: _titleController,
                    minLines: 1,
                    maxLines: 1,
                    style: TextStyle(
                      height: 1,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      hintText: "제목을 입력해주세요.",
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
                  Expanded(
                    child: HtmlEditor(
                      controller: _htmlController, //required
                      htmlEditorOptions: HtmlEditorOptions(
                        hint: "내용을 입력해주세요.",

                        //initalText: "text content initial, if any",
                      ),
                      htmlToolbarOptions: HtmlToolbarOptions(
                          toolbarType: ToolbarType.nativeGrid,
                          mediaUploadInterceptor:
                              (PlatformFile file, InsertFileType type) async {
                            if (type == InsertFileType.image) {
                              // var uuid = Uuid();
                              String uuid = const Uuid().v4();
                              setState(() {
                                _isFileMenuBarSelected = true;
                                attachmentList.add(AttachmentsFormat(
                                  fileType: FileType.Other,
                                  isNewFile: true,
                                  filePath: file.path,
                                  uuid: uuid,
                                ));
                              });

                              ///src랑 file.path랑 연결해줘야함.
                              String base64Data = base64.encode(file.bytes!);
                              String base64Image =
                                  """<img data-uuid=$uuid  src="data:image/${file.extension};base64,$base64Data" data-filename="${file.name}" width=100% />""";
                              // String base64Image =
                              //     """<img src="https://sparcs-newara-dev.s3.amazonaws.com/files/IMG_0003_8FJEMU6.jpeg" data-filename="${file.name}" width=100% />""";
                              _htmlController.insertHtml(base64Image);
                            }
                            return false;
                          },
                          defaultToolbarButtons: [
                            // FontSettingButtons(),
                            const FontButtons(
                              bold: true,
                              italic: true,
                              underline: true,
                              clearAll: true,
                              strikethrough: true,
                              superscript: false,
                              subscript: false,

                              // StyleButtons(
                            ),
                            const InsertButtons(
                              link: true,
                              picture: true,
                              audio: false,
                              video: false,
                              otherFile: false,
                              table: false,
                              hr: true,
                            )
                            // ColorButtons(),
                          ]),

                      otherOptions: OtherOptions(
                        height: 1000,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  if (attachmentList.length == 0)
                    Row(
                      children: [
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFF636363)),
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
                                attachmentList.length.toString(),
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
                                    _isFileMenuBarSelected =
                                        !_isFileMenuBarSelected;
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
                          if (_isFileMenuBarSelected) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: attachmentList.length,
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
                                                color: Color(
                                                    0xFFF0F0F0), // #F0F0F0 색상
                                                width: 1, // 테두리 두께 1픽셀
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      15), // 반지름 15
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
                                                    path.basename(
                                                        attachmentList[index]
                                                            .filePath!),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  formatBytes(File(
                                                          attachmentList[index]
                                                              .filePath!)
                                                      .lengthSync()),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFFBBBBBB)),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    
                                                    // String text =
                                                    //     await _htmlController
                                                    //         .getText();
                                                    setState(() {
                                          //             _htmlController.setText(
                                          // "이미지가 삭제되었습니다.");
                                                      attachmentList
                                                          .removeAt(index);
                                                      _isLoading = false;
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
                            _selectedCheckboxes[0] = !_selectedCheckboxes[0]!;
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _selectedCheckboxes[0]!
                                ? ColorsInfo.newara
                                : Color(0xFFF0F0F0),
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
                          color: _selectedCheckboxes[0]!
                              ? ColorsInfo.newara
                              : Color(0xFFBBBBBB),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCheckboxes[1] = !_selectedCheckboxes[1]!;
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _selectedCheckboxes[1]!
                                ? ColorsInfo.newara
                                : Color(0xFFF0F0F0),
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
                          color: _selectedCheckboxes[1]!
                              ? ColorsInfo.newara
                              : Color(0xFFBBBBBB),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCheckboxes[2] = !_selectedCheckboxes[2]!;
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _selectedCheckboxes[2]!
                                ? ColorsInfo.newara
                                : Color(0xFFF0F0F0),
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
                          color: _selectedCheckboxes[2]!
                              ? ColorsInfo.newara
                              : Color(0xFFBBBBBB),
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
