import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:new_ara_app/models/article_list_action_model.dart';

class PostPreview extends StatefulWidget {
  final ArticleListActionModel model;
  PostPreview({super.key, required ArticleListActionModel model})
      : model = model ?? ArticleListActionModel.fromJson({});

  @override
  State<PostPreview> createState() => _PostPreviewState();
}

class _PostPreviewState extends State<PostPreview> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    DateTime date =
        DateTime.parse(widget.model.created_at.toString()).toLocal();
    var difference = now.difference(date);
    String time = "미정";
    if (difference.inMinutes < 1) {
      time = "${difference.inSeconds}초 전";
    } else if (difference.inHours < 1) {
      time = '${difference.inMinutes}분 전';
    } else if (date.day == now.day) {
      time =
          '${DateFormat('HH').format(date)}:${DateFormat('mm').format(date)}';
    } else if (date.year == now.year) {
      time =
          '${DateFormat('MM').format(date)}/${DateFormat('dd').format(date)}';
    } else {
      time =
          '${DateFormat('yyyy').format(date)}/${DateFormat('MM').format(date)}/${DateFormat('dd').format(date)}';
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  widget.model.is_hidden!
                      ? "숨겨진 글 입니다."
                      : widget.model.title.toString(),
                  style: const TextStyle(
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
                          'assets/icons/image_post_preview.svg',
                        ),
                        SizedBox(
                          width: 9,
                        ),
                        SvgPicture.asset(
                          'assets/icons/clip_post_preview.svg',
                        ),
                      ],
                    )
                  : widget.model.attachment_type.toString() == "IMAGE"
                      ? SvgPicture.asset(
                          'assets/icons/image_post_preview.svg',
                        )
                      : widget.model.attachment_type.toString() == "NON_IMAGE"
                          ? SvgPicture.asset(
                              'assets/icons/clip_post_preview.svg',
                            )
                          : Container()
            ],
            //attachment_type
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.model.created_by!.profile!.nickname.toString(),
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
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/like.svg',
                  width: 20,
                  height: 20,
                  color: Color(0xFFED3A3A),
                ),
                Text(
                  widget.model.positive_vote_count.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Color(0xFFED3A3A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  width: 8,
                ),
                SvgPicture.asset(
                  'assets/icons/dislike.svg',
                  width: 20,
                  height: 20,
                  color: Color(0xFF538DD1),
                ),
                Text(
                  widget.model.negative_vote_count.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xFF538DD1)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  width: 8,
                ),
                SvgPicture.asset(
                  'assets/icons/comment.svg',
                  width: 20,
                  height: 20,
                  color: Color(0xFF636363),
                ),
                Text(
                  widget.model.comment_count.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Color(0xFF636363),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
