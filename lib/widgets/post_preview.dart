import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/translations/locale_keys.g.dart';

import 'package:new_ara_app/models/article_list_action_model.dart';
import 'package:new_ara_app/utils/time_utils.dart';
import 'package:new_ara_app/providers/blocked_provider.dart';
import 'package:provider/provider.dart';

class PostPreview extends StatefulWidget {
  final ArticleListActionModel model;
  const PostPreview({super.key, required this.model});

  @override
  State<PostPreview> createState() => _PostPreviewState();
}

class _PostPreviewState extends State<PostPreview> {
  @override
  Widget build(BuildContext context) {
    BlockedProvider blockedProvider = context.watch<BlockedProvider>();

    String time = getTime(widget.model.created_at.toString(), context.locale);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.model.parent_topic != null)
                Text(
                  context.locale == const Locale('ko')
                      ? "[${widget.model.parent_topic!.ko_name}] "
                      : "[${widget.model.parent_topic!.en_name}] ",
                  style: const TextStyle(
                    color: Color(0xFFED3A3A),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                ),
              Flexible(
                child: Text(
                  // TODO: 아래 코드는 iOS 심사 통과를 위한 임시 방편. 익명 차단이 BE에서 구현되면 제거해야함 (2023.02.29)
                  (isAnonymousIOS(widget.model) &&
                          blockedProvider.blockedAnonymousPostIDs
                              .contains(widget.model.created_by.id))
                      ? LocaleKeys.postPreview_blockedUsersPost.tr()
                      : getTitle(widget.model.title, widget.model.is_hidden,
                          widget.model.why_hidden, context.locale),
                  style: TextStyle(
                    // TODO: 아래 코드는 iOS 심사 통과를 위한 임시 방편. 익명 차단이 BE에서 구현되면 제거해야함 (2023.02.29)
                    color: (widget.model.is_hidden ||
                            (isAnonymousIOS(widget.model) &&
                                blockedProvider.blockedAnonymousPostIDs
                                    .contains(widget.model.created_by.id)))
                        ? const Color(0xFFBBBBBB)
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              widget.model.attachment_type.toString() == "BOTH"
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/image.svg',
                          colorFilter: const ColorFilter.mode(
                              Colors.grey, BlendMode.srcIn),
                        ),
                        SvgPicture.asset(
                          'assets/icons/clip.svg',
                          colorFilter: const ColorFilter.mode(
                              Colors.grey, BlendMode.srcIn),
                        ),
                      ],
                    )
                  : widget.model.attachment_type.toString() == "IMAGE"
                      ? SvgPicture.asset(
                          'assets/icons/image.svg',
                          colorFilter: const ColorFilter.mode(
                              Colors.grey, BlendMode.srcIn),
                        )
                      : widget.model.attachment_type.toString() == "NON_IMAGE"
                          ? SvgPicture.asset(
                              colorFilter: const ColorFilter.mode(
                                  Colors.grey, BlendMode.srcIn),
                              'assets/icons/clip.svg',
                            )
                          : Container()
            ],
            //attachment_type
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.model.created_by.profile.nickname.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFB1B1B1),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFFB1B1B1)),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
          _buildIcons(),
        ]),
      ],
    );
  }

  Widget _buildIcons() {
    List widgets = [];
    if (widget.model.positive_vote_count != 0) {
      widgets.add(
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/like.svg',
              width: 10,
              height: 12.46,
              colorFilter:
                  const ColorFilter.mode(Color(0xFFED3A3A), BlendMode.srcIn),
            ),
            const SizedBox(width: 1.97),
            Text(
              widget.model.positive_vote_count.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Color(0xFFED3A3A),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    if (widget.model.negative_vote_count != 0) {
      if (widgets.isNotEmpty) {
        widgets.add(const SizedBox(
          width: 8,
        ));
      }
      widgets.add(
        Row(
          children: [
            SvgPicture.asset('assets/icons/dislike.svg',
                width: 10,
                height: 12.46,
                colorFilter:
                    const ColorFilter.mode(Color(0xFF538DD1), BlendMode.srcIn)),
            const SizedBox(width: 1.97),
            Text(
              widget.model.negative_vote_count.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xFF538DD1)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    if (widget.model.comment_count != 0) {
      if (widgets.isNotEmpty) {
        widgets.add(const SizedBox(
          width: 8,
        ));
      }
      widgets.add(
        Row(
          children: [
            SvgPicture.asset('assets/icons/comment.svg',
                width: 13.75,
                height: 12.21,
                colorFilter:
                    const ColorFilter.mode(Color(0xFF636363), BlendMode.srcIn)),
            const SizedBox(width: 3.13),
            Text(
              widget.model.comment_count.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Color(0xFF636363),
              ),
            ),
          ],
        ),
      );
    }
    return Row(
      children: [
        ...widgets,
      ],
    );
  }

  // TODO: 아래 코드는 iOS 심사 통과를 위한 임시 방편. 익명 차단이 BE에서 구현되면 제거해야함 (2023.02.29)
  bool isAnonymousIOS(ArticleListActionModel model) {
    return (Platform.isIOS && model.name_type == 2);
  }

  /// 게시글 정보를 입력받고 그에 상태에 따라 적절한 제목을 리턴하는 함수.
  /// UserViewPage, UserPage, PostListShowPage, PostViewPage에서 사용함.
  String getTitle(String? orignialTitle, bool isHidden, List<dynamic> whyHidden,
      Locale locale) {
    // 숨겨진 글이 아닌 경우
    if (isHidden == false) {
      return orignialTitle.toString();
    }
    // 숨겨졌으나 why_hidden이 지정되지 않은 경우. 혹시 모를 에러 방지를 위해 추가함.
    else if (whyHidden.isEmpty) {
      return LocaleKeys.postPreview_hiddenPost.tr();
    }

    // TODO: 새로운 사유가 있을 경우 코드에 반영하기.
    late String title;
    switch (whyHidden[0]) {
      case "REPORTED_CONTENT":
        title = LocaleKeys.postPreview_reportedPost.tr();
        break;
      case "BLOCKED_USER_CONTENT":
        title = LocaleKeys.postPreview_blockedUsersPost.tr();
        break;
      case "ADULT_CONTENT":
        title = LocaleKeys.postPreview_adultPost.tr();
        break;
      case "SOCIAL_CONTENT":
        title = LocaleKeys.postPreview_socialPost.tr();
        break;
      case "ACCESS_DENIED_CONTENT":
        title = LocaleKeys.postPreview_accessDeniedPost.tr();
        break;
      // 새로운 whyHidden에 대해서는 숨겨진 게시글로 표기. 이후 앱에서 반영해줘야 함.
      default:
        debugPrint("\n***********************\nANOTHER HIDDEN REASON FOUND: ${whyHidden[0]}\n***********************\n");
        title = LocaleKeys.postPreview_hiddenPost.tr();
    }

    return title;
  }
}
