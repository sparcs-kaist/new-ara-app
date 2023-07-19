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

class PostViewPage extends StatefulWidget {
  final int articleID;
  const PostViewPage({super.key, required int id}) : articleID = id;

  @override
  State<PostViewPage> createState() => _PostViewPageState();
}

class _PostViewPageState extends State<PostViewPage> {
  WebViewController _webViewController = WebViewController();
  late ArticleModel article;
  bool isValid = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textEditingController = TextEditingController();
  String _commentContent = "";

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
    UserProvider userProvider = context.read<UserProvider>();
    fetchArticle(userProvider);
  }

  void fetchArticle(UserProvider userProvider) {
    userProvider.getApiRes("articles/${widget.articleID}").then((dynamic json) {
      if (json != null) {
        try {
          setState(() {
            article = ArticleModel.fromJson(json);
            isValid = true;
          });
        } catch (error) {
          debugPrint(
              "ArticleModel.fromJson failed at articleID = ${widget.articleID}: $error");
          setState(() => isValid = false);
        }
      }
    });
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
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 날짜, 조회수 표시 Row
                              Row(
                                children: [
                                  Text(
                                    getTime(article.created_at),
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
                                          color:
                                              Color.fromRGBO(83, 141, 209, 1))),
                                  const SizedBox(width: 10),
                                  SvgPicture.asset(
                                    'assets/icons/comment.svg',
                                    width: 13,
                                    height: 15,
                                    color: const Color.fromRGBO(99, 99, 99, 1),
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
                          const SizedBox(height: 10),
                          Row(
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
                          const Divider(
                            thickness: 1,
                          ),
                          // 본문 내용이 들어가는 부분 (이미지 처리 등 어떻게 할지 논의해보기)
                          Container(
                            height: 800,
                            width: MediaQuery.of(context).size.width - 40,
                            alignment: Alignment.center,
                            child: WebViewWidget(
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
                                          ${article.content}
                                      </div>
                                  </body>
                              </html>
                              '''),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
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
                                  color: const Color.fromRGBO(83, 141, 209, 1),
                                ),
                              ),
                              const SizedBox(width: 3),
                              Text('${article.negative_vote_count}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(83, 141, 209, 1))),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
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
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(230, 230, 230, 1),
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
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(230, 230, 230, 1),
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
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(230, 230, 230, 1),
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
                          // 리스트뷰 구현해서 댓글 추가하면 됨
                        ],
                      ),
                    )),
                    SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 7, right: 15, bottom: 7),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(235, 235, 235, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _buildForm(),
                            ),
                          ),
                          InkWell(
                            child: SvgPicture.asset(
                              'assets/icons/send.svg',
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
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
        margin: const EdgeInsets.only(left: 8),
        child: TextFormField(
          controller: _textEditingController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '댓글을 입력해주세요',
          ),
          validator: (value) {
            if (value == null) return null;
            if (value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
          onTapOutside: (value) {
            FocusScope.of(context).unfocus();
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).unfocus();
            _commentContent = value.toString();
            _textEditingController.clear();
            debugPrint("작성된 댓글: $_commentContent");
          },
          onSaved: (value) {
            _commentContent = value.toString();
          },
        ),
      ),
    );
  }
}