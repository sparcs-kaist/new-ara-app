import 'package:new_ara_app/constants/colors_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/meal_allergen_model.dart';
import '../models/meal_course_model.dart';
import '../models/meal_cafeteria_model.dart';
import '../widgets/allergy_dialog.dart';
import '../widgets/restaurant_dialog.dart';
import '../widgets/cafeteria_menu_section.dart';

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  final List<Allergen> allergens = [
    Allergen(id: 1, name: "1: 달걀"),
    Allergen(id: 2, name: "2: 우유"),
    Allergen(id: 3, name: "3: 메밀"),
    Allergen(id: 4, name: "4: 땅콩"),
    Allergen(id: 5, name: "5: 대두"),
    Allergen(id: 6, name: "6: 밀"),
    Allergen(id: 7, name: "7: 고등어"),
    Allergen(id: 8, name: "8: 게"),
    Allergen(id: 9, name: "9: 새우"),
    Allergen(id: 10, name: "10: 돼지고기"),
    Allergen(id: 11, name: "11: 복숭아"),
    Allergen(id: 12, name: "12: 토마토"),
    Allergen(id: 13, name: "13: 아황산"),
    Allergen(id: 14, name: "14: 호두"),
    Allergen(id: 15, name: "15: 닭고기"),
    Allergen(id: 16, name: "16: 쇠고기"),
    Allergen(id: 17, name: "17: 오징어"),
    Allergen(id: 18, name: "18: 조개류"),
    Allergen(id: 19, name: "19: 잣"),
  ];

  DateTime selectedDate = DateTime.now();
  String selectedMealTime = '점심'; // 아침, 점심, 저녁
  String selectedCafeteria = '카이마루';

  Map<String, Restaurant>? courseMenuData;  // 코스 메뉴 데이터
  Map<String, dynamic>? cafeteriaMenuData;  // 카페테리아 메뉴 데이터
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMenus(); // 초기 로딩
  }

  //현재의 course_menu 가져오기
  List<Course>? _getCurrentMenu() {
    if (courseMenuData == null) return null;

    String restaurantKey;
    switch (selectedCafeteria) {
      case '카이마루':
        restaurantKey = 'fclt';
        break;
      case '서맛골':
        restaurantKey = 'west';
        break;
      case '동맛골 1층':
        restaurantKey = 'east1';
        break;
      case '동맛골 2층':
        restaurantKey = 'east2';
        break;
      case '교수회관':
        restaurantKey = 'emp';
        break;
      default:
        return null;
    }

    final restaurant = courseMenuData![restaurantKey];
    switch (selectedMealTime) {
      case '아침':
        return restaurant?.morningMenu;
      case '점심':
        return restaurant?.lunchMenu;
      case '저녁':
        return restaurant?.dinnerMenu;
      default:
        return null;
    }
  }

  //현재의 cafeteria_menu 가져오기
  // meal_page.dart의 _getCurrentCafeteriaMenu 메서드 추가
  List<CafeteriaMenuItem>? _getCurrentCafeteriaMenu() {
    if (cafeteriaMenuData == null) return null;

    // 동맛골 1층의 데이터만 가져옴
    final east1Data = cafeteriaMenuData!['east1'];
    if (east1Data == null) return null;

    switch (selectedMealTime) {
      case '아침':
        return (east1Data['morning_menu'] as List?)
            ?.map((item) => CafeteriaMenuItem.fromJson(item))
            .toList();
      case '점심':
        return (east1Data['lunch_menu'] as List?)
            ?.map((item) => CafeteriaMenuItem.fromJson(item))
            .toList();
      case '저녁':
        return (east1Data['dinner_menu'] as List?)
            ?.map((item) => CafeteriaMenuItem.fromJson(item))
            .toList();
      default:
        return null;
    }
}

  //요일 변환 함수
  String _getKoreanWeekday(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return '월';
      case DateTime.tuesday:
        return '화';
      case DateTime.wednesday:
        return '수';
      case DateTime.thursday:
        return '목';
      case DateTime.friday:
        return '금';
      case DateTime.saturday:
        return '토';
      case DateTime.sunday:
        return '일';
      default:
        return '';
    }
  }

  // API 호출 함수들
  Future<void> _loadMenus() async {
    setState(() => _isLoading = true);
    
    String dateStr = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    try {
      // 헤더 추가 - 한글 인코딩 용
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };
      // 코스 메뉴 데이터 로드
      final courseResponse = await http.get(
        Uri.parse('https://newara.dev.sparcs.org/api/meals/$dateStr/course_menu'),
        headers: headers,
      );

      // 카페테리아 메뉴 데이터 로드
      final cafeteriaResponse = await http.get(
        Uri.parse('https://newara.dev.sparcs.org/api/meals/$dateStr/cafeteria_menu'),
        headers: headers,
      );

      if (courseResponse.statusCode == 200 && cafeteriaResponse.statusCode == 200) {
        final courseData = json.decode(utf8.decode(courseResponse.bodyBytes));  // utf8.decode 사용
        final cafeteriaData = json.decode(utf8.decode(cafeteriaResponse.bodyBytes));  // utf8.decode 사용
        
        setState(() {
          courseMenuData = {
            'fclt': Restaurant.fromJson(courseData['fclt']),
            'west': Restaurant.fromJson(courseData['west']),
            'east1': Restaurant.fromJson(courseData['east1']),
            'east2': Restaurant.fromJson(courseData['east2']),
            'emp': Restaurant.fromJson(courseData['emp']),
          };
          cafeteriaMenuData = cafeteriaData;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load menu data');
      }
    } catch (e) {
      debugPrint('Error loading menu: $e');
      setState(() => _isLoading = false);
    }
  }

  void _setIsLoaded(bool tf) {
    if (mounted) setState(() => _isLoading = tf);
  }

  // 날짜 변경시 메뉴 다시 로딩
  void _onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      _isLoading = false;  // 로딩 상태 초기화
    });
    _loadMenus();  // 새로운 날짜의 메뉴 로딩
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              '오늘의 학식',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: ColorsInfo.newara,
              ),
            ),
            const SizedBox(width: 6),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: ColorsInfo.newara,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                minimumSize: Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AllergyFilterDialog(
                    allergens: allergens,
                    onAllergyChange: (updatedAllergens) {
                      setState(() {
                        for (var i = 0; i < allergens.length; i++) {
                          allergens[i].selected = updatedAllergens[i].selected;
                        }
                      });
                    },
                  ),
                );
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/filter.svg',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 3),
                  const Text(
                    '알러지 필터',
                    style: TextStyle(
                      color: Color(0xFFC62626),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: ColorsInfo.newara,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => RestaurantFilterDialog(
                  selectedRestaurant: selectedCafeteria,
                  onRestaurantChange: (newRestaurant) {
                    setState(() {
                      selectedCafeteria = newRestaurant;
                    });
                  },
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  selectedCafeteria,
                  style: const TextStyle(
                    color: Color(0xFFC62626),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 4),
                SvgPicture.asset(
                  'assets/icons/chevron-down.svg',
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 날짜 선택 영역
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, //양쪽 끝 정렬
              children: [
                // 날짜 선택 부분  - 왼쪽 정렬
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize : MainAxisSize.min,
                    children : [
                      IconButton(
                        icon : const Icon(Icons.chevron_left),
                        onPressed: () {
                          _onDateChanged(selectedDate.subtract(const Duration(days: 1)));
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                      ),
                      Text(
                        '${selectedDate.month}/${selectedDate.day} (${_getKoreanWeekday(selectedDate)})',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          _onDateChanged(selectedDate.add(const Duration(days: 1)));
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                      ),
                    ],
                  ),
                ),
                // 시간 선택 부분 - 오른쪽 정렬
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildTimeButton('아침'),
                    _buildTimeButton('점심'),
                    _buildTimeButton('저녁'),
                  ],
                ),
              ],
            ),
          ),
          // 메뉴 리스트
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                if (selectedCafeteria == '카페테리아') ...[
                  if (_getCurrentCafeteriaMenu()?.isEmpty ?? true) ...[
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Text(
                          '카페테리아는 ${selectedMealTime}에 운영하지 않습니다.',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    CafeteriaMenuSection(
                      items: _getCurrentCafeteriaMenu()!.map((item) => {
                        'name': item.menuName,
                        'price': item.price,
                        'allergens': item.allergy,
                      }).toList(),
                      allergens: allergens,  // allergens 전달
                    ),
                  ],
                ] else ...[
                  if (_getCurrentMenu()?.isEmpty ?? true) ...[
                    // 운영하지 않는 경우 메시지 표시
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Text(
                          '미운영',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // 메뉴가 있는 경우 표시
                    ...(_getCurrentMenu() ?? []).map((course) => Column(
                      children: [
                        _buildMenuSection(
                          course.courseName,
                          '${course.price}원',
                          course.menuList,
                        ),
                        const SizedBox(height: 16),
                      ],
                    )).toList(),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String time) {
    bool isSelected = selectedMealTime == time;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SizedBox(
        height: 25,
        width: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.red : Colors.white,
            foregroundColor: isSelected ? Colors.white : Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,  // 버튼의 최소 크기 제한 해제
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,  // 탭 영역 축소
            elevation: 0,
            side: BorderSide(
              color: isSelected ? Colors.red : Colors.grey.shade300,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            setState(() {
              selectedMealTime = time;
            });
          },
          child: Text(
            time,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),  // 글자 크기도 작게 조정
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, String price, List<CourseMenuItem> menuItems) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
            ...menuItems.map((item) {
              // 선택된 알러지 항목과 메뉴의 알러지 정보 비교
              bool hasSelectedAllergy = allergens
                  .where((allergen) => allergen.selected)
                  .any((allergen) => item.allergens.contains(allergen.id));

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    if (hasSelectedAllergy) ...[
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: hasSelectedAllergy ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}