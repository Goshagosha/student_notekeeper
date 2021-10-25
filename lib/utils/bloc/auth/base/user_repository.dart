abstract class UserRepository {
  Future<bool> isAuthenticated();

  Future<String> getUserId();
}
