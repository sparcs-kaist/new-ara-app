import 'dart:async';
import 'dart:math' as math;
import 'dart:convert';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:new_ara_app/providers/notification_provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as html;

import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:quill_markdown/quill_markdown.dart';

import 'package:markdown_quill/markdown_quill.dart';
import 'package:markdown/markdown.dart' as md;

/// 사용자가 게시물을 작성하거나 편집할 수 있는 페이지를 나타내는 StatefulWidget입니다.
class PostWritePage extends StatefulWidget {
  /// 사용자가 기존 게시물을 편집하는 경우 이 변수에 이전 게시물의 데이터가 저장됩니다.
  final ArticleModel? previousArticle;

  /// 생성자에서 이전 게시물의 데이터를 선택적으로 받을 수 있습니다.
  const PostWritePage({Key? key, this.previousArticle}) : super(key: key);

  @override
  State<PostWritePage> createState() => _PostWritePageState();
}

/// 첨부 파일의 유형을 나타내는 열거형입니다.
/// TODO: pdf, doc 같은 파일 유형 추가하기.
enum FileType {
  Image,
  Other,
}

/// 첨부 파일의 형식 및 속성을 나타내는 클래스입니다.
///
class AttachmentsFormat {
  FileType fileType;

  /// 수정 시에 추가한 파일인지 판별해서, 새로 추가한 파일만 api 요청으로 업로드하기 위해 설계.
  bool isNewFile;

  /// 로컬에 있는 파일 경로
  String? fileLocalPath;

  /// 파일마다 고유한 uuid를 할당해서, 파일을 지우거나 편집할 때 인식할 수 있도록함.
  String? uuid;

  /// 클라우드에 업로드 되어있는 파일에 대한 정보.
  /// 게시물 수정 시 기존 첨부파일 정보를 저장하기 위해 필요.
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
  /// 현재 이 페이지가 수정페이지이면 true, 처음 작성하는 게시물이면 false
  bool _isEditingPost = false;

  /// 기본 게시판 및 주제 모델.
  /// 아무 것도 선택하기 전 초기 상태를 나타냄.
  final _defaultTopicModel = TopicModel(
    id: -1,
    slug: "",
    ko_name: "말머리 없음",
    en_name: "No Topic",
  );

  // 기본 게시판 및 주제 모델.
  // 메뉴바에서 게시물 주제 선택 후 토픽 메뉴 초기 상태를 나타낸다.
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

  /// 익명, 성인, 정치 체크 박스가 선택되어 있는지 판별을 위한 리스트
  List<bool?> _selectedCheckboxes = [true, false, false];

  /// 첨부파일 메뉴바가 펼쳐져 있는 지 판별을 위한 변수
  bool _isFileMenuBarSelected = false;

  /// 사용자가 선택한 게시판 모델
  BoardDetailActionModel? _chosenBoardValue;

  /// 사용자가 선택한 토픽 모델
  TopicModel? _chosenTopicValue;

  /// 사용자에게 보여줄 게시판 메뉴 목록
  List<BoardDetailActionModel> _boardList = [];

  /// 사용자에게 보여줄 토픽 메뉴 목록
  List<TopicModel> _specTopicList = [];

  // 페이지 로딩 시 대기 화면을 띄우기 위한 변수
  bool _isLoading = true;
  // 지금 포스트 업로드 중이냐
  bool _isUploadingPost = false;

  // TODO: 함수 안에 지역 변수로 넣는거 고려하기.
  FilePickerResult? filePickerResult;

  /// 사용자에게 보여주는 첨부파일 목록
  final List<AttachmentsFormat> _attachmentList = [];

  late TargetPlatform? platform;

  final TextEditingController _titleController = TextEditingController();
  final HtmlEditorController _htmlController = HtmlEditorController();

  final ScrollController _listScrollController = ScrollController();

  late StreamSubscription<bool> keyboardSubscription;

  quill.QuillController _quillController = quill.QuillController.basic();

  @override
  void initState() {
    super.initState();

    context.read<NotificationProvider>().checkIsNotReadExist();

    if (widget.previousArticle != null)
      _isEditingPost = true;
    else
      _isEditingPost = false;

    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    _initPostWritePost();
  }

  /// 게시판 목록을 가져온다.
  /// 이전 게시물의 데이터를 가져온다.
  Future<void> _initPostWritePost() async {
    await _getBoardList();
    await _getPostContent();
  }

  /// 사용자가 선택 가능한 게시판 목록을 가져오는 함수.
  /// API에서 게시판 목록을 가져와 `_boardList`에 저장.
  Future<void> _getBoardList() async {
    // 사용자 정보 제공자로부터 쿠키 정보 가져오기.
    var userProvider = context.read<UserProvider>();
    try {
      Dio dio = Dio();
      dio.options.headers['Cookie'] = userProvider.getCookiesToString();
      var response = await dio.get('$newAraDefaultUrl/api/boards/');

      // 기본 게시판 정보를 `_boardList`에 초기화.
      _boardList = [_defaultBoardDetailActionModel];

      // API 응답으로부터 게시판 목록 파싱 후 `_boardList`에 추가.
      for (Map<String, dynamic> json in response.data) {
        try {
          BoardDetailActionModel boardDetail =
              BoardDetailActionModel.fromJson(json);
          if (boardDetail.user_writable) {
            _boardList.add(boardDetail);
          }
        } catch (error) {
          debugPrint(
              "refreshBoardList BoardDetailActionModel.fromJson 실패: $error");
          return;
        }
      }
    } catch (error) {
      return;
    }

    // 상태 업데이트.
    setState(() {
      _specTopicList.add(_defaultTopicModel);
      _chosenTopicValue = _specTopicList[0];
      _chosenBoardValue = _boardList[0];
      _isLoading = false;
    });
  }

  /// 기존 게시물의 내용과 첨부 파일 가져오기.
  Future<void> _getPostContent() async {
    if (!_isEditingPost) return;

    setState(() {
      _isLoading = true;
    });

    String? title = widget.previousArticle!.title;
    _titleController.text = title ?? '';

    // 첨부 파일 정보 파싱 후 `_attachmentList`에 추가.
    for (int i = 0; i < widget.previousArticle!.attachments.length; i++) {
      AttachmentModel attachment = widget.previousArticle!.attachments[i];
      int id = attachment.id;
      String? fileUrlPath = attachment.file;
      String fileUrlName = _extractAndDecodeFileNameFromUrl(attachment.file);
      int? fileUrlSize = attachment.size ?? 0;

      // TODO: fileType이 이미지인지 아닌지 판단해서 넣기.
      _attachmentList.add(AttachmentsFormat(
          fileType: FileType.Image,
          isNewFile: false,
          id: id,
          fileUrlPath: fileUrlPath,
          fileUrlName: fileUrlName,
          fileUrlSize: fileUrlSize));
    }

    // 수정 게시물의 기존 상태 반영.
    setState(() {
      _quillController.document = quill.Document.fromDelta(
          _htmlToQuillDelta(widget.previousArticle!.content!));
      _isFileMenuBarSelected = _attachmentList.isNotEmpty;
      _selectedCheckboxes[1] =
          widget.previousArticle?.is_content_sexual ?? false;
      _selectedCheckboxes[2] =
          widget.previousArticle?.is_content_social ?? false;
      _isLoading = false;
    });

    // 게시판 및 주제 정보 업데이트.
    setState(() {
      BoardDetailActionModel boardDetailActionModel =
          _findBoardListValue(widget.previousArticle!.parent_board.slug);
      _specTopicList = [_defaultTopicModel];
      _specTopicList.addAll(boardDetailActionModel.topics);
      _chosenTopicValue = widget.previousArticle!.parent_topic == null
          ? _specTopicList[0]
          : _findSpecTopicListValue(widget.previousArticle!.parent_topic!.slug);
      _chosenBoardValue = boardDetailActionModel;
    });
  }

  /// 주어진 slug 값을 사용하여 게시판 목록에서 해당 게시판을 찾는 함수.
  BoardDetailActionModel _findBoardListValue(String slug) {
    for (BoardDetailActionModel board in _boardList) {
      if (board.slug == slug) {
        return board;
      }
    }
    return _defaultBoardDetailActionModel;
  }

  /// 주어진 slug 값을 사용하여 토픽 목록에서 해당 주제를 찾는 함수.
  TopicModel _findSpecTopicListValue(String slug) {
    for (TopicModel topic in _specTopicList) {
      if (topic.slug == slug) {
        return topic;
      }
    }
    return _defaultTopicModel;
  }

  /// 주어진 url에서 파일 이름을 추출하는 함수.
  String _extractAndDecodeFileNameFromUrl(String url) {
    String encodedFilename = url.split('/').last;
    return Uri.decodeFull(encodedFilename);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const LoadingIndicator();

    var userProvider = context.watch<UserProvider>();

    /// 게시물 업로드 가능한지 확인
    String _currentHtmlContent =
        DeltaToHTML.encodeJson(_quillController.document.toDelta().toJson());
    bool canIupload = _titleController.text != '' &&
        _chosenBoardValue!.id != -1 &&
        _currentHtmlContent != '' &&
        _currentHtmlContent != '<br>' &&
        _isUploadingPost == false;

    Widget _buildMenubar() {
      return Container(
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
                    // TODO: 원하는 메뉴 모양 만들기 위해 속성 테스트 할 것
                    // isDense: true,
                    // isExpanded: true,

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

                    /// 게시판 선택 이후 토픽 목록이 변해야 하므로 변경하는 기능 추가
                    /// TODO: 함수 따로 빼기
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
                    value: _chosenTopicValue,
                    style: TextStyle(color: Colors.red),
                    items: _specTopicList
                        .map<DropdownMenuItem<TopicModel>>((TopicModel value) {
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

                    /// 토픽 선택하는 기능
                    /// TODO: 함수 따로 빼기
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
          ],
        ),
      );
    }

    Widget _buildTitle() {
      return TextField(
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
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent, // 테두리 색상 설정
            ), // 모서리를 둥글게 설정
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent, // 테두리 색상 설정
            ), // 모서리를 둥글게 설정
          ),
        ),
        cursorColor: Colors.transparent,
      );
    }

    Widget _buildAttachmentShow() {
      return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          if (isKeyboardVisible && false) {
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
                            onTap: _pickFile,
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
                              onTap: () => _pickFile(),
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
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              //최대 4개까지 첨부파일 보여주고 그 이후로는 스크롤.
                              //피그마 디자인 기준으로 필요한 높이를 계산함.
                              height: 10 +
                                  math.min(3, _attachmentList.length) * 44 +
                                  5 * (math.min(3, _attachmentList.length) - 1),

                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: CupertinoScrollbar(
                                      thumbVisibility: true,
                                      controller: _listScrollController,
                                      child: ListView.builder(
                                        controller: _listScrollController,
                                        shrinkWrap: true,
                                        itemCount: _attachmentList.length,
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
                                                        _attachmentList[index]
                                                                .isNewFile
                                                            ? path.basename(
                                                                _attachmentList[
                                                                        index]
                                                                    .fileLocalPath!)
                                                            : _attachmentList[
                                                                    index]
                                                                .fileUrlName,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      _attachmentList[index]
                                                              .isNewFile
                                                          ? formatBytes(File(
                                                                  _attachmentList[
                                                                          index]
                                                                      .fileLocalPath!)
                                                              .lengthSync())
                                                          : formatBytes(
                                                              _attachmentList[
                                                                      index]
                                                                  .fileUrlSize),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color(
                                                              0xFFBBBBBB)),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        _onAttachmentDelete(
                                                            index);
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/icons/close.svg',
                                                        width: 30,
                                                        height: 30,
                                                        color:
                                                            Color(0xFFBBBBBB),
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
                    // TODO: 익명 선택하는 기능 추가하고 익명 보여주는 기능 추가하기
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
      );
    }

    Widget _buildRegacy() {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          HtmlEditor(
                            callbacks:
                                Callbacks(onChangeContent: (String? value) {
                              debugPrint("onChangeContent: $value");
                              setState(() {
                                // _currentHtmlContent = value!;
                              });
                            }),
                            controller: _htmlController,
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

                                /// 사진 추가 시 base64 인코딩하여 태그로 추가. (이미지 첨부 기능)
                                /// uuid를 할당하여 각각 태그가 구분 가능하게하고, 추후 태그를 수정 가능하도록 함.
                                mediaUploadInterceptor: (PlatformFile file,
                                    InsertFileType type) async {
                                  if (type == InsertFileType.image) {
                                    String uuid = const Uuid().v4();
                                    setState(() {
                                      _isFileMenuBarSelected = true;
                                      _attachmentList.add(AttachmentsFormat(
                                        fileType: FileType.Image,
                                        isNewFile: true,
                                        fileLocalPath: file.path,
                                        uuid: uuid,
                                      ));
                                    });

                                    String base64Data =
                                        base64.encode(file.bytes!);
                                    String base64Image =
                                        """<img data-uuid=$uuid  src="data:image/${file.extension};base64,$base64Data" data-filename="${file.name}" width=100% />""";
                                    _htmlController.insertHtml(base64Image);
                                  }
                                  return false;
                                },
                                defaultToolbarButtons: [
                                  const FontButtons(
                                    bold: true,
                                    italic: true,
                                    underline: true,
                                    clearAll: true,
                                    strikethrough: true,
                                    superscript: false,
                                    subscript: false,
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
                                ]),
                            otherOptions: OtherOptions(
                              height: 450,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
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
            /// 포스트 업로드하는 기능
            /// TODO: 함수 따로 빼기
            onPressed: canIupload
                ? (_isEditingPost
                    ? _managePost(userProvider,
                        isUpdate: true,
                        previousArticleId: widget.previousArticle!.id)
                    : _managePost(userProvider))
                : null,
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
            _buildMenubar(),
            _buildTitle(),
            Container(
              height: 1,
              color: Color(0xFFF0F0F0),
            ),
            quill.QuillToolbar.basic(
              controller: _quillController,
              multiRowsDisplay: true,
              showUndo: false,
              showRedo: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showFontFamily: false,
              showFontSize: false,
              showDividers: false,
              showListCheck: false,
              showSearchButton: false,
              showSubscript: false,
              showSuperscript: false,

              toolbarIconAlignment: WrapAlignment.start,
              toolbarIconCrossAlignment: WrapCrossAlignment.start,
              customButtons: [
                quill.QuillCustomButton(
                  icon: Icons.camera_alt,
                  onTap: _pickImage,
                ),
                quill.QuillCustomButton(
                  icon: Icons.settings,
                  onTap: () {
                    debugPrint(DeltaToHTML.encodeJson(
                        _quillController.document.toDelta().toJson()));

                    var json = jsonEncode(_quillController.document.toDelta());
                    List<dynamic> delta = jsonDecode(json);
                    List<dynamic> nwDelta = [];

                    // Delta 리스트를 순회하면서 'insert' 키를 찾습니다.
                    for (Map<String, dynamic> line in delta) {
                      var value = line["insert"];
                      bool flag = true;

                      // 'insert' 키의 값이 맵인 경우, 이 맵을 순회하여 'image' 키를 찾습니다.
                      if (value is Map<String, dynamic>) {
                        for (var newKey in value.keys) {
                          if (newKey == "image") {
                            flag = false;
                            // 'image' 키의 값이 "abc"인 경우, 해당 라인을 삭제합니다.
                          }
                        }
                      }
                      if (flag) nwDelta.add(line);
                    }

                    // 수정된 Delta를 다시 JSON으로 인코딩하고 Document로 변환합니다.
                    String newJson = jsonEncode(nwDelta);
                    quill.Delta newDelta =
                        quill.Delta.fromJson(jsonDecode(newJson));
                    setState(() {
                      _quillController.document =
                          quill.Document.fromJson(newDelta.toJson());
                    });
                  },
                ),
              ],
              // embedButtons: FlutterQuillEmbeds.buttons(),
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                 
                  child: quill.QuillEditor.basic(
                              controller: _quillController,
                              embedBuilders: FlutterQuillEmbeds.builders(),
                              readOnly: false, // The editor is editable
                            ),
                )),
            _buildAttachmentShow()
          ],
        ),
      ),
    );
  }

  quill.Delta _htmlToQuillDelta(String html) {
    debugPrint("1 : " + html);
    // HTML을 마크다운으로 변환
    var markdown = html2md.convert(
      html,
      styleOptions: {
        'headingStyle': 'atx',
      },
    );
    debugPrint("2 : " + markdown);

    // 마크다운을 Delta로 변환
    var deltaJson = markdownToQuill(markdown);
    debugPrint("3 : " + deltaJson!);

    final mdDocument = md.Document(encodeHtml: false);

    final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);

    final deltaToMd = DeltaToMarkdown();

    var deltaJson2 = mdToDelta.convert(markdown);
    debugPrint("4 : " + deltaJson2.toString());

    // Delta를 JSON으로 변환
    //var delta = quill.Delta.fromJson(jsonDecode(deltaJson!));

    return deltaJson2;
  }

  /// HTML 문자열 내의 이미지 태그의 너비를 100%로 설정하여 리턴
  String updateImgTagWidth(String htmlString) {
    var document = parse(htmlString);
    List<html.Element> imgTags = document.getElementsByTagName('img');

    for (var imgTag in imgTags) {
      imgTag.attributes['width'] = '100%';
    }
    return document.body?.innerHtml ?? '';
  }

  /// 한글 오류 방지 (현재는 그대로 반환)
  /// TODO: iOS 한글 오류 방지 코드 추가
  String preventHangleError(String htmlString) {
    return htmlString;
  }

  /// 바이트를 적절한 단위로 변환하여 문자열로 반환
  /// TODO: 이 함수는 다른 파일로 분리하는 것이 좋을 것 같음.
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

  String _manageImgTagSrc(String htmlString, String curUrl, String? nexUrl) {
    var document = parse(htmlString);
    List<html.Element> imgTags = document.getElementsByTagName('img');

    for (var imgTag in imgTags) {
      if (imgTag.attributes['src'] == curUrl) {
        if (nexUrl == null) {
          imgTag.remove();
        } else {
          imgTag.attributes['src'] = nexUrl;
        }
      }
    }
    return document.body?.innerHtml ?? '';
  }

  /// 포스트를 서버에 업로드하는 함수이다.
  /// 사용자가 입력한 제목, 내용 및 첨부 파일을 서버에 전송하여 새로운 포스트를 생성한다.
  /// 이 함수는 다음의 단계를 거친다:
  /// 1. 포스트 입력 값을 가져온다..
  /// 2. 첨부 파일이 있으면 서버에 업로드하고, 해당 파일의 ID를 가져온다.
  /// 3. 제목, 내용 및 첨부 파일 ID를 함께 서버에 전송하여 포스트를 생성한다.
  void Function() _managePost(UserProvider userProvider,
      {bool isUpdate = false, int? previousArticleId}) {
    return () async {
      String titleValue;
      String contentValue;
      List<int> attachmentIds = [];
      try {
        titleValue = _titleController.text;
        contentValue = DeltaToHTML.encodeJson(
            _quillController.document.toDelta().toJson());
      } catch (error) {
        debugPrint(error.toString());
        return;
      }
      setState(() {
        _isUploadingPost = true;
        _isLoading = true;
      });

      Dio dio = Dio();
      dio.options.headers['Cookie'] = userProvider.getCookiesToString();

      for (int i = 0; i < _attachmentList.length; i++) {
        //새로 올리는 파일이면 새로운 id 할당 받기.
        if (_attachmentList[i].isNewFile) {
          File attachFile = File(_attachmentList[i].fileLocalPath!);
          bool fileExists = await attachFile.exists();
          if (fileExists) {
            FormData formData = FormData.fromMap({
              "file": await MultipartFile.fromFile(attachFile.path,
                  filename: attachFile.path.split('/').last),
            });
            try {
              Response response = await dio
                  .post("$newAraDefaultUrl/api/attachments/", data: formData);
              final attachmentModel = AttachmentModel.fromJson(response.data);
              attachmentIds.add(attachmentModel.id);
              contentValue = _manageImgTagSrc(contentValue,
                  _attachmentList[i].fileLocalPath!, attachmentModel.file);
            } catch (error) {
              debugPrint("$error");
            }
          }
        } else {
          // 기존에 올라간 파일이면 기존 id만 추가.
          attachmentIds.add(_attachmentList[i].id!);
        }
      }

      try {
        var response;
        var data = {
          'title': titleValue,
          'content': contentValue,
          'attachments': attachmentIds,
          'is_content_sexual': _selectedCheckboxes[1],
          'is_content_social': _selectedCheckboxes[2],
          'name_type': 'REGULAR'
        };

        if (isUpdate) {
          response = await dio.put(
            '$newAraDefaultUrl/api/articles/${previousArticleId}/',
            data: data,
          );
        } else {
          data['parent_topic'] =
              _chosenTopicValue!.id == -1 ? '' : _chosenTopicValue!.id;
          data['parent_board'] = _chosenBoardValue!.id;
          response = await dio.post(
            '$newAraDefaultUrl/api/articles/',
            data: data,
          );
        }

        debugPrint('Response data: ${response.data}');
        Navigator.pop(context);
      } on DioException catch (error) {
        debugPrint('post Error: ${error.response!.data}');
      }

      if (mounted) {
        setState(() {
          _isUploadingPost = false;
          _isLoading = false;
        });
      }
    };
  }

  /// 사진 추가 시 실행되는 함수
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final String imageUrl = image.path;
      final int length = _quillController.document.length;
      final TextSelection selection = _quillController.selection;
      setState(() {
        _quillController.document.insert(
          selection.baseOffset,
          quill.BlockEmbed('image', imageUrl),
        );
      });
      // Insert a blank line (new paragraph) after the image
      _quillController.document.insert(
        selection.baseOffset + 1,
        "\n\n", // Assume ParagraphBlock is a valid Quill block for creating paragraphs
      );

      /// TODO: 사진 첨부 시 첨부파일에도 같이 올라갈 것인지 결정하기.
      String uuid = const Uuid().v4();
      setState(() {
        _isFileMenuBarSelected = true;
        _attachmentList.add(AttachmentsFormat(
          fileType: FileType.Image,
          isNewFile: true,
          fileLocalPath: imageUrl,
          uuid: uuid,
        ));
      });
    }
  }

  /// 첨부파일 추가 시 실행되는 함수
  Future<void> _pickFile() async {
    filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      File file = File(filePickerResult!.files.single.path!);
      if (Platform.isIOS) {
        // iOS에서는 파일을 복사해서 사용했음. 캐쉬로 날라가는 문제 발생해서.
        final documentPath = (await getApplicationDocumentsDirectory()).path;
        file = await file.copy('$documentPath/${path.basename(file.path)}');
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

  void _deleteImageWithSrc(String src, quill.QuillController controller) {
    final length = controller.document.length;
    int i = 0;
    debugPrint(controller.document.toPlainText());
    return;

    // while (i < length) {
    //   final node = controller.document.toPlainText();

    //   if (node.contains('<img src="abc"')) {
    //     final startIndex = node.indexOf('<img src="abc"');
    //     final endIndex = node.indexOf('>', startIndex);
    //     if (endIndex != -1) {
    //       controller.replaceText(
    //         startIndex,
    //         endIndex - startIndex + 1,
    //         '',
    //       );
    //       i = startIndex;
    //     } else {
    //       i += 1;
    //     }
    //   } else {
    //     i += 1;
    //   }
    // }
  }

  /// 첨부 파일 삭제 및 관련 HTML 내용 업데이트
  /// 기존에 업로드된 파일인 경우 API 요청으로 삭제
  /// 새로 추가한 파일인 경우 HTML 내용에서 해당 이미지 태그 삭제
  void _onAttachmentDelete(int index) async {
    String toFind;

    if (_attachmentList[index].isNewFile) {
      toFind = _attachmentList[index].fileLocalPath!;
    } else {
      toFind = _attachmentList[index].fileUrlPath!;
    }
    var json = jsonEncode(_quillController.document.toDelta());
    List<dynamic> delta = jsonDecode(json);
    List<dynamic> nwDelta = [];

    // Delta 리스트를 순회하면서 'insert' 키를 찾습니다.
    for (Map<String, dynamic> line in delta) {
      var value = line["insert"];
      bool flag = true;

      // 'insert' 키의 값이 맵인 경우, 이 맵을 순회하여 'image' 키를 찾습니다.
      if (value is Map<String, dynamic>) {
        for (var newKey in value.keys) {
          if (newKey == "image" && value[newKey] == toFind) {
            flag = false;
            // 'image' 키의 값이 "abc"인 경우, 해당 라인을 삭제합니다.
          }
        }
      }
      if (flag) nwDelta.add(line);
    }

    // 수정된 Delta를 다시 JSON으로 인코딩하고 Document로 변환합니다.
    String newJson = jsonEncode(nwDelta);
    quill.Delta newDelta = quill.Delta.fromJson(jsonDecode(newJson));
    setState(() {
      _quillController.document = quill.Document.fromJson(newDelta.toJson());
    });

    setState(() {
      _attachmentList.removeAt(index);
      _isLoading = false;
    });
  }

  /// 게시판 주제 선택 이후 토픽 목록 변경
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
}
