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

  ScrollController _scrollController = ScrollController();

  List<CommentNestedCommentListActionModel> commentList = [];

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = context.read<UserProvider>();
    fetchArticle(userProvider);
  }

  void setIsValid(bool value) {
    setState(() => isValid = value);
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
              "\nCommentModel.fromJson failed at ID ${cnc.id}: $error\n");
          continue;
        }
      }
    }
    setIsValid(true);
  }

  @override
  Widget build(BuildContext context) {
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
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    Expanded(
                        child: ListView.separated(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: 7 + commentList.length,
                      itemBuilder: (BuildContext context, int idx) {
                        if (idx == 0) {
                          return Text(
                            article.title.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        } else if (idx == 1) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // 날짜, 조회수 표시 Row
                                Row(
                                  children: [
                                    Text(
                                      getTime(article.created_at).toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(177, 177, 177, 1),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '조회 ${article.hit_count}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(177, 177, 177, 1),
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
                                      color: ColorsInfo.newara,
                                    ),
                                    const SizedBox(width: 3),
                                    Text('${article.positive_vote_count}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: ColorsInfo.newara)),
                                    const SizedBox(width: 10),
                                    SvgPicture.asset(
                                      'assets/icons/dislike.svg',
                                      width: 13,
                                      height: 15,
                                      color:
                                          const Color.fromRGBO(83, 141, 209, 1),
                                    ),
                                    const SizedBox(width: 3),
                                    Text('${article.negative_vote_count}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromRGBO(
                                                83, 141, 209, 1))),
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
                                            color:
                                                Color.fromRGBO(99, 99, 99, 1))),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else if (idx == 2) {
                          return SizedBox(
                            height: 40,
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
                                        maxWidth:
                                            MediaQuery.of(context).size.width -
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
                                IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/icons/right_chevron.svg',
                                    color: Colors.black,
                                    width: 5,
                                    height: 9,
                                  ),
                                  onPressed: () {}, // 추후 구현 예정
                                ),
                              ],
                            ),
                          );
                        } else if (idx == 3) {
                          return SizedBox(
                              height: 500,
                              child: WebViewWidgetClass(
                                  content: article.content.toString()));
                        } else if (idx == 4) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                    'assets/icons/like.svg',
                                    width: 30,
                                    height: 30,
                                    color: ColorsInfo.newara,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Text('${article.positive_vote_count}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: ColorsInfo.newara)),
                                const SizedBox(width: 20),
                                InkWell(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                    'assets/icons/dislike.svg',
                                    width: 30,
                                    height: 30,
                                    color:
                                        const Color.fromRGBO(83, 141, 209, 1),
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Text('${article.negative_vote_count}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Color.fromRGBO(83, 141, 209, 1))),
                              ],
                            ),
                          );
                        } else if (idx == 5) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // 담아두기,공유 버튼 Row
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width: 90,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Color.fromRGBO(
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
                                                color: const Color.fromRGBO(
                                                    100, 100, 100, 1),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '담아두기',
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
                                            color: Color.fromRGBO(
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
                                              Text(
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
                                //신고버튼 Row
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width: 90,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Color.fromRGBO(
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
                                              Text(
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
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else if (idx == 6) {
                          return Text(
                            '${commentList.length}개의 댓글',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        } else if (7 <= idx && idx < 7 + commentList.length) {
                          CommentNestedCommentListActionModel curComment =
                              commentList[idx - 7];
                          return Container(
                            margin: EdgeInsets.only(
                                left: (curComment.parent_comment == null
                                    ? 0
                                    : 30)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(100)),
                                            child: Image.network(curComment
                                                .created_by.profile.picture
                                                .toString()),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  200,
                                            ),
                                            child: Text(
                                              curComment
                                                  .created_by.profile.nickname
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                        const SizedBox(width: 7),
                                        Text(
                                          getTime(curComment.created_at),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromRGBO(
                                                  51, 51, 51, 1)),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        'assets/icons/three_dots_1.svg',
                                        width: 25,
                                        height: 25,
                                        color: const Color.fromRGBO(
                                            177, 177, 177, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 30, right: 0),
                                  child: curComment.is_hidden == false
                                      ? Text(
                                          curComment.content.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Color.fromRGBO(51, 51, 51, 1),
                                          ),
                                        )
                                      : const Text(
                                          '삭제된 댓글입니다.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                    margin: const EdgeInsets.only(left: 30),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: SvgPicture.asset(
                                            'assets/icons/like.svg',
                                            width: 25,
                                            height: 25,
                                            color: const Color.fromRGBO(
                                                237, 58, 58, 1),
                                          ),
                                        ),
                                        Text(
                                          curComment.positive_vote_count
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  237, 58, 58, 1)),
                                        ),
                                        const SizedBox(width: 6),
                                        InkWell(
                                          onTap: () {},
                                          child: SvgPicture.asset(
                                            'assets/icons/dislike.svg',
                                            width: 25,
                                            height: 25,
                                            color: const Color.fromRGBO(
                                                83, 141, 209, 1),
                                          ),
                                        ),
                                        Text(
                                          curComment.negative_vote_count
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  83, 141, 209, 1)),
                                        ),
                                        const SizedBox(width: 6),
                                        curComment.parent_comment != null
                                            ? Container()
                                            : InkWell(
                                                onTap: () {},
                                                child: SvgPicture.asset(
                                                  'assets/icons/arrow_uturn_left_1.svg',
                                                  width: 11,
                                                  height: 12,
                                                ),
                                              ),
                                        const SizedBox(width: 5),
                                        curComment.parent_comment != null
                                            ? Container()
                                            : InkWell(
                                                onTap: () {},
                                                child: const Text(
                                                  '답글 쓰기',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    )),
                              ],
                            ),
                          );
                        }
                      },
                      separatorBuilder: (BuildContext context, int idx) {
                        if (idx <= 2) {
                          return const SizedBox(height: 3);
                        } else if (idx <= 5) {
                          return const SizedBox(height: 7);
                        } else {
                          return const Divider();
                        }
                      },
                    )),
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
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState == null) return;
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                            }
                            debugPrint("작성된 댓글: $_commentContent");
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

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: TextFormField(
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '댓글을 입력해주세요',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the comment';
              }
              return null;
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
  const WebViewWidgetClass({super.key, required String content})
      : content = content;

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
                                      <style>
                                        
                                      </style>
                                      <meta charset="UTF-8">
                                      <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                  </head>
                                  <body>
                                      <div class="container">
                                          ${widget.content}
                                      </div>
                                  </body>
                              </html>
                              '''),
    );
  }
}
