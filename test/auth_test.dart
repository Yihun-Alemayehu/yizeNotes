import "package:Yize_Notes/services/auth/auth_exceptions.dart";
import "package:Yize_Notes/services/auth/auth_provider.dart";
import "package:Yize_Notes/services/auth/auth_user.dart";
import "package:test/test.dart";

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('can\'t logout if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('should be initialized ', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('should be initialized in less than 3 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 3)));

    test('create user should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'yize@gmail.com',
        password: 'anything',
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<InvalidLoginCredentialsAuthException>()));

      final badPasswordUser = provider.createUser(
        email: 'someone@gmail.com',
        password: '123456',
      );

      expect(badPasswordUser,
          throwsA(const TypeMatcher<InvalidLoginCredentialsAuthException>()));

      final user = await provider.createUser(
        email: 'yize',
        password: '123',
      );

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('should be able to log in and log out again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 2));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'yize@gmail.com' || password == '123456')
      throw InvalidLoginCredentialsAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw InvalidLoginCredentialsAuthException();
    await Future.delayed(const Duration(seconds: 2));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (_user == null) throw InvalidLoginCredentialsAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
