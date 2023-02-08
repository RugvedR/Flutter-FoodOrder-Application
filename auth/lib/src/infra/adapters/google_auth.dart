import 'package:async/async.dart';
import '../../domain/auth_service_contract.dart';
import '../../domain/credential.dart';
import '../../domain/token.dart';
import '../../infra/api/auth_api_contract.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth implements IAuthService {
  final IAuthApi _authApi;
  GoogleSignIn _googleSignIn;
  late GoogleSignInAccount _currentUser;

  GoogleAuth(this._authApi, [GoogleSignIn? googleSignIn])
      : this._googleSignIn =
            googleSignIn ?? GoogleSignIn(scopes: ['email', 'profile'],);

  @override
  Future<Result<Token>> signIn() async {
    await _handleGoogleSignIn();
    if(_currentUser == null) return Result.error('Failed to sign in with Google');
    Credential credential = Credential(type: AuthType.google, name: _currentUser.displayName, email: _currentUser.email, password: '');
    // var result = await _authApi.signIn(credential);
    // if(result.isError) return result.asError;
    // return Result.value(Token(result.asValue.value));
    try {
      var result = await _authApi.signIn(credential);
      return Result.value(Token(result.asValue!.value));
    } catch (err) {
      return Result.error(err);
    }
  }

  @override
  Future<void> signOut()async {
    _googleSignIn.disconnect();
  }

  _handleGoogleSignIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
    } catch (e) {
      return;
    }
  }
}
