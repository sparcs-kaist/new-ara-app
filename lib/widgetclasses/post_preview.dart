import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostPreview extends StatefulWidget {
  final Map<String, dynamic> json;
  PostPreview({super.key, required Map<String, dynamic>? json})
      : json = json ?? {};

  @override
  State<PostPreview> createState() => _PostPreviewState();
}

class _PostPreviewState extends State<PostPreview> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    DateTime date = DateTime.parse(widget.json["created_at"]).toLocal();
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
                  widget.json["title"] ,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                height: 14.22,
                child: widget.json["attachment_type"] == "IMAGE"
                    ? SvgPicture.asset(
                        'assets/icons/image.svg',
                        fit: BoxFit.fitHeight,
                      )
                    : widget.json["attachment_type"] == "NON_IMAGE"
                        ? SvgPicture.asset(
                            'assets/icons/image.svg',
                            fit: BoxFit.fitHeight,
                          )
                        : Container(),
              )
            ],
            //attachment_type
          ),
        ),
        SizedBox(
          height: 18,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.json["created_by"]["profile"]["nickname"],
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
