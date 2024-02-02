import 'dart:async';
import 'dart:math' as math;
import 'dart:convert';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/article_model.dart';
import 'package:new_ara_app/models/attachment_model.dart';
import 'package:new_ara_app/models/board_detail_action_model.dart';
import 'package:new_ara_app/models/simple_board_model.dart';
import 'package:new_ara_app/models/topic_model.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/utils/create_dio_with_config.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
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
  image,
  other,
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
  final _defaultTopicModelNone = TopicModel(
    id: -1,
    slug: "",
    ko_name: "말머리 없음",
    en_name: "No Topic",
  );

  // 기본 게시판 및 주제 모델.
  // 메뉴바에서 게시물 주제 선택 후 토픽 메뉴 초기 상태를 나타낸다.
  final _defaultTopicModelSelect = TopicModel(
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
  final List<bool?> _selectedCheckboxes = [false, false, false];

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

  /// 페이지 로딩 시 대기 화면을 띄우기 위한 변수
  bool _isLoading = true;

  /// 지금 포스트 업로드 중이냐
  bool _isUploadingPost = false;

  /// 에디터에 내용이 있냐?
  bool _hasEditorText = false;

  // TODO: 함수 안에 지역 변수로 넣는거 고려하기.
  FilePickerResult? filePickerResult;

  /// 사용자에게 보여주는 첨부파일 목록
  final List<AttachmentsFormat> _attachmentList = [];

  late TargetPlatform? platform;

  final TextEditingController _titleController = TextEditingController();

  // 첨부파일 스크롤 컨트롤러
  final ScrollController _listScrollController = ScrollController();

  final quill.QuillController _quillController = quill.QuillController.basic();

  late FocusNode _titleFocusNode;

  late FocusNode _editorFocusNode;

  @override
  void initState() {
    super.initState();

    context.read<NotificationProvider>().checkIsNotReadExist();

    if (widget.previousArticle != null) {
      _isEditingPost = true;
    } else {
      _isEditingPost = false;
    }

    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }

    _quillController.addListener(_onTextChanged);
    _titleFocusNode = FocusNode();
    _editorFocusNode = FocusNode();
    _initPostWritePost();

    //위젯 트리가 빌드된 직후에 포커스를 요청합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_titleFocusNode);
    });
  }

  void _onTextChanged() {
    //build 함수 다시 실행해서 글 올릴 수 잇는지 유효성 검사.
    bool hasText = _quillController.document.length > 1;
    debugPrint("hasText : $hasText");
    if (hasText != _hasEditorText) {
      setState(() {
        _hasEditorText = hasText;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocusNode.dispose();
    _editorFocusNode.dispose();
    _quillController.removeListener(_onTextChanged);
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
      Dio dio = createDioWithConfig();
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
    } on DioException catch (e) {
      if (e.response != null) {
        // 응답이 있는 에러
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // 응답이 없는 에러
        print('Error sending request!');
        print(e.message);
      }
    } catch (error) {
      return;
    }

    // 상태 업데이트.
    setState(() {
      _specTopicList.add(_defaultTopicModelSelect);
      _chosenTopicValue = _specTopicList[0];
      _chosenBoardValue = _boardList[0];
      _isLoading = false;
    });
  }

  /// 기존 게시물의 내용과 첨부 파일 가져오기.
  Future<void> _getPostContent() async {
    // 새로 작성하는 게시물의 경우 함수 종료.
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
          fileType: FileType.image,
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
      //TODO: 명명 규칙 다름
      _selectedCheckboxes[0] =
          widget.previousArticle?.name_type == 2 ? true : false;
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
      _specTopicList = [_defaultTopicModelNone];
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
    return _defaultTopicModelNone;
  }

  /// 주어진 url에서 파일 이름을 추출하는 함수.
  String _extractAndDecodeFileNameFromUrl(String url) {
    String encodedFilename = url.split('/').last;
    return Uri.decodeFull(encodedFilename);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserProvider>();

    /// 게시물 업로드 가능한지 확인
    /// TODO: 업로드 로딩 인디케이터 추가하기
    bool canIupload = _titleController.text != '' &&
        _chosenBoardValue!.id != -1 &&
        _isUploadingPost == false &&
        _hasEditorText;

    //빌드 전 첨부파일의 유효성 확인
    _checkAttachmentsValid();

    PreferredSizeWidget buildAppBar() {
      return AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/left_chevron.svg',
              colorFilter: const ColorFilter.mode(
                Colors.red,
                BlendMode.srcIn,
              ),
              width: 35,
              height: 35),
          onPressed: () => Navigator.pop(context),
        ),
        title: const SizedBox(
          child: Text(
            "글 쓰기",
            style: TextStyle(
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
                          const BoxConstraints(maxWidth: 65.0, maxHeight: 35.0),
                      alignment: Alignment.center,
                      child: const Text(
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
                          color: const Color(0xFFF0F0F0), // #F0F0F0 색상
                          width: 1, // 테두리 두께 1픽셀
                        )),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 65.0, maxHeight: 35.0),
                      alignment: Alignment.center,
                      child: const Text(
                        '올리기',
                        style: TextStyle(color: Color(0xFFBBBBBB)),
                      ),
                    ),
                  ),
          ),
        ],
      );
    }

    Widget buildMenubar() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          width: double.infinity,
          height: 34,
          child: Row(
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<BoardDetailActionModel>(
                      // TODO: 원하는 메뉴 모양 만들기 위해 속성 테스트 할 것
                      // isDense: true,
                      // isExpanded: true,

                      value: _chosenBoardValue,
                      style: const TextStyle(color: Colors.red),
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
                                    ? const Color(0xFFBBBBBB)
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
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<TopicModel>(
                      value: _chosenTopicValue,
                      style: const TextStyle(color: Colors.red),
                      items: _specTopicList.map<DropdownMenuItem<TopicModel>>(
                          (TopicModel value) {
                        return DropdownMenuItem<TopicModel>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              value.ko_name,
                              style: TextStyle(
                                color: value.id == -1 || _isEditingPost
                                    ? const Color(0xFFBBBBBB)
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
        ),
      );
    }

    Widget buildTitle() {
      return TextField(
        controller: _titleController,
        focusNode: _titleFocusNode,
        minLines: 1,
        maxLines: 1,
        maxLength: 255,
        style: const TextStyle(
          height: 1,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        onChanged: (String s) {
          // build 함수를 다시 실행하여 올릴 수 있는 게시물인지 유효성 검사
          setState(() {});
        },
        decoration: const InputDecoration(
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

    Widget buildAttachmentShow() {
      return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          if (isKeyboardVisible) {
            return Column(
              children: [
                Container(
                  height: 1,
                  color: const Color(0xFFF0F0F0),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      const Spacer(),
                      Container(
                        height: 30,
                        width: 1,
                        color: const Color(0xFFF0F0F0),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: SvgPicture.asset(
                            'assets/icons/keyboard_down.svg',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Column(
            children: [
              if (_attachmentList.isEmpty)
                Row(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: _pickFile,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/clip.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF636363),
                                  BlendMode.srcIn,
                                ),
                                width: 34,
                                height: 34,
                              ),
                              const Text(
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
                  duration: const Duration(milliseconds: 100),
                  alignment: AlignmentDirectional.topCenter,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            "첨부파일",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            _attachmentList.length.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ColorsInfo.newara,
                            ),
                          ),
                          const SizedBox(
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
                              colorFilter: const ColorFilter.mode(
                                Colors.red,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () => _pickFile(),
                            child: SvgPicture.asset(
                              'assets/icons/add.svg',
                              width: 34,
                              height: 34,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFED3A3A),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(
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
                                const SizedBox(
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                            Container(
                                              height: 44,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color(
                                                      0xFFF0F0F0), // #F0F0F0 색상
                                                  width: 1, // 테두리 두께 1픽셀
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15), // 반지름 15
                                              ),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/icons/pdf.svg',
                                                    width: 30,
                                                    height: 30,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                            Colors.black,
                                                            BlendMode.srcIn),
                                                  ),
                                                  const SizedBox(
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(
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
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xFFBBBBBB)),
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
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                              Color(0xFFBBBBBB),
                                                              BlendMode.srcIn),
                                                    ),
                                                  ),
                                                  const SizedBox(
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
              const SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  // TODO: 익명 선택 범위 화면 영역 확대(resolved)
                  // 자유 게시판인 경우 && 수정 게시물이 아닌 경우
                  if (_chosenBoardValue != null &&
                      _isEditingPost == false &&
                      _chosenBoardValue!.slug == 'talk')
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCheckboxes[0] = !_selectedCheckboxes[0]!;
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: _selectedCheckboxes[0]!
                                      ? ColorsInfo.newara
                                      : const Color(0xFFF0F0F0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                    'assets/icons/check.svg',
                                    width: 16,
                                    height: 16,
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn)),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                "익명",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: _selectedCheckboxes[0]!
                                      ? ColorsInfo.newara
                                      : const Color(0xFFBBBBBB),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    ),

                  //TODO: 터치 부분이 너무 작아서 불편함.
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        //성인 체크 박스
                        _selectedCheckboxes[1] = !_selectedCheckboxes[1]!;
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _selectedCheckboxes[1]!
                                ? ColorsInfo.newara
                                : const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/icons/check.svg',
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn), // #FFFFFF 색상
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "성인",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _selectedCheckboxes[1]!
                                ? ColorsInfo.newara
                                : const Color(0xFFBBBBBB),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        //정치 체크 박스
                        _selectedCheckboxes[2] = !_selectedCheckboxes[2]!;
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _selectedCheckboxes[2]!
                                ? ColorsInfo.newara
                                : const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/icons/check.svg',
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn), // #FFFFFF 색상
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "정치",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _selectedCheckboxes[2]!
                                ? ColorsInfo.newara
                                : const Color(0xFFBBBBBB),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),
                  GestureDetector(
                    child: const Text(
                      "이용약관",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFBBBBBB),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          );
        },
      );
    }

    Widget buildToolbar() {
      return quill.QuillToolbar.basic(
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
        ],
        // embedButtons: FlutterQuillEmbeds.buttons(),
      );
    }

    quill.DefaultStyles editorStyles() {
      TextStyle h1h2h3h4h5h6CommonStyle = const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontFamily: 'NotoSansKR',
        height: 1.15,
      );
      return quill.DefaultStyles(
        h1: quill.DefaultTextBlockStyle(
          h1h2h3h4h5h6CommonStyle.copyWith(
            fontSize: 32,
          ),
          // Vertical spacing around a text block.
          const quill.VerticalSpacing(2, 0),
          // Vertical spacing for individual lines within a text block.
          const quill.VerticalSpacing(0, 0),
          null,
        ),
        h2: quill.DefaultTextBlockStyle(
          h1h2h3h4h5h6CommonStyle.copyWith(
            fontSize: 28,
          ),
          const quill.VerticalSpacing(2, 0),
          const quill.VerticalSpacing(0, 0),
          null,
        ),
        h3: quill.DefaultTextBlockStyle(
          h1h2h3h4h5h6CommonStyle.copyWith(
            fontSize: 24,
          ),
          const quill.VerticalSpacing(2, 0),
          const quill.VerticalSpacing(0, 0),
          null,
        ),
        paragraph: quill.DefaultTextBlockStyle(
          const TextStyle(
            color: Color(0xFF4a4a4a),
            fontWeight: FontWeight.w500,
            fontFamily: 'NotoSansKR',
            height: 1.5,
            fontSize: 16,
          ),
          const quill.VerticalSpacing(2, 0),
          const quill.VerticalSpacing(0, 0),
          null,
        ),
        bold: const TextStyle(
            color: Color(0xff363636),
            fontFamily: 'NotoSansKR',
            fontWeight: FontWeight.w700),
        italic: const TextStyle(
          fontFamily: 'NotoSansKR',
          fontStyle: FontStyle.italic,
        ),
        underline: const TextStyle(
          fontFamily: 'NatoSansKR',
          decoration: TextDecoration.underline,
        ),
        code: quill.DefaultTextBlockStyle(
          const TextStyle(
            //  backgroundColor: Colors.grey,
            color: Color(0xFF4a4a4a),
            fontWeight: FontWeight.w400,
            fontFamily: 'NotoSansKR',
            height: 1.5,
            fontSize: 16,
          ),
          const quill.VerticalSpacing(2, 0),
          const quill.VerticalSpacing(0, 0),
          null,
        ),
        placeHolder: quill.DefaultTextBlockStyle(
          const TextStyle(
            color: Color(0xFFBBBBBB),
            fontWeight: FontWeight.w500,
            fontFamily: 'NotoSansKR',
            height: 1.5,
            fontSize: 16,
          ),
          const quill.VerticalSpacing(2, 0),
          const quill.VerticalSpacing(0, 0),
          null,
        ),

        //   small
      );
    }

    Widget buildEditor() {
      return quill.QuillEditor(
        focusNode: _editorFocusNode,
        controller: _quillController,
        placeholder: '내용을 입력해주세요.',
        embedBuilders: FlutterQuillEmbeds.builders(),
        readOnly: false, // The editor is editable

        scrollController: ScrollController(),
        padding: EdgeInsets.zero,
        scrollable: true,
        autoFocus: true,
        expands: false,
        customStyles: editorStyles(),
      );
    }

    return _isLoading
        ? const LoadingIndicator()
        : Scaffold(
            appBar: buildAppBar(),
            body: SafeArea(
              child: Column(
                children: [
                  buildMenubar(),
                  buildTitle(),
                  Container(
                    height: 1,
                    color: const Color(0xFFF0F0F0),
                  ),
                  buildToolbar(),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: buildEditor(),
                  )),
                  buildAttachmentShow()
                ],
              ),
            ),
          );
  }

  /// _attachmentList 의 첨부파일이 존재하는 파일인지 유효성 확인하는 함수
  void _checkAttachmentsValid() {
    // _attachmentList에서 원소를 직접 삭제하기
    for (int i = _attachmentList.length - 1; i >= 0; i--) {
      if (_attachmentList[i].isNewFile) {
        File file = File(_attachmentList[i].fileLocalPath!);
        if (!file.existsSync()) {
          _attachmentList.removeAt(i);
        }
      }
    }
  }

  quill.Delta _htmlToQuillDelta(String html) {
    debugPrint("1 : $html");
    // HTML을 마크다운으로 변환
    var markdown = html2md.convert(
      html,
      styleOptions: {
        'headingStyle': 'atx',
      },
    );
    debugPrint("2 : $markdown");

    // 마크다운을 Delta로 변환
    var deltaJson = markdownToQuill(markdown);
    debugPrint("3 : ${deltaJson!}");

    final mdDocument = md.Document(encodeHtml: false);

    final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);

    var deltaJson2 = mdToDelta.convert(markdown);
    debugPrint("4 : $deltaJson2");

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

      Dio dio = createDioWithConfig();
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
            } on DioException catch (e) {
              // Handle the DioError separately to handle only Dio related errors
              if (e.response != null) {
                // DioError contains response data
                print('Dio error!');
                print('STATUS: ${e.response?.statusCode}');
                print('DATA: ${e.response?.data}');
                print('HEADERS: ${e.response?.headers}');
              } else {
                // Error due to setting up or sending/receiving the request
                print('Error sending request!');
                print(e.message);
              }
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
        Response response;
        var data = {
          'title': titleValue,
          'content': contentValue,
          'attachments': attachmentIds,
          'is_content_sexual': _selectedCheckboxes[1],
          'is_content_social': _selectedCheckboxes[2],
          // TODO: 명명 규칙 다름
          'name_type': _selectedCheckboxes[0] == true ? 'ANONYMOUS' : 'REGULAR',
        };

        if (isUpdate) {
          response = await dio.put(
            '$newAraDefaultUrl/api/articles/$previousArticleId/',
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
        if (mounted) {
          Navigator.pop(context);
        }
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
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final String imageUrl = image.path;
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
          fileType: FileType.image,
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
          //TODO: 파일 타입 결정해서 FileType에 추가하기, svg파일도 추가하기.
          fileType: FileType.other,
          isNewFile: true,
          fileLocalPath: file.path,
        ));
      });
    }
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
      _specTopicList.add(_defaultTopicModelNone);
      for (TopicModel topic in value!.topics) {
        _specTopicList.add(topic);
      }
      _chosenTopicValue = _specTopicList[0];
      _chosenBoardValue = value;
    });
  }
}
