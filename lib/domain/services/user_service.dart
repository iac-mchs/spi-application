abstract class UserService {
  Future<void> authenticate(
      {required String url, required String username, required String password});
  Future<bool> isAuthenticated();
}
