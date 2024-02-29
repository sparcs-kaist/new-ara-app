import 'package:flutter/material.dart';
import 'package:new_ara_app/utils/cache_function.dart';

const String blockedPostAnonymousKey = 'ara_blocked_anonymous_data';
const String blockedCommentAnonymousKey = 'ara_blocked_anonymous_data_comment';

class BlockedProvider with ChangeNotifier {
  Set<String> _blockedAnonymousPostIDs = {};
  Set<String> get blockedAnonymousPostIDs => _blockedAnonymousPostIDs;

  Set<String> _blockedAnonymousCommentIDs = {};
  Set<String> get blockedAnonymousCommentIDs => _blockedAnonymousCommentIDs;

  Future<void> addBlockedAnonymousPostID(String userID) async {
    _blockedAnonymousPostIDs.add(userID);
    notifyListeners();
    debugPrint("Caching start");
    cacheApiData(blockedPostAnonymousKey, _blockedAnonymousPostIDs.toList());
    debugPrint("Caching end");
  }

  Future<void> addBlockedAnonymousCommentID(String commentID) async {
    _blockedAnonymousCommentIDs.add(commentID);
    notifyListeners();
    debugPrint("Caching start");
    cacheApiData(
        blockedCommentAnonymousKey, _blockedAnonymousCommentIDs.toList());
    debugPrint("Caching end");
  }

  Future<void> removeBlockedAnonymousPostID(String userID) async {
    _blockedAnonymousPostIDs.remove(userID);
    notifyListeners();
    debugPrint("Caching start");
    cacheApiData(
        blockedPostAnonymousKey, _blockedAnonymousPostIDs.toList());
    debugPrint("Caching end");
  }

  Future<void> removeBlockedAnonymousCommentID(String commentID) async {
    _blockedAnonymousCommentIDs.remove(commentID);
    notifyListeners();
    debugPrint("Caching start");
    cacheApiData(
        blockedCommentAnonymousKey, _blockedAnonymousCommentIDs.toList());
    debugPrint("Caching end");
  }

  Future<void> fetchBlockedAnonymousPostID() async {
    dynamic fetchedList = await fetchCachedApiData(blockedPostAnonymousKey);
    debugPrint('fetchedList: ${fetchedList}');
    if (fetchedList == null) {
      _blockedAnonymousPostIDs = {};
    } else {
      for (int i = 0; i < fetchedList.length; i++) {
        _blockedAnonymousPostIDs.add(fetchedList[i].toString());
      }
    }
    notifyListeners();
  }

  Future<void> fetchBlockedAnonymousCommentID() async {
    dynamic fetchedList = await fetchCachedApiData(blockedCommentAnonymousKey);
    debugPrint('fetchedList: ${fetchedList}');
    if (fetchedList == null) {
      _blockedAnonymousCommentIDs = {};
    } else {
      for (int i = 0; i < fetchedList.length; i++) {
        _blockedAnonymousCommentIDs.add(fetchedList[i]);
      }
    }
    notifyListeners();
  }

  
}
