import '../models/user.dart';
import '../models/user_update_request.dart';
import 'base_provider.dart';
import '../models/user_password_change_request.dart';

class ProfileProvider extends BaseProvider<User> {
  User? currentUser;

  ProfileProvider()
      : super("Profile");

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }

  Future<User> getProfile() async {
    currentUser = await getSingle();
    notifyListeners();

    return currentUser!;
  }

  Future<User> updateProfile(
    UserUpdateRequest request,
  ) async {
    currentUser = await putCustom(
      "",
      request.toJson(),
    );

    notifyListeners();

    return currentUser!;
  }
  Future<void> changePassword(
    UserPasswordChangeRequest request,
  ) async {
    await putVoid(
      "ChangePassword",
      request.toJson(),
    );
  }
}