import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/article_model.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/utils/time_utils.dart';
import 'package:new_ara_app/models/article_nested_comment_list_action_model.dart';
import 'package:new_ara_app/models/comment_nested_comment_list_action_model.dart';
import 'package:new_ara_app/models/scrap_create_action_model.dart';
import 'package:new_ara_app/utils/html_info.dart';
import 'package:new_ara_app/models/attachment_model.dart';

class PostViewPage extends StatefulWidget {
  final int articleID;
  const PostViewPage({super.key, required int id}) : articleID = id;

  @override
  State<PostViewPage> createState() => _PostViewPageState();
}

class _PostViewPageState extends State<PostViewPage> {
  late ArticleModel article;
  late bool isReportable;

  bool isValid = false;
  FocusNode textFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String _commentContent = "";

  final ScrollController _scrollController =
      ScrollController(); // 페이지 전체에 대한 컨트롤러

  List<CommentNestedCommentListActionModel> commentList = [];

  CommentNestedCommentListActionModel? targetComment; // 수정 or 대댓글이 달릴 댓글
  bool isModify = false, isNestedComment = false; // 수정 or 대댓글 or 그냥 댓글
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = context.read<UserProvider>();
    fetchArticle(userProvider).then((value) {
      isReportable = value ? !article.is_mine : false;
      setIsValid(value);
    });
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();

    return !isValid
        ? const LoadingIndicator()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                color: ColorsInfo.newara,
                icon: SvgPicture.asset('assets/icons/left_chevron.svg',
                    color: ColorsInfo.newara, width: 10.7, height: 18.99),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    // article 부분
                    Expanded(
                      child: RefreshIndicator(
                        color: ColorsInfo.newara,
                        onRefresh: () async {
                          setIsValid(false);
                          bool res = await fetchArticle(userProvider);
                          setIsValid(res);
                        },
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 5),
                              // 날짜, 조회수, 좋아요, 싫어요, 댓글 수를 표시하는 Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // 날짜, 조회수 표시 Row
                                  Row(
                                    children: [
                                      Text(
                                        getTime(article.created_at),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromRGBO(177, 177, 177, 1),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '조회 ${article.hit_count}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromRGBO(177, 177, 177, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // 좋아요, 싫어요, 댓글 갯수 표시 Row
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        article.my_vote == true
                                            ? 'assets/icons/like_filled.svg'
                                            : 'assets/icons/like.svg',
                                        width: 13,
                                        height: 15,
                                        color: article.my_vote == false
                                            ? ColorsInfo.noneVote
                                            : ColorsInfo.newara,
                                      ),
                                      const SizedBox(width: 3),
                                      Text('${article.positive_vote_count}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: article.my_vote == false
                                                  ? ColorsInfo.noneVote
                                                  : ColorsInfo.newara)),
                                      const SizedBox(width: 10),
                                      SvgPicture.asset(
                                        article.my_vote == false
                                            ? 'assets/icons/dislike_filled.svg'
                                            : 'assets/icons/dislike.svg',
                                        width: 13,
                                        height: 15,
                                        color: article.my_vote == true
                                            ? ColorsInfo.noneVote
                                            : ColorsInfo.negVote,
                                      ),
                                      const SizedBox(width: 3),
                                      Text('${article.negative_vote_count}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: article.my_vote == true
                                                ? ColorsInfo.noneVote
                                                : ColorsInfo.negVote,
                                          )),
                                      const SizedBox(width: 10),
                                      SvgPicture.asset(
                                        'assets/icons/comment.svg',
                                        width: 13,
                                        height: 15,
                                        color:
                                            const Color.fromRGBO(99, 99, 99, 1),
                                      ),
                                      const SizedBox(width: 3),
                                      Text('${article.comment_count}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  99, 99, 99, 1))),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // 유저 정보 (프로필 이미지, 닉네임)
                              InkWell(
                                onTap:
                                    () {}, // (2023.08.01) 유저 정보 확인 기능은 추후 구현 예정
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100)),
                                        child: Image.network(article
                                            .created_by.profile.picture
                                            .toString()),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                150),
                                        child: Text(
                                          article.created_by.profile.nickname
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    const SizedBox(width: 10),
                                    SvgPicture.asset(
                                      'assets/icons/right_chevron.svg',
                                      color: Colors.black,
                                      width: 5,
                                      height: 9,
                                    ),
                                  ],
                                ),
                              ),
                              // (2023.08.09)첨부파일 리스트뷰 프로토타입. 추후 디자이너와 조율 예정
                              SizedBox(
                                height: 150,
                                child: ListView.separated(
                                  itemCount: article.attachments.length,
                                  itemBuilder: (BuildContext context, int idx) {
                                    AttachmentModel curFile = article.attachments[idx];
                                    String initFileName = Uri.parse(article.attachments[idx].file).path.substring(7);
                                    return InkWell(
                                      onTap: () async {
                                        late String targetDir;
                                        try {
                                          targetDir = await getDownloadPath();
                                        } catch (error) {
                                          debugPrint("getDownloadPath failed: $error");
                                          return;
                                        }
                                        String fileName = addTimestampToFileName(initFileName);
                                        bool res = await downloadFile(userProvider, curFile.file, "$targetDir${Platform.pathSeparator}$fileName");
                                        debugPrint(res ? "$fileName 파일 저장 성공" : "$fileName 파일 저장 실패");
                                      },
                                      child: Text(
                                        initFileName,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    );
                                  },
                                  separatorBuilder: (BuildContext context, int idx) => const Divider(thickness: 1),
                                )
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              InArticleWebView(
                                content: getContentHtml(
                                    article.content ?? "내용이 존재하지 않습니다."),
                                initialHeight: 150,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (article.is_mine) {
                                        debugPrint("자신의 글에는 좋아요, 싫어요를 할 수 없음");
                                        return;
                                      }
                                      if (article.my_vote == true) {
                                        var cancelRes =
                                            await userProvider.postApiRes(
                                          "articles/${article.id}/vote_cancel/",
                                        );
                                        if (cancelRes.statusCode != 200) {
                                          debugPrint(
                                              "POST /api/articles/${article.id}/vote_cancel ${cancelRes.statusCode}");
                                          return;
                                        }
                                      } else {
                                        var postRes =
                                            await userProvider.postApiRes(
                                          "articles/${article.id}/vote_positive/",
                                        );
                                        if (postRes.statusCode != 200) {
                                          debugPrint(
                                              "POST /api/articles/${article.id}/vote_positive ${postRes.statusCode}");
                                          return;
                                        }
                                      }
                                      if (!mounted) return;
                                      setState(() {
                                        article.positive_vote_count = article
                                                .positive_vote_count! +
                                            (article.my_vote == true ? -1 : 1);
                                        article.negative_vote_count = article
                                                .negative_vote_count! +
                                            (article.my_vote == false ? -1 : 0);
                                        article.my_vote =
                                            (article.my_vote == true)
                                                ? null
                                                : true;
                                      });
                                    },
                                    child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: SvgPicture.asset(
                                        article.my_vote == true
                                            ? 'assets/icons/like_filled.svg'
                                            : 'assets/icons/like.svg',
                                        color: article.my_vote == false
                                            ? ColorsInfo.noneVote
                                            : ColorsInfo.newara,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  Text('${article.positive_vote_count}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: article.my_vote == false
                                            ? ColorsInfo.noneVote
                                            : ColorsInfo.posVote,
                                      )),
                                  const SizedBox(width: 20),
                                  InkWell(
                                      onTap: () async {
                                        if (article.is_mine == true) {
                                          debugPrint(
                                              "자신의 글에는 좋아요, 싫어요를 할 수 없음");
                                          return;
                                        }
                                        if (article.my_vote == false) {
                                          var cancelRes =
                                              await userProvider.postApiRes(
                                            "articles/${article.id}/vote_cancel/",
                                          );
                                          if (cancelRes.statusCode != 200) {
                                            debugPrint(
                                                "POST /api/articles/${article.id}/vote_cancel ${cancelRes.statusCode}");
                                            return;
                                          }
                                        } else {
                                          var postRes =
                                              await userProvider.postApiRes(
                                            "articles/${article.id}/vote_negative/",
                                          );
                                          if (postRes.statusCode != 200) {
                                            debugPrint(
                                                "POST /api/articles/${article.id}/vote_negative/ ${postRes.statusCode}");
                                            return;
                                          }
                                        }
                                        if (!mounted) return;
                                        setState(() {
                                          article.positive_vote_count =
                                              article.positive_vote_count! +
                                                  (article.my_vote == true
                                                      ? -1
                                                      : 0);
                                          article.negative_vote_count =
                                              article.negative_vote_count! +
                                                  (article.my_vote == false
                                                      ? -1
                                                      : 1);
                                          article.my_vote =
                                              (article.my_vote == false)
                                                  ? null
                                                  : false;
                                        });
                                      },
                                      child: SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: SvgPicture.asset(
                                          article.my_vote == false
                                              ? 'assets/icons/dislike_filled.svg'
                                              : 'assets/icons/dislike.svg',
                                          color: article.my_vote == true
                                              ? ColorsInfo.noneVote
                                              : ColorsInfo.negVote,
                                        ),
                                      )),
                                  const SizedBox(width: 3),
                                  Text('${article.negative_vote_count}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: article.my_vote == true
                                            ? ColorsInfo.noneVote
                                            : ColorsInfo.negVote,
                                      )),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // 담아두기,공유 버튼 Row
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (article.my_scrap == null) {
                                            var postRes =
                                                await userProvider.postApiRes(
                                              "scraps/",
                                              payload: {
                                                "parent_article": article.id,
                                              },
                                            );
                                            if (postRes.statusCode != 201) {
                                              return;
                                            }
                                            if (!mounted) return;
                                            setState(() {
                                              article.my_scrap =
                                                  ScrapCreateActionModel
                                                      .fromJson(postRes.data);
                                            });
                                          } else {
                                            var delRes =
                                                await userProvider.delApiRes(
                                                    "scraps/${article.my_scrap!.id}/");
                                            if (delRes.statusCode != 204) {
                                              return;
                                            }
                                            if (!mounted) return;
                                            setState(() {
                                              article.my_scrap = null;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: article.my_scrap == null
                                                  ? const Color.fromRGBO(
                                                      230, 230, 230, 1)
                                                  : ColorsInfo.newara,
                                            ),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(width: 2),
                                                SvgPicture.asset(
                                                  'assets/icons/bookmark-circle-fill.svg',
                                                  width: 20,
                                                  height: 20,
                                                  color: article.my_scrap ==
                                                          null
                                                      ? const Color.fromRGBO(
                                                          100, 100, 100, 1)
                                                      : ColorsInfo.newara,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  article.my_scrap == null
                                                      ? '담아두기'
                                                      : '담아둔 글',
                                                  style: TextStyle(
                                                    color:
                                                        article.my_scrap == null
                                                            ? Colors.black
                                                            : ColorsInfo.newara,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      InkWell(
                                        onTap: () async {
                                          String url =
                                              "$newAraDefaultUrl/post/${article.id}";
                                          await Clipboard.setData(
                                              ClipboardData(text: url));
                                          debugPrint("클립보드에 복사됨: $url");
                                        },
                                        child: Container(
                                          width: 90,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  230, 230, 230, 1),
                                            ),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(width: 2),
                                                SvgPicture.asset(
                                                  'assets/icons/share.svg',
                                                  width: 20,
                                                  height: 20,
                                                  color: const Color.fromRGBO(
                                                      100, 100, 100, 1),
                                                ),
                                                const SizedBox(width: 10),
                                                const Text(
                                                  '공유',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // 신고버튼 Row
                                  Opacity(
                                    opacity: isReportable ? 1 : 0.3,
                                    child: InkWell(
                                      onTap: () {
                                        if (!isReportable) return;
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ReportDialogWidget(
                                                  articleID: article.id);
                                            });
                                      },
                                      child: Container(
                                        width: 90,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: const Color.fromRGBO(
                                                230, 230, 230, 1),
                                          ),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(width: 2),
                                              SvgPicture.asset(
                                                'assets/icons/exclamationmark-bubble-fill.svg',
                                                width: 20,
                                                height: 20,
                                                color: const Color.fromRGBO(
                                                    100, 100, 100, 1),
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                '신고',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: Text(
                                  '${article.comment_count}개의 댓글',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                constraints: const BoxConstraints(
                                  minHeight: 200,
                                ),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: _scrollController,
                                  itemCount: commentList.length,
                                  itemBuilder: (BuildContext context, int idx) {
                                    CommentNestedCommentListActionModel
                                        curComment = commentList[idx];
                                    return Container(
                                      //height: 400,
                                      margin: EdgeInsets.only(
                                          left:
                                              (curComment.parent_comment == null
                                                  ? 0
                                                  : 30)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 25,
                                                    height: 25,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  100)),
                                                      child: Image.network(
                                                          curComment.created_by
                                                              .profile.picture
                                                              .toString()),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Container(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            200,
                                                      ),
                                                      child: Text(
                                                        curComment.created_by
                                                            .profile.nickname
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                  const SizedBox(width: 7),
                                                  Text(
                                                    getTime(
                                                        curComment.created_at),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Color.fromRGBO(
                                                            51, 51, 51, 1)),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 30,
                                                height: 25,
                                                child: curComment.is_hidden ==
                                                        true
                                                    ? Container()
                                                    : (curComment.is_mine ==
                                                            true
                                                        ? _buildMyPopupMenuButton(
                                                            curComment.id,
                                                            userProvider,
                                                            idx)
                                                        : _buildOthersPopupMenuButton(
                                                            curComment.id)),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 30, right: 0),
                                            child: curComment.is_hidden == false
                                                ? _buildCommentContent(
                                                    curComment.content ?? "")
                                                : const Text(
                                                    '삭제된 댓글입니다.',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(height: 5),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 30),
                                              child: curComment.is_hidden ==
                                                      false
                                                  ? Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {
                                                            if (curComment
                                                                    .is_mine ==
                                                                true) {
                                                              return;
                                                            }
                                                            if (curComment
                                                                    .my_vote ==
                                                                true) {
                                                              var postRes =
                                                                  await userProvider
                                                                      .postApiRes(
                                                                "comments/${curComment.id}/vote_cancel/",
                                                              );
                                                              if (postRes
                                                                      .statusCode !=
                                                                  200) {
                                                                debugPrint(
                                                                    "POST /api/comments/${curComment.id}/vote_cancel/ ${postRes.statusCode}");
                                                                return;
                                                              }
                                                            } else {
                                                              var postRes =
                                                                  await userProvider
                                                                      .postApiRes(
                                                                          "comments/${curComment.id}/vote_positive/");
                                                              if (postRes
                                                                      .statusCode !=
                                                                  200) {
                                                                debugPrint(
                                                                    "POST /api/comments/${curComment.id}/vote_positive/ ${postRes.statusCode}");
                                                                return;
                                                              }
                                                            }
                                                            if (!mounted)
                                                              return;
                                                            setState(() {
                                                              curComment
                                                                  .positive_vote_count = (curComment
                                                                          .positive_vote_count ??
                                                                      0) +
                                                                  (curComment.my_vote ==
                                                                          true
                                                                      ? -1
                                                                      : 1);
                                                              curComment
                                                                  .negative_vote_count = (curComment
                                                                          .negative_vote_count ??
                                                                      0) +
                                                                  (curComment.my_vote ==
                                                                          false
                                                                      ? -1
                                                                      : 0);
                                                              curComment
                                                                      .my_vote =
                                                                  (curComment.my_vote ==
                                                                          true)
                                                                      ? null
                                                                      : true;
                                                            });
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            curComment.my_vote ==
                                                                    true
                                                                ? 'assets/icons/like_filled.svg'
                                                                : 'assets/icons/like.svg',
                                                            width: 17,
                                                            height: 17,
                                                            color:
                                                                curComment.my_vote ==
                                                                        false
                                                                    ? ColorsInfo
                                                                        .noneVote
                                                                    : ColorsInfo
                                                                        .newara,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 3),
                                                        Text(
                                                          curComment
                                                              .positive_vote_count
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                curComment.my_vote ==
                                                                        false
                                                                    ? ColorsInfo
                                                                        .noneVote
                                                                    : ColorsInfo
                                                                        .posVote,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 6),
                                                        InkWell(
                                                          onTap: () async {
                                                            if (curComment
                                                                    .is_mine ==
                                                                true) {
                                                              return;
                                                            }
                                                            if (curComment
                                                                    .my_vote ==
                                                                false) {
                                                              var postRes =
                                                                  await userProvider
                                                                      .postApiRes(
                                                                "comments/${curComment.id}/vote_cancel/",
                                                              );
                                                              if (postRes
                                                                      .statusCode !=
                                                                  200) {
                                                                debugPrint(
                                                                    "POST /api/comments/${curComment.id}/vote_cancel/ ${postRes.statusCode}");
                                                                return;
                                                              }
                                                            } else {
                                                              var postRes =
                                                                  await userProvider
                                                                      .postApiRes(
                                                                          "comments/${curComment.id}/vote_negative/");
                                                              if (postRes
                                                                      .statusCode !=
                                                                  200) {
                                                                debugPrint(
                                                                    "POST /api/comments/${curComment.id}/vote_negative/ ${postRes.statusCode}");
                                                                return;
                                                              }
                                                            }
                                                            if (!mounted)
                                                              return;
                                                            setState(() {
                                                              curComment
                                                                  .positive_vote_count = (curComment
                                                                          .positive_vote_count ??
                                                                      0) +
                                                                  (curComment.my_vote ==
                                                                          true
                                                                      ? -1
                                                                      : 0);
                                                              curComment
                                                                  .negative_vote_count = (curComment
                                                                          .negative_vote_count ??
                                                                      0) +
                                                                  (curComment.my_vote ==
                                                                          false
                                                                      ? -1
                                                                      : 1);
                                                              curComment
                                                                      .my_vote =
                                                                  (curComment.my_vote ==
                                                                          false)
                                                                      ? null
                                                                      : false;
                                                            });
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            curComment.my_vote ==
                                                                    false
                                                                ? 'assets/icons/dislike_filled.svg'
                                                                : 'assets/icons/dislike.svg',
                                                            width: 17,
                                                            height: 17,
                                                            color: curComment
                                                                        .my_vote ==
                                                                    true
                                                                ? ColorsInfo
                                                                    .noneVote
                                                                : ColorsInfo
                                                                    .negVote,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 3),
                                                        Text(
                                                          curComment
                                                              .negative_vote_count
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: curComment
                                                                        .my_vote ==
                                                                    true
                                                                ? ColorsInfo
                                                                    .noneVote
                                                                : ColorsInfo
                                                                    .negVote,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 6),
                                                        curComment.parent_comment !=
                                                                null
                                                            ? Container()
                                                            : InkWell(
                                                                onTap: () {},
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/icons/arrow_uturn_left_1.svg',
                                                                  width: 11,
                                                                  height: 12,
                                                                ),
                                                              ),
                                                        const SizedBox(
                                                            width: 5),
                                                        curComment.parent_comment !=
                                                                null
                                                            ? Container()
                                                            : InkWell(
                                                                onTap: () {
                                                                  targetComment =
                                                                      curComment;
                                                                  debugPrint(
                                                                      "parentCommentID: ${targetComment!.id}");
                                                                  setCommentMode(
                                                                      true,
                                                                      false);
                                                                  textFocusNode
                                                                      .requestFocus();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  '답글 쓰기',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        curComment.parent_comment !=
                                                                null
                                                            ? Container()
                                                            : InkWell(
                                                                onTap: () {},
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/icons/arrow_uturn_left_1.svg',
                                                                  width: 11,
                                                                  height: 12,
                                                                ),
                                                              ),
                                                        const SizedBox(
                                                            width: 5),
                                                        curComment.parent_comment !=
                                                                null
                                                            ? Container()
                                                            : InkWell(
                                                                onTap: () {
                                                                  targetComment =
                                                                      curComment;
                                                                  debugPrint(
                                                                      "parentCommentID: ${targetComment!.id}");
                                                                  setCommentMode(
                                                                      true,
                                                                      false);
                                                                  textFocusNode
                                                                      .requestFocus();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  '답글 쓰기',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                      ],
                                                    )),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int idx) {
                                    return const Divider();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // 댓글 입력 부분
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isNestedComment
                            ? Text(
                                '${targetComment!.is_mine ? '\'나\'에게' : "'${targetComment!.created_by.profile.nickname}'님께"} 답글을 작성하는 중',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : Container(),
                        isNestedComment
                            ? const SizedBox(height: 5)
                            : Container(),
                        isModify
                            ? Text(
                                '나의 댓글 "${targetComment!.content}" 수정 중',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : Container(),
                        isModify ? const SizedBox(height: 5) : Container(),
                        Row(
                          children: [
                            // Close button
                            (!isModify && !isNestedComment)
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      _textEditingController.text = "";
                                      targetComment = null;
                                      debugPrint("Parent Comment null");
                                      setCommentMode(false, false);
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icons/close.svg',
                                      width: 30,
                                      height: 30,
                                      color: ColorsInfo.newara,
                                    ),
                                  ),
                            (!isModify && !isNestedComment)
                                ? Container()
                                : const SizedBox(width: 5),
                            // TextFormField
                            Expanded(
                              child: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 45,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(235, 235, 235, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: _buildForm(),
                              ),
                            ),
                            const SizedBox(width: 5),
                            // send button
                            InkWell(
                              onTap: () async {
                                bool sendRes = await sendComment(userProvider);
                                if (sendRes) {
                                  setIsValid(await fetchArticle(userProvider));
                                } else {
                                  debugPrint("Send Comment Failed");
                                }
                              },
                              child: SvgPicture.asset(
                                'assets/icons/send.svg',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ]),
                ),
              ),
            ),
          );
  }

  // 자신의 댓글
  PopupMenuButton<String> _buildMyPopupMenuButton(
      int id, UserProvider userProvider, int idx) {
    return PopupMenuButton<String>(
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
      splashRadius: 5,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Color.fromRGBO(217, 217, 217, 1), width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      padding: const EdgeInsets.all(2.0),
      icon: SvgPicture.asset(
        'assets/icons/three_dots_1.svg',
        width: 25,
        height: 25,
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'Modify',
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/modify.svg',
                width: 25,
                height: 25,
                color: const Color.fromRGBO(51, 51, 51, 1),
              ),
              const SizedBox(width: 10),
              const Text(
                '수정',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(51, 51, 51, 1)),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Delete',
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/delete.svg',
                width: 25,
                height: 25,
                color: ColorsInfo.newara,
              ),
              const SizedBox(width: 10),
              const Text(
                '삭제',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ColorsInfo.newara,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (String result) async {
        switch (result) {
          case 'Modify':
            _textEditingController.text = commentList[idx].content.toString();
            textFocusNode.requestFocus();
            setCommentMode(false, true);
            targetComment = commentList[idx];
            break;
          case 'Delete':
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    width: 350,
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/close_check.svg',
                          width: 55,
                          height: 55,
                          color: ColorsInfo.newara,
                        ),
                        const Text(
                          '정말로 이 댓글을 삭제하시겠습니까?',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, // 테두리 색상을 빨간색으로 지정
                                    width: 1, // 테두리의 두께를 2로 지정
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                width: 60,
                                height: 40,
                                child: const Center(
                                  child: Text(
                                    '취소',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                delComment(id, userProvider).then((res) async {
                                  if (res == false) {
                                    return;
                                  } else {
                                    bool res = await fetchArticle(userProvider);
                                    setIsValid(res);
                                  }
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: ColorsInfo.newara,
                                ),
                                width: 60,
                                height: 40,
                                child: const Center(
                                  child: Text(
                                    '확인',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
            break;
        }
      },
    );
  }

  // 다른 유저의 댓글
  PopupMenuButton<String> _buildOthersPopupMenuButton(int commentID) {
    return PopupMenuButton<String>(
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
      splashRadius: 5,
      shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color.fromRGBO(217, 217, 217, 1), width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      padding: const EdgeInsets.all(2.0),
      icon: SvgPicture.asset(
        'assets/icons/three_dots_1.svg',
        width: 25,
        height: 25,
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'Chat',
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/chat.svg',
                width: 20,
                height: 20,
                color: const Color.fromRGBO(51, 51, 51, 1),
              ),
              const SizedBox(width: 10),
              const Text(
                '채팅',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(51, 51, 51, 1)),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Report',
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/exclamationmark-bubble-fill.svg',
                width: 20,
                height: 20,
                color: ColorsInfo.newara,
              ),
              const SizedBox(width: 10),
              const Text(
                '신고',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ColorsInfo.newara,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (String result) {
        switch (result) {
          case 'Chat':
            // (2023.08.01) 채팅 기능은 추후에 구현 예정이기 때문에 아직은 Placeholder
            break;
          case 'Report':
            showDialog(
                context: context,
                builder: (context) {
                  return ReportDialogWidget(commentID: commentID);
                });
            break;
        }
      },
    );
  }

  // 댓글 입력 Form
  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: TextFormField(
            controller: _textEditingController,
            focusNode: textFocusNode,
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '댓글을 입력해주세요',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '댓글이 작성되지 않았습니다!';
              }
              return null;
            },
            onChanged: (value) {
              _commentContent = value;
            },
            onSaved: (value) {
              _commentContent = value ?? '';
            },
          )),
    );
  }

  // curComment.content 를 Text() or InArticleWebView() 로 렌더링할 지 결정
  Widget _buildCommentContent(String content) {
    RegExp pattern = RegExp(r'<[^>]+>');
    // HTML 태그가 존재하는지 검사 (완벽한 방법은 아님)
    if (!content.contains(pattern)) {
      return Text(
        content,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      );
    }
    return InArticleWebView(
      content: getContentHtml(content),
      initialHeight: 10,
    );
  }

  // 파일 다운로드 경로 찾기
  Future<String> getDownloadPath() async {
    late Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = (await getExternalStorageDirectory())!;  // Android 에서는 존재가 보장됨
      }
    }
    return directory.path;
  }

  String addTimestampToFileName(String fileName) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    int dotIndex = fileName.lastIndexOf('.');
    if (dotIndex != -1) {
      String nameWithoutExtension = fileName.substring(0, dotIndex);
      String extension = fileName.substring(dotIndex + 1);
      return '$nameWithoutExtension-$timestamp.$extension';
    }
    return '$fileName-$timestamp';
  }

  // 파일 다운로드 하기
  Future<bool> downloadFile(UserProvider userProvider, String uri, String totalPath) async {
    try {
      await userProvider.myDio().download(uri, totalPath);
    } catch (error) {
      return false;
    }
    return true;
  }

  // isValid: article 에 적절한 정보가 있는지 나타냄
  void setIsValid(bool value) {
    if (!mounted) return;
    setState(() => isValid = value);
  }

  // 둘 다 false 면 일반적인 댓글
  void setCommentMode(bool isNestedVal, bool isModifyVal) {
    if (!mounted) return;
    setState(() {
      isNestedComment = isNestedVal;
      isModify = isModifyVal;
    });
  }

  Future<bool> delComment(int id, UserProvider userProvider) async {
    late dynamic delRes;
    try {
      delRes = await userProvider.delApiRes("comments/$id/");
    } catch (error) {
      debugPrint("DELETE /api/comments/$id failed: $error");
      return false;
    }
    if (delRes.statusCode != 204) {
      debugPrint("DELETE /api/comments/$id ${delRes.statusCode}");
      return false;
    }
    return true;
  }

  // Article 모델에 필요한 정보
  Future<bool> fetchArticle(UserProvider userProvider) async {
    dynamic articleJson, commentJson;

    articleJson = await userProvider.getApiRes("articles/${widget.articleID}");
    if (articleJson == null) {
      debugPrint("\nArticleJson is null\n");
      return false;
    }
    try {
      article = ArticleModel.fromJson(articleJson);
    } catch (error) {
      debugPrint(
          "ArticleModel.fromJson failed at articleID = ${widget.articleID}: $error");
      return false;
    }

    commentList.clear();
    for (ArticleNestedCommentListAction anc in article.comments) {
      commentJson = await userProvider.getApiRes("comments/${anc.id}");
      if (commentJson == null) continue;
      late CommentNestedCommentListActionModel tmpModel;

      // 댓글을 추가하는 과정
      try {
        // ArticleNestedCommentListActionModel 은 CommentNestedCommentListAction 의 모든 필드를 가지고 있음
        // 따라서 원래 댓글은 ArticleNestedCommentListActionModel 에 저장되고,
        // 대댓글을 CommentNestedCommentListActionModel 에 저장되지만 댓글도 CommentNestedCommentListActionModel 에 저장하여 더 편하게 함.
        tmpModel = CommentNestedCommentListActionModel.fromJson(commentJson);
        commentList.add(tmpModel);
      } catch (error) {
        debugPrint(
            "CommentNestedCommentListActionModel.fromJson failed at ID ${anc.id}: $error");
        return false;
      }

      // 대댓글을 추가하는 과정
      for (CommentNestedCommentListActionModel cnc in anc.comments) {
        try {
          commentList.add(cnc);
        } catch (error) {
          debugPrint(
              "CommentNestedCommentListActionModel.fromJson failed at ID ${cnc.id}: $error\n");
          return false;
        }
      }
    }
    return true;
  }

  Future<bool> sendComment(UserProvider userProvider) async {
    if (_formKey.currentState == null || !(_formKey.currentState!.validate())) {
      return false;
    }
    _formKey.currentState!.save();
    if (!isModify) {
      dynamic defaultPayload = {
        "content": _commentContent,
        "name_type": article.name_type,
        "attachment": null,
      };
      defaultPayload.addAll(targetComment != null
          ? {"parent_comment": targetComment!.id}
          : {"parent_article": article.id});
      var postRes = await userProvider.postApiRes(
        'comments/',
        payload: defaultPayload,
      );
      if (postRes.statusCode != 201) {
        // 나중에 사용자용 알림 기능 추가해야 함
        debugPrint("POST /api/comments failed");
        return false;
      }
      targetComment = null;
      _textEditingController.text = "";
      setCommentMode(false, false);
    } else {
      dynamic defaultPayload = {
        "content": _commentContent,
        "is_mine": true,
        "name_type": article.name_type,
      };
      var patchRes = await userProvider.patchApiRes(
        "comments/${targetComment!.id}/",
        payload: defaultPayload,
      );
      if (patchRes.statusCode != 200) {
        debugPrint("PATCH /api/comments/${targetComment!.id}/ failed");
        return false;
      }
      targetComment = null;
      _textEditingController.text = "";
      setCommentMode(false, false);
    }
    return true;
  }
}

// 신고 기능 Dialog
class ReportDialogWidget extends StatefulWidget {
  final int? articleID, commentID;
  const ReportDialogWidget({super.key, this.articleID, this.commentID});

  @override
  State<ReportDialogWidget> createState() => _ReportDialogWidgetState();
}

class _ReportDialogWidgetState extends State<ReportDialogWidget> {
  List<String> reportContents = [
    "hate_speech",
    "unauthorized_sales_articles",
    "spam",
    "fake_information",
    "defamation",
    "other"
  ];
  List<String> reportContentKor = [
    "혐오 발언",
    "허가되지 않은 판매글",
    "스팸",
    "거짓 정보",
    "명예훼손",
    "기타"
  ];
  late List<bool> isChosen;

  @override
  void initState() {
    super.initState();
    isChosen = [false, false, false, false, false, false];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        width: 380,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/close_check.svg",
              width: 45,
              height: 45,
              color: ColorsInfo.newara,
            ),
            const SizedBox(height: 5),
            Text(
              '${widget.articleID == null ? '댓글' : '게시글'} 신고 사유를 알려주세요.',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _buildReportButton(0),
            const SizedBox(height: 10),
            _buildReportButton(1),
            const SizedBox(height: 10),
            _buildReportButton(2),
            const SizedBox(height: 10),
            _buildReportButton(3),
            const SizedBox(height: 10),
            _buildReportButton(4),
            const SizedBox(height: 10),
            _buildReportButton(5),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // 테두리 색상을 빨간색으로 지정
                        width: 1, // 테두리의 두께를 2로 지정
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    width: 60,
                    height: 40,
                    child: const Center(
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    postReport().then((res) {
                      debugPrint("신고가 ${res ? '성공' : '실패'}하였습니다.");
                      if (res) Navigator.pop(context);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: ColorsInfo.newara.withOpacity((isChosen[0] ||
                              isChosen[1] ||
                              isChosen[2] ||
                              isChosen[3] ||
                              isChosen[4] ||
                              isChosen[5])
                          ? 1
                          : 0.5),
                    ),
                    width: 100,
                    height: 40,
                    child: const Center(
                      child: Text(
                        '신고하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> postReport() async {
    if (!isChosen[0] &&
        !isChosen[1] &&
        !isChosen[2] &&
        !isChosen[3] &&
        !isChosen[4] &&
        !isChosen[5]) {
      // 나중에 알림 해주기
      return false;
    }
    String reportContent = "";
    for (int i = 0; i < 6; i++) {
      if (!isChosen[i]) continue;
      if (reportContent != "") reportContent += ", ";
      reportContent += reportContents[i];
    }
    debugPrint("reportContent: $reportContent");
    Map<String, dynamic> defaultPayload = {
      "content": reportContent,
      "type": "others",
    };
    defaultPayload.addAll(widget.articleID == null
        ? {"parent_comment": widget.commentID ?? 0}
        : {"parent_article": widget.articleID ?? 0});
    UserProvider userProvider = context.read<UserProvider>();
    try {
      await userProvider.postApiRes(
        "reports/",
        payload: defaultPayload,
      );
    } catch (error) {
      debugPrint("postReport() failed with error: $error");
      return false;
    }

    return true;
  }

  // 각각의 신고항목에 대한 button
  InkWell _buildReportButton(int idx) {
    return InkWell(
      onTap: () {
        if (!mounted) return;
        setState(() => isChosen[idx] = !isChosen[idx]);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: isChosen[idx]
              ? ColorsInfo.newara
              : const Color.fromRGBO(220, 220, 220, 1),
        ),
        width: 180,
        height: 40,
        child: Center(
          child: Text(
            reportContentKor[idx],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isChosen[idx] ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

// PostViewPage 내에 삽입되는 WebViewWidget
// article.content or curComment.content 렌더링을 위한 WebViewWidget
// WebViewWidget 과의 차이점은 JS를 이용한 자동 높이 조정
class InArticleWebView extends StatefulWidget {
  final String content;
  final double initialHeight;
  const InArticleWebView({
    super.key,
    required this.content,
    required this.initialHeight,
  });

  @override
  State<InArticleWebView> createState() => _InArticleWebViewState();
}

class _InArticleWebViewState extends State<InArticleWebView> {
  WebViewController _webViewController = WebViewController();
  late double webViewHeight;
  late bool isFitted;

  void setWebViewHeight(value) {
    setState(() => webViewHeight = value);
  }

  Future<void> launchInBrowser(String url) async {
    final Uri targetUrl = Uri.parse(url);
    if (!await canLaunchUrl(targetUrl)) {
      debugPrint("$url을 열 수 없습니다.");
      return;
    }
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<double> getPageHeight() async {
    final String pageHeightStr =
        (await _webViewController.runJavaScriptReturningResult('''
            function getPageHeight() {
              return Math.max(
                document.body.scrollHeight || 0,
                document.documentElement.scrollHeight || 0,
                document.body.offsetHeight || 0,
                document.documentElement.offsetHeight || 0,
                document.body.clientHeight || 0,
                document.documentElement.clientHeight || 0
              ).toString();
            }
            getPageHeight();
          ''')).toString();
    debugPrint(
        "******************\npageHeight: $pageHeightStr \n******************");
    double pageHeight =
        double.parse(pageHeightStr.substring(1, pageHeightStr.length - 1));

    return pageHeight;
  }

  Future<void> setPageHeight() async {
    getPageHeight().then((height) {
      if (!mounted) return;
      setState(() => webViewHeight = height);
    });
  }

  @override
  void initState() {
    super.initState();
    isFitted = false;
    webViewHeight = widget.initialHeight;
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) async {
          Uri uri = Uri.parse(request.url);
          if (uri.scheme == "https" || uri.scheme == "http") {
            await launchInBrowser(request.url);
          } else {
            // mailto, sms, tel 등의 scheme 은 아직 지원하지 않음 (2023.07.31)
            // 추후 PostViewPage 전체적으로 완성되면 기능 추가할 예정
            debugPrint("Denied Scheme: ${uri.scheme}");
          }
          return NavigationDecision.prevent;
        },
        onProgress: (int progress) {
          debugPrint('WebView is loading (progress: $progress)');
        },
        onPageFinished: (String url) async {
          if (isFitted) return;
          await setPageHeight();
          isFitted = true;
        },
        onWebResourceError: (WebResourceError error) async {
          debugPrint(
              'code: ${error.errorCode}\ndescription: ${error.description}\nerrorType: ${error.errorType}\nisForMainFrame: ${error.isForMainFrame}');
        },
      ))
      ..loadHtmlString(widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: webViewHeight,
      child: WebViewWidget(
        controller: _webViewController,
      ),
    );
  }
}
