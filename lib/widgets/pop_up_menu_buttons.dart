/// PostViewPage에 쓰이는 PopupMenuButton 위젯 일부를 클래스화한 파일
/// 첨부파일, 타인의 댓글에 사용되는 PopupMenuButton을 클래스화함.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:new_ara_app/models/attachment_model.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/constants/file_type.dart';
import 'package:new_ara_app/utils/post_view_utils.dart';
import 'package:new_ara_app/constants/colors_info.dart';

/// PostViewPage에서 첨부파일 표시에 쓰이는 PopupMenuButton
class AttachPopupMenuButton extends StatelessWidget {
  /// 첨부파일의 개수
  final int fileNum;

  /// 첨부파일 각각에 대한 AttachmentModel의 리스트
  final List<AttachmentModel> attachments;

  const AttachPopupMenuButton({
    super.key,
    required this.fileNum,
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
      splashRadius: 5,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Color.fromRGBO(217, 217, 217, 1), width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      padding: const EdgeInsets.all(2.0),
      itemBuilder: _buildItems,
      onSelected: (int result) async {
        AttachmentModel model = attachments[result];
        UserProvider userProvider = context.read<UserProvider>();
        bool res =
            await FileController(model: model, userProvider: userProvider)
                .download();
        debugPrint(res ? "파일 다운로드 성공" : "파일 다운로드 실패");
      },
      child: Text(
        '첨부파일 모아보기 $fileNum',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// PopupMenuButton에 들어가는 각각의 Entry를 생성.
  /// Entry의 List 형태로 리턴함.
  /// PopupMenuButton의 itemBuilder로 사용됨.
  List<PopupMenuEntry<int>> _buildItems(BuildContext context) {
    return List.generate(
      attachments.length,
      (idx) {
        // 모델에 저장된 파일명: /files/{fullFileName}
        // 앞의 '/files/'를 제거.
        String fullFileName =
            Uri.parse(attachments[idx].file).path.substring(7);
        int dotIndex = fullFileName.lastIndexOf(".");

        // 확장자가 없다면 fullFileName을 그대로 사용
        // 확장자가 있다면 확장자의 '.' 전까지 잘라냄.
        String fileName =
            dotIndex == -1 ? fullFileName : fullFileName.substring(0, dotIndex);
        String extension =
            dotIndex == -1 ? "" : fullFileName.substring(dotIndex);

        return PopupMenuItem<int>(
          value: idx,
          child: Container(
            padding: const EdgeInsets.only(left: 3),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0x00FFFFFF),
                width: 2,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              children: [
                // 파일 타입에 따라 이미지를 설정.
                _getFileTypeImage(extension.substring(1)),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    fileName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  extension,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 첨부파일명과 함께 파일 타입 사진을 보여주기 위해 사용.
  /// 파일 확장자를 ext를 통해 받은 후 해당하는 svg 이미지를 리턴.
  SvgPicture _getFileTypeImage(String ext) {
    late String assetPath;
    if (AttachFileType.imageExt.contains(ext)) {
      assetPath = "assets/icons/image.svg";
    } else if (AttachFileType.videoExt.contains(ext)) {
      assetPath = "assets/icons/video.svg";
    } else if (AttachFileType.docx == ext) {
      assetPath = "assets/icons/docx.svg";
    } else if (AttachFileType.pdf == ext) {
      assetPath = "assets/icons/pdf.svg";
    } else {
      assetPath = "assets/icons/clip.svg";
    }
    debugPrint(ext);
    return SvgPicture.asset(
      assetPath,
      color: Colors.black,
      width: 30,
      height: 30,
    );
  }
}

/// PostViewPage에서 타인의 댓글에 쓰이는 PopupMenuButton(채팅, 신고)
class OthersPopupMenuButton extends StatelessWidget {
  /// 대상이 되는 comment의 id
  final int commentID;

  const OthersPopupMenuButton({
    super.key,
    required this.commentID,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
      splashRadius: 5,
      shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color.fromRGBO(217, 217, 217, 1), width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      padding: const EdgeInsets.all(2.0),
      child: SvgPicture.asset(
        'assets/icons/menu_2.svg',
        color: Colors.grey,
        width: 50,
        height: 20,
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
                'assets/icons/warning.svg',
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
}

/// PostViewPage에서 자신의 댓글에 쓰이는 PopupMenuButton(수정, 삭제)
class MyPopupMenuButton extends StatelessWidget {
  /// 대상이 되는 댓글의 id
  final int commentID;
  final UserProvider userProvider;
  /// 대상이 되는 댓글의 _commentList에서의 인덱스
  /// _commentList: PostViewPage에서 사용되는 댓글 리스트
  final int commentIdx;
  /// PopupMenuButton에서 유저가 특정 항목을 선택했을 때 적용
  /// PostViewPage와 밀접하게 연관되는 부분이 있어 클래스에서
  /// 직접 구현하지 않고 전달받음.
  final void Function(String)? onSelected;

  const MyPopupMenuButton({
    super.key,
    required this.commentID,
    required this.userProvider,
    required this.commentIdx,
    required this.onSelected,
  });
 
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
      splashRadius: 5,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Color.fromRGBO(217, 217, 217, 1), width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      padding: const EdgeInsets.all(2.0),
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
      onSelected: onSelected,
      child: SvgPicture.asset(
        'assets/icons/menu_2.svg',
        color: Colors.grey,
        width: 50,
        height: 20,
      ),
    );
  
  }
}