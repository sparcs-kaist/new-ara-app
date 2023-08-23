import 'dart:async';
import 'dart:math' as math;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/article_model.dart';
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
  final ArticleModel? previousArticle;
  const PostWritePage({Key? key, this.previousArticle}) : super(key: key);

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

  // 로컬 파일
  String? fileLocalPath;
  String? uuid;

  /// 온라인 파일
  int? id;
  String? fileUrlPath;
  String fileUrlName;
  int fileUrlSize = 0;

  AttachmentsFormat({
    required this.fileType,
    required this.isNewFile,
    this.fileLocalPath,
    this.uuid,
    this.id,
    this.fileUrlPath,
    this.fileUrlName = "",
    this.fileUrlSize = 0,
  });
}

class _PostWritePageState extends State<PostWritePage> {
  bool _isEditingPost = false;

  final _defaultTopicModel = TopicModel(
    id: -1,
    slug: "",
    ko_name: "말머리 없음",
    en_name: "No Topic",
  );
  final _defaultTopicModel2 = TopicModel(
    id: -1,
    slug: "",
    ko_name: "말머리를 선택하세요",
    en_name: "No Topic",
  );
  final _defaultBoardDetailActionModel = BoardDetailActionModel(
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
  bool _isFileMenuBarSelected = false; // 첨부파일 메뉴바가 펼쳐져 있는가?

  BoardDetailActionModel? _chosenBoardValue;
  TopicModel? _chosenTopicValue;

  List<BoardDetailActionModel> _boardList = [];
  List<TopicModel> _specTopicList = [];

  File? imagePickerFile;
  File? filePickerFile;
  bool _isLoading = true;
  bool _isUploadingPost = false; // 지금 api 통신으로 포스트 업로드 중이냐
  var imagePickerResult;
  FilePickerResult? filePickerResult;

  final List<AttachmentsFormat> _attachmentList = [];

  late TargetPlatform? platform;

  final TextEditingController _titleController = TextEditingController();
  final HtmlEditorController _htmlController = HtmlEditorController();
  String _currentHtmlContent = "";

  final ScrollController _listScrollController = ScrollController();

  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.previousArticle != null)
      _isEditingPost = true;
    else
      _isEditingPost = false;

    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }

    // Subscribe
    // keyboardSubscription =
    //     keyboardVisibilityController.onChange.listen((bool visible) {
    //   print('Keyboard visibility update. Is visible: $visible');
    //   setState(() {
    //     if (visible) {
    //       _isBottomShow = false;
    //     } else {
    //       _isBottomShow = true;
    //     }
    //   });
    // });

    _initPostWritePost();
  }

  Future<void> _initPostWritePost() async {
    await _getBoardList();
    await _getPostContent();
  }

  Future<void> _getBoardList() async {
    var userProvider = context.read<UserProvider>();
    try {
      Dio dio = Dio();
      dio.options.headers['Cookie'] = userProvider.getCookiesToString();
      var response = await dio.get('$newAraDefaultUrl/api/boards/');
      debugPrint(response.data.toString());

      _boardList = [_defaultBoardDetailActionModel];
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
      _specTopicList.add(_defaultTopicModel);

      _chosenTopicValue = _specTopicList[0];
      _chosenBoardValue = _boardList[0];
      _isLoading = false;
    });
    return;
  }

  Future<void> _getPostContent() async {
    if (!_isEditingPost) return;
    setState(() {
      _isLoading = true;
    });
    String? title = widget.previousArticle!.title;
    _titleController.text = title ?? '';

    for (int i = 0; i < widget.previousArticle!.attachments.length; i++) {
      // _attachmentList
      //     .add(AttachmentsFormat(fileType: FileType.Image, isNewFile: false));
      AttachmentModel attachment = widget.previousArticle!.attachments[i];

      int id = attachment.id;
      String? fileUrlPath = attachment.file;
      String fileUrlName = _extractAndDecodeFileNameFromUrl(attachment.file);
      int? fileUrlSize = attachment.size ?? 0;
      _attachmentList.add(AttachmentsFormat(
          fileType: FileType.Image,
          isNewFile: false,
          id: id,
          fileUrlPath: fileUrlPath,
          fileUrlName: fileUrlName,
          fileUrlSize: fileUrlSize));
    }

    setState(() {
      _isFileMenuBarSelected = _attachmentList.length > 0 ? true : false;

      _selectedCheckboxes[1] =
          widget.previousArticle?.is_content_sexual ?? false;
      _selectedCheckboxes[2] =
          widget.previousArticle?.is_content_social ?? false;

      _isLoading = false;
    });
    setState(() {
      BoardDetailActionModel boardDetailActionModel =
          _findBoardListValue(widget.previousArticle!.parent_board.slug);
      _specTopicList = [];
      _specTopicList.add(_defaultTopicModel);
      for (TopicModel topic in boardDetailActionModel.topics) {
        _specTopicList.add(topic);
      }
      _chosenTopicValue = widget.previousArticle!.parent_topic == null
          ? _specTopicList[0]
          : _findSpecTopicListValue(widget.previousArticle!.parent_topic!.slug);
      _chosenBoardValue = boardDetailActionModel;
    });
  }

  BoardDetailActionModel _findBoardListValue(String slug) {
    for (BoardDetailActionModel board in _boardList) {
      if (board.slug == slug) {
        return board;
      }
    }
    return _defaultBoardDetailActionModel;
  }

  TopicModel _findSpecTopicListValue(String slug) {
    for (TopicModel topic in _specTopicList) {
      if (topic.slug == slug) {
        return topic;
      }
    }
    return _defaultTopicModel;
  }

  String _extractAndDecodeFileNameFromUrl(String url) {
    String encodedFilename = url.split('/').last;
    return Uri.decodeFull(encodedFilename);
  }

  // void _getCurrentHtmlContent() async {
  //   try {
  //     String tmp = await _htmlController.getText();
  //     setState(() {
  //       _currentHtmlContent = tmp;
  //     });
  //   } catch (error) {
  //     debugPrint(
  //         "refreshBoardList BoardDetailActionModel.fromJson failed: $error");
  //     return;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const LoadingIndicator();

    var userProvider = context.watch<UserProvider>();

    bool canIupload = _titleController.text != '' &&
        _chosenBoardValue!.id != -1 &&
        _currentHtmlContent != '' &&
        _currentHtmlContent != '<p><br></p>' &&
        _isUploadingPost == false;

    //  _getCurrentHtmlContent();

    String updateImgTagSrc(htmlString, uuid, fileUrl) {
      var document = parse(htmlString);
      // debugPrint(document.body?.innerHtml ?? '');
      List<html.Element> imgTags = document.getElementsByTagName('img');

      if (uuid == null) return document.body?.innerHtml ?? '';

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
      //  debugPrint(document.body?.innerHtml ?? '');
      return document.body?.innerHtml ?? '';
    }

    String deleteImgTagSrc(htmlString, fileUrl) {
      var document = parse(htmlString);
      // debugPrint(document.body?.innerHtml ?? '');
      List<html.Element> imgTags = document.getElementsByTagName('img');

      for (var imgTag in imgTags) {
        if (imgTag.attributes['src'] == fileUrl) {
          imgTag.remove();
        }
      }
      //  debugPrint(document.body?.innerHtml ?? '');
      return document.body?.innerHtml ?? '';
    }

    String updateImgTagWidth(String htmlString) {
      var document = parse(htmlString);
      // debugPrint(document.body?.innerHtml ?? '');
      List<html.Element> imgTags = document.getElementsByTagName('img');

      for (var imgTag in imgTags) {
        imgTag.attributes['width'] = '100%';
      }
      //  debugPrint(document.body?.innerHtml ?? '');
      return document.body?.innerHtml ?? '';
    }

    String preventHangleError(String htmlString) {
      return htmlString;
      //   return htmlString.replaceAll('<p><br></p>', '<p><br></p><p></p>');
    }

    Future<void> filePick() async {
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
          _attachmentList.add(AttachmentsFormat(
            fileType: FileType.Other,
            isNewFile: true,
            fileLocalPath: file.path,
          ));
        });
      }
    }

    // Future<void> _imagePick() async {
    //   imagePickerResult =
    //       await ImagePicker().pickImage(source: ImageSource.gallery);
    //   if (imagePickerResult != null) {
    //     debugPrint(imagePickerResult.path);
    //     setState(() {
    //       imagePickerFile = File(imagePickerResult.path);
    //     });
    //   }
    // }

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

    void uploadPost() async {
      // 포스트 업로드;
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
      setState(() {
        _isUploadingPost = true;
      });
      try {
        Dio dio = Dio();
        dio.options.headers['Cookie'] = userProvider.getCookiesToString();
        for (int i = 0; i < _attachmentList.length; i++) {
          if (_attachmentList[i].isNewFile) {
            var attachFile = File(_attachmentList[i].fileLocalPath!);
            //이 파일 uuid 에 해당하는 img 태그가 html 안에 있다면 변경해야한다.

            // 파일이 존재하는지 확인
            if (attachFile.existsSync()) {
              var dio = Dio();
              dio.options.headers['Cookie'] = userProvider.getCookiesToString();
              var formData = FormData.fromMap({
                "file": await MultipartFile.fromFile(attachFile.path,
                    filename: attachFile.path
                        .split('/')
                        .last), // You may need to replace '/' with '\\' if you're using Windows.
              });
              try {
                var response = await dio
                    .post("$newAraDefaultUrl/api/attachments/", data: formData);
                debugPrint("Response: ${response.data}");
                final attachmentModel = AttachmentModel.fromJson(response.data);
                attachmentIds.add(attachmentModel.id);
                contentValue = updateImgTagSrc(contentValue,
                    _attachmentList[i].uuid, attachmentModel.file);
              } catch (error) {
                debugPrint("$error");
              }
            } else {
              debugPrint("File does not exist: ${attachFile.path}");
            }
          }
        }

        var response = await dio.post(
          '$newAraDefaultUrl/api/articles/',
          data: {
            'title': titleValue,
            'content': contentValue,
            'attachments': attachmentIds,
            'parent_topic':
                _chosenTopicValue!.id == -1 ? '' : _chosenTopicValue!.id,
            'is_content_sexual': _selectedCheckboxes[1],
            'is_content_social': _selectedCheckboxes[2],
            'parent_board': _chosenBoardValue!.id,
            'name_type': 'REGULAR'
          },
        );

        debugPrint('Response data: ${response.data}');
        Navigator.pop(context);
      } on DioException catch (error) {
        debugPrint('post Error: ${error.response!.data}');
      }
      setState(() {
        _isUploadingPost = false;
      });
    }

    void updatePost() async {
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
      setState(() {
        _isUploadingPost = true;
      });

      try {
        Dio dio = Dio();
        dio.options.headers['Cookie'] = userProvider.getCookiesToString();
        for (int i = 0; i < _attachmentList.length; i++) {
          if (_attachmentList[i].isNewFile) {
            var attachFile = File(_attachmentList[i].fileLocalPath!);
            //이 파일 uuid 에 해당하는 img 태그가 html 안에 있다면 변경해야한다.

            // 파일이 존재하는지 확인
            if (attachFile.existsSync()) {
              var dio = Dio();
              dio.options.headers['Cookie'] = userProvider.getCookiesToString();
              var formData = FormData.fromMap({
                "file": await MultipartFile.fromFile(attachFile.path,
                    filename: attachFile.path
                        .split('/')
                        .last), // You may need to replace '/' with '\\' if you're using Windows.
              });
              try {
                var response = await dio
                    .post("$newAraDefaultUrl/api/attachments/", data: formData);
                debugPrint("Response: ${response.data}");
                final attachmentModel = AttachmentModel.fromJson(response.data);
                attachmentIds.add(attachmentModel.id);
                contentValue = updateImgTagSrc(contentValue,
                    _attachmentList[i].uuid, attachmentModel.file);
              } catch (error) {
                debugPrint("$error");
              }
            } else {
              debugPrint("File does not exist: ${attachFile.path}");
            }
          } else {
            attachmentIds.add(_attachmentList[i].id!);
          }
        }

        var response = await dio.put(
          '$newAraDefaultUrl/api/articles/${widget.previousArticle!.id}/',
          data: {
            'title': titleValue,
            'content': contentValue,
            'attachments': attachmentIds,
            // 'parent_topic':
            //     _chosenTopicValue!.id == -1 ? '' : _chosenTopicValue!.id,
            'is_content_sexual': _selectedCheckboxes[1],
            'is_content_social': _selectedCheckboxes[2],
            // 'parent_board': _chosenBoardValue!.id,
            'name_type': 'REGULAR'
          },
        );

        debugPrint('Response data: ${response.data}');
        Navigator.pop(context);
      } on DioException catch (error) {
        debugPrint('post Error: ${error.response!.data}');
      }
    }

    void onAttachmentDelete(int index) async {
      String text = await _htmlController.getText();

      if (_attachmentList[index].isNewFile) {
        String nextText =
            updateImgTagSrc(text, _attachmentList[index].uuid, null);
        debugPrint("next : $nextText");
        _htmlController.setText(nextText);
      } else {
        String nextText =
            deleteImgTagSrc(text, _attachmentList[index].fileUrlPath);
        debugPrint("next : $nextText");
        _htmlController.setText(nextText);
      }

      setState(() {
        _attachmentList.removeAt(index);
        _isLoading = false;
      });
    }

    void setSpecTopicList(BoardDetailActionModel? value) {
      setState(() {
        _specTopicList = [];
        _specTopicList.add(_defaultTopicModel2);
        for (TopicModel topic in value!.topics) {
          _specTopicList.add(topic);
        }
        _chosenTopicValue = _specTopicList[0];
        _chosenBoardValue = value;
      });
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
                  width: 35,
                  height: 35,
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
          MaterialButton(
            onPressed:
                canIupload ? (_isEditingPost ? updatePost : uploadPost) : null,
            // 버튼이 클릭되었을 때 수행할 동작
            padding: EdgeInsets.zero, // 패딩 제거
            child: canIupload
                ? Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: ColorsInfo.newara,
                    ),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 65.0, maxHeight: 35.0),
                      alignment: Alignment.center,
                      child: Text(
                        '올리기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : Ink(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.transparent,
                        border: Border.all(
                          color: Color(0xFFF0F0F0), // #F0F0F0 색상
                          width: 1, // 테두리 두께 1픽셀
                        )),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 65.0, maxHeight: 35.0),
                      alignment: Alignment.center,
                      child: Text(
                        '올리기',
                        style: TextStyle(color: Color(0xFFBBBBBB)),
                      ),
                    ),
                  ),
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
                        child: DropdownButton<BoardDetailActionModel>(
                          //  isDense: true,
                          //isExpanded: true,

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
                                    color: value.id == -1 || _isEditingPost
                                        ? Color(0xFFBBBBBB)
                                        : ColorsInfo.newara,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: _isEditingPost ? null : setSpecTopicList,
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
                            // setState(() {
                            //   _htmlController.resetHeight();
                            //   _htmlController.recalculateHeight();
                            // });
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
                                    color: value.id == -1 || _isEditingPost
                                        ? Color(0xFFBBBBBB)
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: _isEditingPost
                              ? null
                              : (TopicModel? value) {
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
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: _titleController,
                    minLines: 1,
                    maxLines: 1,
                    maxLength: 255,
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
                      counterStyle: TextStyle(
                        height: double.minPositive,
                      ),
                      counterText: "",
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
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                HtmlEditor(
                                  callbacks: Callbacks(
                                      onChangeContent: (String? value) {
                                    debugPrint("onChangeContent: $value");
                                    setState(() {
                                      _currentHtmlContent = value!;
                                    });
                                  }),
                                  controller: _htmlController, //required
                                  htmlEditorOptions: HtmlEditorOptions(
                                    shouldEnsureVisible: true,
                                    autoAdjustHeight: false,
                                    hint: "<p>내용을 입력해주세요.</p>",
                                    initialText: widget.previousArticle == null
                                        ? null
                                        : updateImgTagWidth(
                                            widget.previousArticle!.content!),
                                  ),
                                  htmlToolbarOptions: HtmlToolbarOptions(
                                      toolbarType: ToolbarType.nativeGrid,
                                      mediaUploadInterceptor:
                                          (PlatformFile file,
                                              InsertFileType type) async {
                                        if (type == InsertFileType.image) {
                                          // var uuid = Uuid();
                                          String uuid = const Uuid().v4();
                                          setState(() {
                                            _isFileMenuBarSelected = true;
                                            _attachmentList
                                                .add(AttachmentsFormat(
                                              fileType: FileType.Image,
                                              isNewFile: true,
                                              fileLocalPath: file.path,
                                              uuid: uuid,
                                            ));
                                          });

                                          ///src랑 file.path랑 연결해줘야함.
                                          String base64Data =
                                              base64.encode(file.bytes!);
                                          String base64Image =
                                              """<img data-uuid=$uuid  src="data:image/${file.extension};base64,$base64Data" data-filename="${file.name}" width=100% />""";
                                          _htmlController
                                              .insertHtml(base64Image);
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
                                    height: 450,
                                    // decoration: BoxDecoration(
                                    //   border: Border.None,
                                    // )
                                  ),
                                ),
                                // Container(
                                //   color: Colors.blue,
                                //   height: 10,
                                // )
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //   height: 5,
                        //   color: Colors.yellow,
                        // )
                      ],
                    ),
                  ),
                  KeyboardVisibilityBuilder(
                    builder: (context, isKeyboardVisible) {
                      if (isKeyboardVisible) {
                        _isFileMenuBarSelected = false;

                        return Container();
                      } else {
                        return Column(
                          children: [
                            if (_attachmentList.length == 0)
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: filePick,
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
                                          _attachmentList.length.toString(),
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
                                          onTap: () => filePick(),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: SizedBox(
                                          //최대 4개까지 첨부파일 보여주고 그 이후로는 스크롤.
                                          height: 10 +
                                              math.min(3,
                                                      _attachmentList.length) *
                                                  44 +
                                              5 *
                                                  (math.min(
                                                          3,
                                                          _attachmentList
                                                              .length) -
                                                      1),

                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                child: Scrollbar(
                                                  thumbVisibility: true,
                                                  child: ListView.builder(
                                                    controller:
                                                        _listScrollController,
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        _attachmentList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          if (index != 0)
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                          Container(
                                                            height: 44,
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                color: Color(
                                                                    0xFFF0F0F0), // #F0F0F0 색상
                                                                width:
                                                                    1, // 테두리 두께 1픽셀
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15), // 반지름 15
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 6,
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  'assets/icons/pdf.svg',
                                                                  width: 30,
                                                                  height: 30,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    _attachmentList[index]
                                                                            .isNewFile
                                                                        ? path.basename(_attachmentList[index]
                                                                            .fileLocalPath!)
                                                                        : _attachmentList[index]
                                                                            .fileUrlName,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Text(
                                                                  _attachmentList[
                                                                              index]
                                                                          .isNewFile
                                                                      ? formatBytes(
                                                                          File(_attachmentList[index].fileLocalPath!)
                                                                              .lengthSync())
                                                                      : formatBytes(
                                                                          _attachmentList[index]
                                                                              .fileUrlSize),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Color(
                                                                          0xFFBBBBBB)),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    onAttachmentDelete(
                                                                        index);
                                                                  },
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/icons/close.svg',
                                                                    width: 30,
                                                                    height: 30,
                                                                    color: Color(
                                                                        0xFFBBBBBB),
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
                                                ),
                                              ),
                                            ],
                                          ),
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
                                // GestureDetector(
                                //   onTap: () {
                                //     setState(() {
                                //       _selectedCheckboxes[0] = !_selectedCheckboxes[0]!;
                                //     });
                                //   },
                                //   child: Container(
                                //     width: 20,
                                //     height: 20,
                                //     decoration: BoxDecoration(
                                //       color: _selectedCheckboxes[0]!
                                //           ? ColorsInfo.newara
                                //           : Color(0xFFF0F0F0),
                                //       borderRadius: BorderRadius.circular(5.0),
                                //     ),
                                //     alignment: Alignment.center,
                                //     child: SvgPicture.asset(
                                //       'assets/icons/check.svg',
                                //       width: 16,
                                //       height: 16,
                                //       color: Colors.white,
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(
                                //   width: 6,
                                // ),
                                // Text(
                                //   "익명",
                                //   style: TextStyle(
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w500,
                                //     color: _selectedCheckboxes[0]!
                                //         ? ColorsInfo.newara
                                //         : Color(0xFFBBBBBB),
                                //   ),
                                // ),
                                // SizedBox(
                                //   width: 15,
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedCheckboxes[1] =
                                          !_selectedCheckboxes[1]!;
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
                                      _selectedCheckboxes[2] =
                                          !_selectedCheckboxes[2]!;
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
                        );
                      }
                    },
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
