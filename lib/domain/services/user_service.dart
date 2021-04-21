import 'package:fire_notifications_new/data/dtos/account_dto.dart';

abstract class UserService {
  Future<void> authenticate(
      {required String url, required String username, required String password});
  Future<bool> isAuthenticated();
}
