import 'package:fire_notifications_new/data/services/data_user_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('DataUserService', () {
    DataUserService? dataUserService;

    setUp(() {
      dataUserService = DataUserService();
    });

    test('.authenticate() logs user correctly', () async {
      await dataUserService!.authenticate(url: 'test', username: 'test', password: 'test');
      expect(await dataUserService!.isAuthenticated(), isA<bool>());
    });
  });
}
