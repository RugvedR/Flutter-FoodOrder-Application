import 'package:async/async.dart';
import 'package:auth/src/domain/credential.dart';
import '../../domain/auth_service_contract.dart';
import '../../domain/signup_service_contract.dart';
import '../../domain/token.dart';
import '../../infra/api/auth_api_contract.dart';

class EmailAuth implements IAuthService, ISignUpService{

  final IAuthApi _api;
  late Credential _credential;
  EmailAuth(this._api);

  void credential({required String email,required String password}){
    _credential = Credential(type: AuthType.email, email: email, password: password, name: '');
  }
  @override
  Future<Result<Token>> signIn() async {
    assert(_credential != null);
    try {
      var result = await _api.signIn(_credential);
      return Result.value(Token(result.asValue!.value));
    }
    catch(err){
      return Result<Token>.error(err);
    }
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Result<Token>> signUp(String name, String email, String password) async {
    Credential credential = Credential(type: AuthType.email, name: name, email: email, password: password);

    var result = await _api.signUp(credential);
    try {
      // var result = await _api.signUp(_credential);
      return Result.value(Token(result.asValue!.value));
    }
    catch(err){
      return Result<Token>.error(err);
    }
  }
  
}
