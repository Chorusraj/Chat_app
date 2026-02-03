String getChatId(String userAId, String userBId) {
  if (userAId.compareTo(userBId) < 0) {
    return '${userAId}_$userBId';
  } else {
    return '${userBId}_$userAId';
  }
}
