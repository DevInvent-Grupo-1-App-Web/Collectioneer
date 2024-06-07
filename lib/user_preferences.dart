class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  String? _userToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6ImFkbWluIiwiZXhwIjoxNzE5MjMyMzg3LCJpc3MiOiJsb2NhbGhvc3QiLCJhdWQiOiJsb2NhbGhvc3QifQ.iMPH769rRiP2jT558uGd_XSPFfYDMkSihGKXir_cQYE';
  int? _userId = 1;
  int? _latestActiveCommunity = 1;
  List<int> _userRoles = [1];
  List<int> _userCommunities = [1];
  int _collectibleId = 1;

  void setUserToken (String token) {
    _userToken = token;
  }

  String? getUserToken() {
    return _userToken;
  }

  void setLatestActiveCommunity(int communityId) {
    _latestActiveCommunity = communityId;
  }

  int? getLatestActiveCommunity() {
    return _latestActiveCommunity;
  }

  void setUserRoles(List<int> roles) {
    _userRoles = roles;
  }

  List<int> getUserRoles() {
    return _userRoles;
  }

  void addUserRole(int roleId) {
    _userRoles.add(roleId);
  }

  void setUserCommunities(List<int> communities) {
    _userCommunities = communities;
  }

  void addUserCommunity(int communityId) {
    _userCommunities.add(communityId);
  }

  List<int> getUserCommunities() {
    return _userCommunities;
  }

  bool hasUserToken() {
    return _userToken != 'no_token';
  }

  int getUserId() {
    return _userId!;
  }

  void setUserId(int userId) {
    _userId = userId;
  }

  void setCollectibleId(int collectibleId) {
    _collectibleId = collectibleId;
  }

  int getCollectibleId() {
    return _collectibleId;
  }


  void clearUserPreferences() {
    _userToken = 'no_token';
    _userId = 0;
    _latestActiveCommunity = 0;
    _userRoles = [];
    _userCommunities = [];
  }
}