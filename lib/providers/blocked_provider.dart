import 'package:flutter/material.dart';

import 'package:new_ara_app/utils/cache_function.dart';

const String blockedPostAnonymousKey = 'ara_blocked_anonymous_data';
const String blockedCommentAnonymousKey = 'ara_blocked_anonymous_data_comment';

class BlockedProvider with ChangeNotifier {
  Set<int> _blockedAnonymousPostIDs = {};
  Set<int> get blockedAnonymousPostIDs => _blockedAnonymousPostIDs;

  Set<int> _blockedAnonymousCommentIDs = {};
  Set<int> get blockedAnonymousCommentIDs => _blockedAnonymousCommentIDs;

  Future<void> addBlockedAnonymousPostID(int postID, bool isPost) async {
    _blockedAnonymousPostIDs.add(postID);
    notifyListeners();
    debugPrint("Caching start");
    cacheApiData(blockedPostAnonymousKey, _blockedAnonymousPostIDs.toList());
    debugPrint("Caching end");
  }

  Future<void> fetchBlockedAnonymousPostID() async {
    dynamic fetchedList = await fetchCachedApiData(blockedPostAnonymousKey);
    debugPrint('fetchedList: ${fetchedList}');
    if (fetchedList == null) {
      _blockedAnonymousPostIDs = {};
    }
    else {
      for (int i = 0; i < fetchedList.length; i++) {
        _blockedAnonymousPostIDs.add(fetchedList[i]);
      }
    }
    notifyListeners();
  }

  Future<void> fetchBlockedAnonymousCommentID() async {
    dynamic fetchedList = await fetchCachedApiData(blockedCommentAnonymousKey);
    debugPrint('fetchedList: ${fetchedList}');
    if (fetchedList == null) {
      _blockedAnonymousCommentIDs = {};
    }
    else {
      for (int i = 0; i < fetchedList.length; i++) {
        _blockedAnonymousCommentIDs.add(fetchedList[i]);
      }
    }
    notifyListeners();
  }
}