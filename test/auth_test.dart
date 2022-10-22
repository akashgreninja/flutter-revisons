import 'package:flutter_test_for_vs/services/auth/auth_provider.dart';
import 'package:flutter_test_for_vs/services/auth/auth_user.dart';
import 'package:flutter_test_for_vs/services/auth/authexceptions.dart';
import 'package:test/test.dart';

void main() {
  group("mock tests", () {
    final provider = MockAuthProvider();
    test("should not begin to start with", () {
      expect(provider.isInitialized, false);
    });

    test("cannot log out if not initialized", () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    test("should be ble to initialize", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test("user should be null", () {
      expect(provider.currentUser, null);
    });
    test(
      "should not be able to initialize in less  than 2 sec",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(const Duration(seconds: 4)),
    );
    test("create user should delegate to  login ", () async {
      final EmailUser = provider.createUser(
        email: 'akaaa@we.com',
        password: 'frasasaasa',
      );
      expect(
          EmailUser, throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badpasswordUser =
          provider.createUser(email: "sasa@gmail.com", password: "foobar");

      expect(badpasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final correct =
          await provider.createUser(email: "sasas", password: "fas");

      expect(provider.currentUser, correct);
      expect(correct.isEmailVerified, false);
    });
    test('logged in user should be verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('should be able to log in and logout', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isinitialized = false;
  bool get isInitialized => _isinitialized;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 2));
    return logIn(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    _isinitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'akaaa@we.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();

    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 2));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
