import 'package:fire_notifications_new/domain/usecases/get_auth_use_case.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class SplashPresenter extends Presenter {
  Function? getAuthStateOnNext;
  Function? getAuthStateOnComplete;

  GetAuthUseCase? _authUseCase;

  SplashPresenter(userService) {
    _authUseCase = GetAuthUseCase(userService);
  }

  void getAuthStatus() => _authUseCase!.execute(_SplashObserver(this));
  void dispose() => _authUseCase!.dispose();
}

class _SplashObserver implements Observer<bool> {
  SplashPresenter _splashPresenter;

  _SplashObserver(this._splashPresenter);

  void onNext(isAuth) {
    _splashPresenter.getAuthStateOnNext!(isAuth);
  }

  void onComplete() {
    _splashPresenter.getAuthStateOnComplete!();
  }

  void onError(e) {
    _splashPresenter.getAuthStateOnNext!(false);
    onComplete();
  }
}