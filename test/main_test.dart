import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_safearea/models/user_model.dart';

void main() {
  group('Main Test Suite', () {
    test('1. User initialization test', () {
      final user = UserModel(
        id: '1',
        email: 'test@gmail.com',
        name: 'User Test',
        createdAt: DateTime.now(),
        role: 'user',
      );
      expect(user.id, '1');
      expect(user.email, 'test@gmail.com');
      expect(user.name, 'User Test');
    });

    test('2. User role validation test', () {
      final admin = UserModel(
        id: '2',
        email: 'admin@gmail.com',
        name: 'Admin Test',
        createdAt: DateTime.now(),
        role: 'admin',
      );
      expect(admin.isAdmin, true);
    });

    test('3. User default role test', () {
      final map = {
        'id': '3',
        'email': 'default@gmail.com',
        'name': 'Default Test',
        'createdAt': '2026-01-01T00:00:00.000Z',
      };
      final user = UserModel.fromMap(map);
      expect(user.role, 'user');
      expect(user.isAdmin, false);
    });
  });
}
