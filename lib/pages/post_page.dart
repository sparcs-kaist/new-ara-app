import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:new_ara_app/constants/colors_info.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  '[대학원 동아리 연합회] 대학원 동아리 연합회 소속이 되실 동아리를 모집합니다! (feat. 2022년 하반기 동아리 등록 심사 위원회)',
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
                          '2022년 9월 21일 15:14',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(177, 177, 177, 1),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '조회 485',
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
                        Text('0',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: ColorsInfo.newara)),
                        const SizedBox(width: 10),
                        SvgPicture.asset(
                          'assets/icons/dislike.svg',
                          width: 13,
                          height: 15,
                          color: const Color.fromRGBO(83, 141, 209, 1),
                        ),
                        const SizedBox(width: 3),
                        Text('0',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(83, 141, 209, 1))),
                        const SizedBox(width: 10),
                        SvgPicture.asset(
                          'assets/icons/comment.svg',
                          width: 13,
                          height: 15,
                          color: const Color.fromRGBO(99, 99, 99, 1),
                        ),
                        const SizedBox(width: 3),
                        Text('0',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(99, 99, 99, 1))),
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
                            Radius.circular(100)), // 나중에 Image.network로 추가하기
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '류형욱(전산학부)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                  height: 400,
                  child: Center(
                    child: Text('본문 내용'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/like.svg',
                      width: 20,
                      height: 20,
                      color: ColorsInfo.newara,
                    ),
                    const SizedBox(width: 3),
                    Text('0',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: ColorsInfo.newara)),
                    const SizedBox(width: 20),
                    SvgPicture.asset(
                      'assets/icons/dislike.svg',
                      width: 20,
                      height: 20,
                      color: const Color.fromRGBO(83, 141, 209, 1),
                    ),
                    const SizedBox(width: 3),
                    Text('0',
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
                        GestureDetector(
                          child: Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Color.fromRGBO(230, 230, 230, 1),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  const SizedBox(width: 2),
                                  SvgPicture.asset(
                                    'assets/icons/bookmark-circle-fill.svg',
                                    width: 20,
                                    height: 20,
                                    color:
                                        const Color.fromRGBO(100, 100, 100, 1),
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
                        GestureDetector(
                          child: Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Color.fromRGBO(230, 230, 230, 1),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  const SizedBox(width: 2),
                                  SvgPicture.asset(
                                    'assets/icons/share.svg',
                                    width: 20,
                                    height: 20,
                                    color:
                                        const Color.fromRGBO(100, 100, 100, 1),
                                  ),
                                  const SizedBox(width: 5),
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
                        GestureDetector(
                          child: Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Color.fromRGBO(230, 230, 230, 1),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  const SizedBox(width: 2),
                                  SvgPicture.asset(
                                    'assets/icons/exclamationmark-bubble-fill.svg',
                                    width: 20,
                                    height: 20,
                                    color:
                                        const Color.fromRGBO(100, 100, 100, 1),
                                  ),
                                  const SizedBox(width: 5),
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
                    '2개의 댓글',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // 리스트뷰 구현해서 댓글 추가하면 됨
              ],
            ),
          ),
        ),
      ),
    );
  }
}
