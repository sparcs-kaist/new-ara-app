import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/article_model.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/utils/time_utils.dart';
import 'package:new_ara_app/models/article_nested_comment_list_action_model.dart';
import 'package:new_ara_app/models/comment_nested_comment_list_action_model.dart';
import 'package:new_ara_app/models/scrap_create_action_model.dart';

class PostViewPage extends StatefulWidget {
  final int articleID;
  const PostViewPage({super.key, required int id}) : articleID = id;

  @override
  State<PostViewPage> createState() => _PostViewPageState();
}

class _PostViewPageState extends State<PostViewPage> {
  late ArticleModel article;
  bool isValid = false;

  final _formKey = GlobalKey<FormState>();
  String _commentContent = "";

  final ScrollController _scrollController = ScrollController();

  List<CommentNestedCommentListActionModel> commentList = [];
  int parentCommentID = 0;
  late FocusNode textFocusNode;
  bool isModify = false, isNestedComment = false;
  int? modifyTarget;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = context.read<UserProvider>();
    textFocusNode = FocusNode();
    fetchArticle(userProvider);
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    super.dispose();
  }

  void setIsValid(bool value) {
    setState(() => isValid = value);
  }

  void setIsNestedComment(bool value) {
    setState(() => isNestedComment = value);
  }

  void setIsModify(bool value) {
    setState(() => isModify = value);
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

  void fetchArticle(UserProvider userProvider) async {
    dynamic articleJson, commentJson;

    articleJson = await userProvider.getApiRes("articles/${widget.articleID}");
    if (articleJson == null) {
      debugPrint("\nArticleJson is null\n");
      return;
    }
    try {
      article = ArticleModel.fromJson(articleJson);
    } catch (error) {
      debugPrint(
          "ArticleModel.fromJson failed at articleID = ${widget.articleID}: $error");
      setIsValid(false);
      return;
    }

    commentList.clear();
    for (ArticleNestedCommentListAction anc in article.comments) {
      commentJson = await userProvider.getApiRes("comments/${anc.id}");
      if (commentJson == null) continue;
      late CommentNestedCommentListActionModel tmpModel;
      try {
        tmpModel = CommentNestedCommentListActionModel.fromJson(
            commentJson); // ArticleNestedCommentListActionModel은 CommentNestedCommentListActino의 모든 필드를 가지고 있음
        commentList.add(tmpModel);
      } catch (error) {
        debugPrint(
            "CommentNestedCommentListActionModel.fromJson failed at ID ${anc.id}: $error");
        continue;
      }
      for (CommentNestedCommentListActionModel cnc in anc.comments) {
        try {
          commentList.add(cnc);
        } catch (error) {
          debugPrint(
              "\nCommentNestedCommentListActionModel.fromJson failed at ID ${cnc.id}: $error\n");
          continue;
        }
      }
    }
    setIsValid(true);
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
                    Expanded(
                      child: RefreshIndicator(
                        color: ColorsInfo.newara,
                        onRefresh: () async {
                          setIsValid(false);
                          fetchArticle(userProvider);
                        },
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height,
                            ),
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
                                            color: Color.fromRGBO(
                                                177, 177, 177, 1),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '조회 ${article.hit_count}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromRGBO(
                                                177, 177, 177, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // 좋아요, 싫어요, 댓글 갯수 표시 Row
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/like.svg',
                                          width: 13,
                                          height: 15,
                                          color: article.my_vote == true
                                              ? ColorsInfo.newara
                                              : const Color.fromRGBO(
                                                  100, 100, 100, 1),
                                        ),
                                        const SizedBox(width: 3),
                                        Text('${article.positive_vote_count}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: article.my_vote == true
                                                    ? ColorsInfo.newara
                                                    : const Color.fromRGBO(
                                                        100, 100, 100, 1))),
                                        const SizedBox(width: 10),
                                        SvgPicture.asset(
                                          'assets/icons/dislike.svg',
                                          width: 13,
                                          height: 15,
                                          color: article.my_vote == false
                                              ? const Color.fromRGBO(
                                                  83, 141, 209, 1)
                                              : const Color.fromRGBO(
                                                  100, 100, 100, 1),
                                        ),
                                        const SizedBox(width: 3),
                                        Text('${article.negative_vote_count}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: article.my_vote == false
                                                  ? const Color.fromRGBO(
                                                      83, 141, 209, 1)
                                                  : const Color.fromRGBO(
                                                      100, 100, 100, 1),
                                            )),
                                        const SizedBox(width: 10),
                                        SvgPicture.asset(
                                          'assets/icons/comment.svg',
                                          width: 13,
                                          height: 15,
                                          color: const Color.fromRGBO(
                                              99, 99, 99, 1),
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
                                InkWell(
                                  onTap: () {},
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
                                const Divider(
                                  thickness: 1,
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                    minHeight: 200,
                                    maxHeight: 1000,
                                  ),
                                  child: WebViewWidgetClass(
                                      content: article.content ??
                                          '<p>내용이 존재하지 않습니다</p>'),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        if (article.is_mine) {
                                          debugPrint(
                                              "자신의 글에는 좋아요, 싫어요를 할 수 없음");
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
                                        setState(() {
                                          article.positive_vote_count =
                                              article.positive_vote_count! +
                                                  (article.my_vote == true
                                                      ? -1
                                                      : 1);
                                          article.negative_vote_count =
                                              article.negative_vote_count! +
                                                  (article.my_vote == false
                                                      ? -1
                                                      : 0);
                                          article.my_vote =
                                              (article.my_vote == true)
                                                  ? null
                                                  : true;
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icons/like.svg',
                                        width: 30,
                                        height: 30,
                                        color: article.my_vote == true
                                            ? ColorsInfo.newara
                                            : const Color.fromRGBO(
                                                100, 100, 100, 1),
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Text('${article.positive_vote_count}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: article.my_vote == true
                                              ? ColorsInfo.newara
                                              : const Color.fromRGBO(
                                                  100, 100, 100, 1),
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
                                      child: SvgPicture.asset(
                                        'assets/icons/dislike.svg',
                                        width: 30,
                                        height: 30,
                                        color: article.my_vote == false
                                            ? const Color.fromRGBO(
                                                83, 141, 209, 1)
                                            : const Color.fromRGBO(
                                                100, 100, 100, 1),
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Text('${article.negative_vote_count}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: article.my_vote == false
                                              ? const Color.fromRGBO(
                                                  83, 141, 209, 1)
                                              : const Color.fromRGBO(
                                                  100, 100, 100, 1),
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
                                              setState(() {
                                                article.my_scrap = null;
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: 90,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: article.my_scrap == null
                                                  ? Colors.white
                                                  : ColorsInfo.newara,
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
                                                    'assets/icons/bookmark-circle-fill.svg',
                                                    width: 20,
                                                    height: 20,
                                                    color: article.my_scrap ==
                                                            null
                                                        ? const Color.fromRGBO(
                                                            100, 100, 100, 1)
                                                        : Colors.white,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    '담아두기',
                                                    style: TextStyle(
                                                      color: article.my_scrap ==
                                                              null
                                                          ? Colors.black
                                                          : Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        InkWell(
                                          onTap: () {},
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //신고버튼 Row
                                    article.is_mine == true
                                        ? Container()
                                        : InkWell(
                                            onTap: () {},
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
                                                      color:
                                                          const Color.fromRGBO(
                                                              100, 100, 100, 1),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      '신고',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: _scrollController,
                                    itemCount: commentList.length,
                                    itemBuilder:
                                        (BuildContext context, int idx) {
                                      CommentNestedCommentListActionModel
                                          curComment = commentList[idx];
                                      return Container(
                                        margin: EdgeInsets.only(
                                            left: (curComment.parent_comment ==
                                                    null
                                                ? 0
                                                : 30)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                            curComment
                                                                .created_by
                                                                .profile
                                                                .picture
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
                                                          style:
                                                              const TextStyle(
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
                                                      getTime(curComment
                                                          .created_at),
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
                                                          : _buildOthersPopupMenuButton()),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 30, right: 0),
                                              child: curComment.is_hidden ==
                                                      false
                                                  ? Text(
                                                      curComment.content
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Color.fromRGBO(
                                                            51, 51, 51, 1),
                                                      ),
                                                    )
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
                                                child:
                                                    curComment.is_hidden ==
                                                            false
                                                        ? Row(
                                                            children: [
                                                              InkWell(
                                                                onTap:
                                                                    () async {
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
                                                                            .postApiRes("comments/${curComment.id}/vote_positive/");
                                                                    if (postRes
                                                                            .statusCode !=
                                                                        200) {
                                                                      debugPrint(
                                                                          "POST /api/comments/${curComment.id}/vote_positive/ ${postRes.statusCode}");
                                                                      return;
                                                                    }
                                                                  }
                                                                  setState(() {
                                                                    curComment
                                                                        .positive_vote_count = (curComment.positive_vote_count ??
                                                                            0) +
                                                                        (curComment.my_vote ==
                                                                                true
                                                                            ? -1
                                                                            : 1);
                                                                    curComment
                                                                        .negative_vote_count = (curComment.negative_vote_count ??
                                                                            0) +
                                                                        (curComment.my_vote ==
                                                                                false
                                                                            ? -1
                                                                            : 0);
                                                                    curComment
                                                                        .my_vote = (curComment.my_vote ==
                                                                            true)
                                                                        ? null
                                                                        : true;
                                                                  });
                                                                },
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/icons/like.svg',
                                                                  width: 25,
                                                                  height: 25,
                                                                  color: curComment
                                                                              .my_vote ==
                                                                          true
                                                                      ? ColorsInfo
                                                                          .newara
                                                                      : const Color
                                                                              .fromRGBO(
                                                                          100,
                                                                          100,
                                                                          100,
                                                                          1),
                                                                ),
                                                              ),
                                                              Text(
                                                                curComment
                                                                    .positive_vote_count
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: curComment
                                                                              .my_vote ==
                                                                          true
                                                                      ? ColorsInfo
                                                                          .newara
                                                                      : const Color
                                                                              .fromRGBO(
                                                                          100,
                                                                          100,
                                                                          100,
                                                                          1),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 6),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
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
                                                                            .postApiRes("comments/${curComment.id}/vote_negative/");
                                                                    if (postRes
                                                                            .statusCode !=
                                                                        200) {
                                                                      debugPrint(
                                                                          "POST /api/comments/${curComment.id}/vote_negative/ ${postRes.statusCode}");
                                                                      return;
                                                                    }
                                                                  }
                                                                  setState(() {
                                                                    curComment
                                                                        .positive_vote_count = (curComment.positive_vote_count ??
                                                                            0) +
                                                                        (curComment.my_vote ==
                                                                                true
                                                                            ? -1
                                                                            : 0);
                                                                    curComment
                                                                        .negative_vote_count = (curComment.negative_vote_count ??
                                                                            0) +
                                                                        (curComment.my_vote ==
                                                                                false
                                                                            ? -1
                                                                            : 1);
                                                                    curComment
                                                                        .my_vote = (curComment.my_vote ==
                                                                            false)
                                                                        ? null
                                                                        : false;
                                                                  });
                                                                },
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/icons/dislike.svg',
                                                                  width: 25,
                                                                  height: 25,
                                                                  color: curComment
                                                                              .my_vote ==
                                                                          false
                                                                      ? const Color
                                                                              .fromRGBO(
                                                                          83,
                                                                          141,
                                                                          209,
                                                                          1)
                                                                      : const Color
                                                                              .fromRGBO(
                                                                          100,
                                                                          100,
                                                                          100,
                                                                          1),
                                                                ),
                                                              ),
                                                              Text(
                                                                curComment
                                                                    .negative_vote_count
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: curComment
                                                                              .my_vote ==
                                                                          false
                                                                      ? const Color
                                                                              .fromRGBO(
                                                                          83,
                                                                          141,
                                                                          209,
                                                                          1)
                                                                      : const Color
                                                                              .fromRGBO(
                                                                          100,
                                                                          100,
                                                                          100,
                                                                          1),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 6),
                                                              curComment.parent_comment !=
                                                                      null
                                                                  ? Container()
                                                                  : InkWell(
                                                                      onTap:
                                                                          () {},
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/icons/arrow_uturn_left_1.svg',
                                                                        width:
                                                                            11,
                                                                        height:
                                                                            12,
                                                                      ),
                                                                    ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              curComment.parent_comment !=
                                                                      null
                                                                  ? Container()
                                                                  : InkWell(
                                                                      onTap:
                                                                          () {
                                                                        parentCommentID =
                                                                            curComment.id;
                                                                        textFocusNode
                                                                            .requestFocus();
                                                                        debugPrint(
                                                                            "parentCommentID: $parentCommentID");
                                                                        setIsNestedComment(
                                                                            true);
                                                                        setIsModify(
                                                                            false);
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        '답글 쓰기',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight:
                                                                              FontWeight.w500,
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
                                                                      onTap:
                                                                          () {},
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/icons/arrow_uturn_left_1.svg',
                                                                        width:
                                                                            11,
                                                                        height:
                                                                            12,
                                                                      ),
                                                                    ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              curComment.parent_comment !=
                                                                      null
                                                                  ? Container()
                                                                  : InkWell(
                                                                      onTap:
                                                                          () {
                                                                        parentCommentID =
                                                                            curComment.id;
                                                                        textFocusNode
                                                                            .requestFocus();
                                                                        debugPrint(
                                                                            "parentCommentID: $parentCommentID");
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        '답글 쓰기',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight:
                                                                              FontWeight.w500,
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
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
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
                        const SizedBox(width: 10),
                        (!isModify && !isNestedComment)
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  _textEditingController.text = "";
                                  setIsNestedComment(false);
                                  parentCommentID = 0;
                                  debugPrint("parentCommentID: 0");
                                  setIsModify(false);
                                  modifyTarget = null;
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
                            : const SizedBox(width: 10),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState == null) return;
                            if (!(_formKey.currentState!.validate())) return;
                            _formKey.currentState!.save();
                            _formKey.currentState!.reset();
                            debugPrint("작성된 댓글: $_commentContent");
                            debugPrint(
                                "payload 정보: name_type=${article.name_type}, parent_comment=$parentCommentID");
                            if (!isModify) {
                              dynamic defaultPayload = {
                                "content": _commentContent,
                                "name_type": article.name_type,
                                "attachment": null,
                              };
                              defaultPayload.addAll(parentCommentID != 0
                                  ? {"parent_comment": parentCommentID}
                                  : {"parent_article": article.id});
                              var postRes = await userProvider.postApiRes(
                                'comments/',
                                payload: defaultPayload,
                              );
                              if (postRes.statusCode != 201) {
                                // 나중에 사용자용 안내 위젯 등 추가하면 좋을 듯
                                debugPrint("POST /api/comments failed");
                                return;
                              }
                              setIsNestedComment(false);
                              fetchArticle(userProvider);
                            } else {
                              dynamic defaultPayload = {
                                "content": _commentContent,
                                "is_mine": true,
                                "name_type": article.name_type,
                              };
                              var patchRes = await userProvider.patchApiRes(
                                "comments/$modifyTarget/",
                                payload: defaultPayload,
                              );
                              if (patchRes.statusCode != 200) {
                                debugPrint(
                                    "PATCH /api/comments/$modifyTarget/ failed");
                                return;
                              }
                              _textEditingController.text = "";
                              setIsModify(false);
                              fetchArticle(userProvider);
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
                    const SizedBox(height: 10),
                  ]),
                ),
              ),
            ),
          );
  }

  PopupMenuButton<String> _buildMyPopupMenuButton(
      int id, UserProvider userProvider, int idx) {
    return PopupMenuButton<String>(
      splashRadius: 5,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
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
            setIsModify(true);
            setIsNestedComment(false);
            modifyTarget = id;
            break;
          case 'Delete':
            bool res = await delComment(id, userProvider);
            if (res == false) {
              break;
            }
            fetchArticle(userProvider);
            break;
        }
      },
    );
  }

  PopupMenuButton<String> _buildOthersPopupMenuButton() {
    return PopupMenuButton<String>(
      splashRadius: 5,
      shape: const RoundedRectangleBorder(
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
                color: const Color.fromRGBO(51, 51, 51, 1),
              ),
              const SizedBox(width: 10),
              const Text(
                '신고',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(51, 51, 51, 1)),
              ),
            ],
          ),
        ),
      ],
      onSelected: (String result) {
        switch (result) {
          case 'Chat':
            break;
          case 'Report':
            break;
        }
      },
    );
  }

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
}

class WebViewWidgetClass extends StatefulWidget {
  final String content;
  const WebViewWidgetClass({super.key, required this.content});

  @override
  State<WebViewWidgetClass> createState() => _WebViewWidgetClassState();
}

class _WebViewWidgetClassState extends State<WebViewWidgetClass> {
  WebViewController _webViewController = WebViewController();
  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          debugPrint('WebView is loading (progress: $progress)');
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {
          debugPrint(
              'code: ${error.errorCode}\ndescription: ${error.description}\nerrorType: ${error.errorType}\nisForMainFrame: ${error.isForMainFrame}');
        },
      ));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _webViewController..loadHtmlString('''
                              <html>
                                  <head>
                                      <meta charset="utf-8">
                                      <meta property="og:locale" content="ko-KR">
                                      <meta property="og:locale:alternate" content="en-US">
                                      <meta name="theme-color" content="#ed3a3a">
                                      <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons|Material+Icons+Outlined">
                                      <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&amp;display=swap">
                                      <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Raleway:wght@300;400;500;700&amp;display=swap">
                                      <style>
                                          *:focus {
                                              outline: none;
                                          }
                                          body {
                                              max-height: 1000px;
                                          }
                                          img {
                                              max-width: 100%;
                                              max-height: 800px;
                                          }
                                      </style>
                                      <meta name="viewport" content="width=${MediaQuery.of(context).size.width - 40}">
                                      <style type="text/css">.ProseMirror {
  position: relative;
}

.ProseMirror {
  word-wrap: break-word;
  white-space: pre-wrap;
  -webkit-font-variant-ligatures: none;
  font-variant-ligatures: none;
}

.ProseMirror pre {
  white-space: pre-wrap;
}

.ProseMirror-gapcursor {
  display: none;
  pointer-events: none;
  position: absolute;
}

.ProseMirror-gapcursor:after {
  content: "";
  display: block;
  position: absolute;
  top: -2px;
  width: 20px;
  border-top: 1px solid black;
  animation: ProseMirror-cursor-blink 1.1s steps(2, start) infinite;
}

@keyframes ProseMirror-cursor-blink {
  to {
    visibility: hidden;
  }
}

.ProseMirror-hideselection *::selection {
  background: transparent;
}

.ProseMirror-hideselection *::-moz-selection {
  background: transparent;
}

.ProseMirror-hideselection * {
  caret-color: transparent;
}

.ProseMirror-focused .ProseMirror-gapcursor {
  display: block;
}
                                      </style>
                                      <script>
                                          window.dataLayer = window.dataLayer || [];function gtag(){dataLayer.push(arguments);}gtag('js', new Date());gtag('config', 'G-S6SZ22QX6X');
                                      </script>
                                  </head>
                                  <body>
                                      <div class="content">
                                          <div class="content">
                                              <div class="editor-content">
                                                  ${widget.content}
                                              </div>
                                          </div>
                                      </div>
                                  </body>
                              </html>
                              '''),
    );
  }
}
