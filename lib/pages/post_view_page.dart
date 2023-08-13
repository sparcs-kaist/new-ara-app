import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/article_model.dart';
import 'package:new_ara_app/models/article_nested_comment_list_action_model.dart';
import 'package:new_ara_app/models/comment_nested_comment_list_action_model.dart';
import 'package:new_ara_app/models/attachment_model.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/utils/time_utils.dart';
import 'package:new_ara_app/utils/html_info.dart';
import 'package:new_ara_app/pages/user_view_page.dart';
import 'package:new_ara_app/pages/post_write_page.dart';
import 'package:new_ara_app/utils/post_view_utils.dart';


class PostViewPage extends StatefulWidget {
  final int articleID;
  const PostViewPage({super.key, required int id}) : articleID = id;

  @override
  State<PostViewPage> createState() => _PostViewPageState();
}

class _PostViewPageState extends State<PostViewPage> {
  late ArticleModel article;
  late bool isReportable, isValid, isModify, isNestedComment, isSending;
  late List<CommentNestedCommentListActionModel> commentList;

  String _commentContent = "";
  FocusNode textFocusNode = FocusNode();
  CommentNestedCommentListActionModel? targetComment; // 수정 or 대댓글이 달릴 댓글
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isValid = false;
    isModify = isNestedComment = false;
    isSending = false;
    commentList = [];
    UserProvider userProvider = context.read<UserProvider>();
    _fetchArticle(userProvider).then((value) {
      isReportable = value ? !article.is_mine : false;
      _setIsValid(value);
    });
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    _scrollController.dispose();
    _textEditingController.dispose();
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
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                onLongPressDown: (_) => FocusScope.of(context).unfocus(),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    // article 부분
                    Expanded(
                      child: RefreshIndicator(
                        color: ColorsInfo.newara,
                        onRefresh: () async {
                          _setIsValid(false);
                          _setIsValid(await _fetchArticle(userProvider));
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
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
                                onTap: article.name_type == 2 ? null : () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => UserViewPage(userID: article.created_by.id)),
                                  );
                                  _setIsValid(await _fetchArticle(userProvider));
                                },
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
                                    Visibility(
                                      visible: article.created_by.profile.nickname != "익명",
                                      child: SvgPicture.asset(
                                        'assets/icons/right_chevron.svg',
                                        color: Colors.black,
                                        width: 5,
                                        height: 9,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(thickness: 1,),
                              // (2023.08.09)첨부파일 리스트뷰 프로토타입. 추후 디자이너와 조율 예정
                              Visibility(
                                visible: article.attachments.isNotEmpty,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _buildAttachMenuButton(article.attachments.length),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
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
                                      bool res = await ArticleController(
                                        model: article,
                                        userProvider: userProvider,
                                      ).posVote();
                                      if (res) update();
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
                                      onTap: () {
                                        ArticleController(
                                          model: article,
                                          userProvider: userProvider,
                                        ).negVote().then((result) {
                                          if (result) update();
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
                                        onTap: () {
                                          ArticleController(
                                            model: article,
                                            userProvider: userProvider,
                                          ).scrap().then((result) {
                                            if (result) update();
                                          });
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
                                          await ArticleController(
                                            model: article,
                                            userProvider: userProvider,
                                          ).share();
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
                                  isReportable ? InkWell(
                                    onTap: () {
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
                                  ) : InkWell(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PostWritePage(articleBefore: article)
                                        )
                                      );
                                      bool result = await _fetchArticle(userProvider);
                                      if (result) update();
                                    },
                                    child: Container(
                                      width: 95,
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
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/modify.svg',
                                              width: 30,
                                              height: 30,
                                              color: Colors.black,
                                            ),
                                            const Text(
                                              '수정하기',
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
                              ListView.separated(
                                padding: const EdgeInsets.only(bottom: 15),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                controller: _scrollController,
                                itemCount: commentList.length,
                                itemBuilder: (BuildContext context, int idx) {
                                  CommentNestedCommentListActionModel
                                  curComment = commentList[idx];
                                  return Container(
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
                                            InkWell(
                                              onTap: curComment.name_type == 2 ? null : () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => UserViewPage(userID: curComment.created_by.id)),
                                                );
                                              },
                                              child: Row(
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
                                            ),
                                            SizedBox(
                                              width: 30,
                                              height: 25,
                                              child: Visibility(
                                                  visible: !(curComment.is_hidden),
                                                  child: (curComment.is_mine ==
                                                      true
                                                      ? _buildMyPopupMenuButton(
                                                      curComment.id,
                                                      userProvider, idx)
                                                      : _buildOthersPopupMenuButton(
                                                      curComment.id))
                                              ),
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
                                            '삭제된 댓글 입니다.',
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
                                                  onTap: () {
                                                    CommentController(
                                                      model: curComment,
                                                      userProvider: userProvider,
                                                    ).posVote().then((result) {
                                                      if (result) update();
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
                                                    CommentController(
                                                      model: curComment,
                                                      userProvider: userProvider,
                                                    ).negVote().then((result) {
                                                      if (result) update();
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
                                                Visibility(
                                                  visible: curComment.parent_comment == null,
                                                  child: InkWell(
                                                    onTap: () {
                                                      targetComment = curComment;
                                                      _setCommentMode(
                                                          true,
                                                          false);
                                                      textFocusNode.requestFocus();
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
                                                ),
                                              ],
                                            )
                                                : Visibility(
                                              visible: curComment.parent_comment == null,
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {},
                                                    child:
                                                    SvgPicture
                                                        .asset(
                                                      'assets/icons/arrow_uturn_left_1.svg',
                                                      width: 11,
                                                      height: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  InkWell(
                                                    onTap: () {
                                                      targetComment =
                                                          curComment;
                                                      debugPrint(
                                                          "parentCommentID: ${targetComment!.id}");
                                                      _setCommentMode(
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
                                              ),
                                            )),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int idx) => const Divider(),
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
                      Visibility(
                        visible: isNestedComment,
                        child: Column(
                          children: [
                            Text(
                              '${(targetComment == null ? false : targetComment!.is_mine) ? '\'나\'에게' : "'${targetComment?.created_by.profile.nickname}'님께"} 답글을 작성하는 중',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5)
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isModify,
                        child: Column(
                          children: [
                            Text(
                              '나의 댓글 "${targetComment?.content}" 수정 중',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5)
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          // Close button
                          Visibility(
                            visible: (isModify || isNestedComment),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _textEditingController.text = "";
                                    targetComment = null;
                                    debugPrint("Parent Comment null");
                                    _setCommentMode(false, false);
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/close.svg',
                                    width: 30,
                                    height: 30,
                                    color: ColorsInfo.newara,
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
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
                          AbsorbPointer(
                            absorbing: isSending,
                            child: InkWell(
                              onTap: () async {
                                setIsSending(true);
                                bool sendRes = await _sendComment(userProvider);
                                if (sendRes) {
                                  _setIsValid(await _fetchArticle(userProvider));
                                  debugPrint("Send Complete!");
                                } else {
                                  debugPrint("Send Comment Failed");
                                }
                                setIsSending(false);
                              },
                              child: SvgPicture.asset(
                                'assets/icons/send.svg',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                    SizedBox(
                      height: 15,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          );
  }

  PopupMenuButton<int> _buildAttachMenuButton(int fileNum) {
    return PopupMenuButton<int>(
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
      splashRadius: 5,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Color.fromRGBO(217, 217, 217, 1), width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      padding: const EdgeInsets.all(2.0),
      child: Text(
        '첨부파일 모아보기 $fileNum',
      ),
      itemBuilder: (BuildContext context) {
        List<AttachmentModel> files = article.attachments;
        return List.generate(
            files.length,
            (idx) => PopupMenuItem<int>(
              value: idx,
              child: Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0x00FFFFFF),
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Text(
                  Uri.parse(article.attachments[idx].file).path.substring(7),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        );
      },
      onSelected: (int result) async {
        AttachmentModel model = article.attachments[result];
        UserProvider userProvider = context.read<UserProvider>();
        bool res = await FileController(model: model, userProvider: userProvider).download();
        debugPrint(res ? "파일 다운로드 성공" : "파일 다운로드 실패");
      }
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
            _setCommentMode(false, true);
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
                                _delComment(id, userProvider).then((res) async {
                                  if (res == false) {
                                    return;
                                  } else {
                                    bool res = await _fetchArticle(userProvider);
                                    _setIsValid(res);
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
            onChanged: (value) => _commentContent = value,
            onSaved: (value) =>  _commentContent = value ?? '',
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

  void setIsSending(bool value) {
    if (!mounted) return;
    setState(() => isSending = value);
  }

  void update() {
    if (!mounted) return;
    setState(() {});
  }

  // isValid: article 에 적절한 정보가 있는지 나타냄
  void _setIsValid(bool value) {
    if (!mounted) return;
    setState(() => isValid = value);
  }

  // 둘 다 false 면 일반적인 댓글
  void _setCommentMode(bool isNestedVal, bool isModifyVal) {
    if (!mounted) return;
    setState(() {
      isNestedComment = isNestedVal;
      isModify = isModifyVal;
    });
  }

  Future<bool> _delComment(int id, UserProvider userProvider) async {
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
  Future<bool> _fetchArticle(UserProvider userProvider) async {
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

  Future<bool> _sendComment(UserProvider userProvider) async {
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
      _setCommentMode(false, false);
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
      _setCommentMode(false, false);
    }
    return true;
  }
}