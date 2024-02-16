import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:new_ara_app/models/article_list_action_model.dart';
import 'package:new_ara_app/utils/time_utils.dart';
import 'package:new_ara_app/utils/handle_hidden.dart';

class PostPreview extends StatefulWidget {
  final ArticleListActionModel model;
  const PostPreview({super.key, required this.model});

  @override
  State<PostPreview> createState() => _PostPreviewState();
}

class _PostPreviewState extends State<PostPreview> {
  @override
  Widget build(BuildContext context) {
    String time = getTime(widget.model.created_at.toString());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.model.parent_topic!=null)
                Text(
                  "[${widget.model.parent_topic!.ko_name}] ",
                  style: const TextStyle(
                    color: Color(0xFFED3A3A),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                ),
              Flexible(
                child: Text(
                  getTitle(widget.model.title, widget.model.is_hidden, widget.model.why_hidden),
                  style: TextStyle(
                    color: widget.model.is_hidden
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
}
