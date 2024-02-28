import 'package:flutter/material.dart';

import 'package:new_ara_app/utils/cache_function.dart';

const String blockedAnonymousKey = 'ara_blocked_anonymous_data';

class BlockedProvider with ChangeNotifier {
  Set<int> blockedAnonymousPostIDs = {};

  Future<void> addBlockedAnonymousPostID(int postID) async {
    blockedAnonymousPostIDs.add(postID);
    notifyListeners();
    debugPrint("Caching start");
    cacheApiData(blockedAnonymousKey, blockedAnonymousPostIDs.toList());
    debugPrint("Caching end");
  }

  Future<void> fetchBlockedAnonymousPostID() async {
    dynamic fetchedList = await fetchCachedApiData(blockedAnonymousKey);
    debugPrint('fetchedList: ${fetchedList}');
    if (fetchedList == null) {
      blockedAnonymousPostIDs = {};
    }
    else {
      for (int i = 0; i < fetchedList.length; i++) {
        blockedAnonymousPostIDs.add(fetchedList[i]);
      }
    }
    notifyListeners();
  }
}