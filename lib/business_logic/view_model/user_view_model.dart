import 'dart:async';
import 'package:dosomething/business_logic/model/response.dart';
import 'package:dosomething/business_logic/model/user_profile.dart';
import 'package:dosomething/business_logic/view_model/abstract_view_model.dart';
import 'package:dosomething/service/api_helper.dart';
import 'package:dosomething/service/database_helper.dart';
import 'package:dosomething/service/web_api_implementation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserViewModel extends AbstractViewModel {
  final WebApi _webApi = WebApi();
  UserProfile? _user;
  bool _signedIn = false;
  bool _initialized = false;

  FirebaseAuth get auth => FirebaseAuth.instance;

  bool get signedIn => _signedIn;

  set signedIn(bool value) {
    _signedIn = value;

    notifyListeners();
  }

  bool get initialized => _initialized;

  set initialized(bool value) {
    _initialized = value;

    notifyListeners();
  }

  UserProfile? get user => _user;

  set user(UserProfile? value) {
    _user = value;

    notifyListeners();
  }

  UserViewModel(){
    initialize();
  }

  Future<void> initialize() async {
    setStatus(ViewModelStatus.busy);
    try {
      await Firebase.initializeApp();
      print('Initialized FlutterFire');
      await initializeAuth();
      print('Initialized Auth');
      initialized = true;
      setStatus(ViewModelStatus.idle);
    } on AccountCreationException catch (e) {
      setStatus(ViewModelStatus.error);
      // return ApiResponse.error('Could not create new account');
    } on FetchDataException catch (e) {
      setStatus(ViewModelStatus.error);
      print(e);
      // _userViewModel.logout();
      // return ApiResponse.error('Could not load user data');
    }  on FirebaseAuthException catch (e) {
      setStatus(ViewModelStatus.error);
      print(e.code);
      // return ApiResponse.error('Could not login to firebase');
    } catch (e) {
      print('Error Initializing FlutterFire');
      print(e);
      setStatus(ViewModelStatus.error);
    }
  }

  Future<void> initializeAuth() async {
    if(auth.currentUser != null) {
      if(auth.currentUser!.isAnonymous) {
        print('Anonymous user is currently signed in');
      } else {
        print('Non-anonymous user is currently signed in');
        signedIn = true;
        await loadUserFromLocalStorage(auth.currentUser!.uid);
      }

    } else {
      print('No signed in user found. Creating new anonymous user.');
      await FirebaseAuth.instance.signInAnonymously();
    }
  }

  Future<ApiResponse<UserProfile>> signUpWithEmailPassword(String email, String password) async {
    try {
      await signUpWithEmailFirebase(email, password);
      await createUser(email, 'Dulitha Dabare');
      await loadUserDataFromApi();
      signedIn = true;
      return ApiResponse.completed('Signed In', user);
    } on FacebookAuthException catch (e) {
      signedIn = false;
      auth.signOut();
      return ApiResponse.error('Could not login to Facebook');
    } on FirebaseLinkingException catch (e) {
      signedIn = false;
      auth.signOut();
      return ApiResponse.error('Linking account with Firebase failed');
    } on AccountCreationException catch (e) {
      signedIn = false;
      auth.signOut();
      return ApiResponse.error('Could not create new account');
    } on FetchDataException catch (e) {
      signedIn = false;
      auth.signOut();
      return ApiResponse.error('Could not load user data');
    }  on FirebaseAuthException catch (e) {
      signedIn = false;
      auth.signOut();
      print(e.code);
      return ApiResponse.error('Could not login to firebase');
    } catch  (e, s) {
      signedIn = false;
      print(e);
      print(s);
      return ApiResponse.error('Error : ${e.toString()}');
    }
  }

  Future<ApiResponse<UserProfile>> signInWithEmailPassword( String email, String password ) async {
    setStatus(ViewModelStatus.busy);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password,);
      await loadUserDataFromApi();
      signedIn = true;
      setStatus(ViewModelStatus.idle);
      return ApiResponse.completed('Signed In', user);
    } on FetchDataException catch (e) {
      signedIn = false;
      setStatus(ViewModelStatus.error);
      return ApiResponse.error('Could not load user data');
    } on FirebaseAuthException catch (e) {
      signedIn = false;
      print(e.code);
      setStatus(ViewModelStatus.error);
      return ApiResponse.error('Could not login to firebase');
    } catch  (e, s) {
      signedIn = false;
      print(e);
      print(s);
      setStatus(ViewModelStatus.error);
      return ApiResponse.error('Error : ${e.toString()}');
    }
  }

  Future<void> createUser(String email, String name) async {
    try {
      UserProfile newUser = UserProfile(
        email: email,
        displayName: name
      );
      final data = await _webApi.createUser(newUser);
      print('New user account created');
    } on FetchDataException catch (e) {
      print('User account creation failed ${e.toString()}');
      throw AccountCreationException('Cannot create new user ${e.toString()}');
    }
  }

  Future<void> loadUserDataFromApi() async {
    final response = await _getUser();
    if( response.status == ApiResponseStatus.COMPLETED ) {
      user = response.data;
      await _saveUser(user!);
      print('User data loaded ${user?.userId}');
    } else if( response.status == ApiResponseStatus.ERROR ) {
      print('Failed to load user data');
      throw FetchDataException(response.message);
    }
  }

  Future<ApiResponse<UserProfile>> _getUser() async {
    try {
      final data = await _webApi.getUser();
      return ApiResponse.completed('Loaded User', data[0]);
    } on FetchDataException catch (e) {
      print(e);
      return ApiResponse.error(e.toString());
    }
  }

  _saveUser(UserProfile user) async {
    UserProfileDbModel userModel = UserProfileDbModel();
    userModel.id = user.userId;
    userModel.firebaseUid = user.firebaseUid;
    userModel.facebookId = user.facebookId;
    userModel.name = user.displayName;
    userModel.email = user.email;
    userModel.timezone = 'Asia/Colombo';
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insertUser(userModel);
    print('inserted row: $id');
  }

  loadUserFromLocalStorage(String firebaseUid) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int rowId = 1;
    UserProfileDbModel? userProfileDbModel = await helper.queryUserProfile(firebaseUid);
    if( userProfileDbModel == null ) {
      await loadUserDataFromApi();
      userProfileDbModel = await helper.queryUserProfile(firebaseUid);
    }

    user = UserProfile(
      userId: userProfileDbModel?.id,
      firebaseUid: userProfileDbModel?.firebaseUid,
      facebookId: userProfileDbModel?.facebookId,
      displayName: userProfileDbModel?.name,
      email: userProfileDbModel?.email,
    );

    if (userProfileDbModel == null) {
      print('read row $rowId: empty');
    } else {
      print('read row $rowId: ${userProfileDbModel.name} ${userProfileDbModel.email}');
    }
  }

  Future<void> signUpWithEmailFirebase( String email, String password ) async {
    AuthCredential emailAuthCredential = EmailAuthProvider.credential(email: email, password: password);
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      print('Created new Firebase user: ${userCredential.user?.email}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print(e.code);
        // Sign the user in with the credential
        await auth.signInWithCredential(emailAuthCredential);
        print('Logged in existing user');
      } else {
        throw e;
      }
    }
  }

  Future<void> logout() async {
    signedIn = false;
    setStatus(ViewModelStatus.busy);
    // await FacebookAuth.instance.logOut();
    try {
      final token = await FirebaseMessaging.instance.getToken();
      await _webApi.logout(token!);
      await FirebaseAuth.instance.signOut();
      print('Logged out');
      user = null;
      setStatus(ViewModelStatus.idle);
    } on FetchDataException catch (e) {
      print(e);
    }
  }
}
