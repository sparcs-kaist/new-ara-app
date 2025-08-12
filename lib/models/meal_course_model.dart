// lib/models/course_menu_model.dart
class CourseMenuItem {
  final String name;
  final List<int> allergens;

  CourseMenuItem({
    required this.name,
    required this.allergens,
  });

  factory CourseMenuItem.fromList(List<dynamic> list) {
    return CourseMenuItem(
      name: list[0],
      allergens: List<int>.from(list[1]),
    );
  }
}

class Course {
  final String courseName;
  final int price;
  final List<CourseMenuItem> menuList;

  Course({
    required this.courseName,
    required this.price,
    required this.menuList,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseName: json['course_name'],
      price: json['price'],
      menuList: (json['menu_list'] as List)
          .map((item) => CourseMenuItem.fromList(item))
          .toList(),
    );
  }
}

class Restaurant {
  final String name;
  final String type;
  final List<Course>? morningMenu;  // null 가능
  final List<Course>? lunchMenu;    // null 가능
  final List<Course>? dinnerMenu;   // null 가능

  Restaurant({
    required this.name,
    required this.type,
    this.morningMenu,
    this.lunchMenu,
    this.dinnerMenu,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    // 빈 배열이 오는 경우 null로 처리
    List<Course>? parseMenu(List? menuList) {
      if (menuList == null || menuList.isEmpty) return null;
      return menuList.map((item) => Course.fromJson(item)).toList();
    }

    return Restaurant(
      name: json['name'],
      type: json['type'],
      morningMenu: parseMenu(json['morning_menu'] as List?),
      lunchMenu: parseMenu(json['lunch_menu'] as List?),
      dinnerMenu: parseMenu(json['dinner_menu'] as List?),
    );
  }

  // 현재 시간대의 메뉴 반환
  List<Course>? getMenuForTime(String timeSlot) {
    switch (timeSlot) {
      case '아침':
        return morningMenu;
      case '점심':
        return lunchMenu;
      case '저녁':
        return dinnerMenu;
      default:
        return null;
    }
  }

  // 특정 시간대 운영 여부 확인
  bool isOperating(String timeSlot) {
    return getMenuForTime(timeSlot) != null;
  }
}