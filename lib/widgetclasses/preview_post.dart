
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class PreviewPost extends StatefulWidget {
  Map<String, dynamic> json;
  PreviewPost({super.key, required Map<String, dynamic> json}): json = json ?? {};

  @override
  State<PreviewPost> createState() => _PreviewPostState();
}class _PreviewPostState extends State<PreviewPost> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    DateTime date = DateTime.parse(widget.json["created_at"]).toLocal();
    var difference = now.difference(date);
    String time = "미정";
    if (difference.inMinutes < 1) {
      time = "${difference.inSeconds}초 전";
    } else if (difference.inHours < 1) {
      time = '${difference.inMinutes}분전';
    } else if (date.day == now.day) {
      time =
      '${DateFormat('HH').format(date)}:${DateFormat('mm').format(date)}';
    } else {
      time =
      '${DateFormat('MM').format(date)}/${DateFormat('dd').format(date)}';
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.json["title"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 14.22,
              child: widget.json["attachment_type"] == "IMAGE"
                  ? SvgPicture.asset(
                'assets/icons/has-picture.svg',
                fit: BoxFit.fitHeight,
              )
                  : widget.json["attachment_type"] == "NON_IMAGE"
                  ? SvgPicture.asset(
                'assets/icons/has-picture.svg',
                fit: BoxFit.fitHeight,
              )
                  : Container(),
            )
          ],
          //attachment_type
        ),
        SizedBox(
          height: 17.7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    widget.json["created_by"]["profile"]["nickname"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFB1B1B1),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    time,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFFB1B1B1)),
                  ),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/like.svg',
                    fit: BoxFit.cover,
                  ),
                  Text(
                    widget.json["positive_vote_count"].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xFFED3A3A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  SvgPicture.asset(
                    'assets/icons/dislike.svg',
                    fit: BoxFit.cover,
                  ),
                  Text(
                    widget.json["negative_vote_count"].toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Color(0xFF538DD1)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  SvgPicture.asset(
                    'assets/icons/comment.svg',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    widget.json["comment_count"].toString(),
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
        ),
      ],
    );
  }
}

