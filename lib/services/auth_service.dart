import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn =GoogleSignIn();
  
  

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );


  //Get Uid
  Future<String>getCurrentUID()async{
    return (await _firebaseAuth.currentUser()).uid;
    
  }

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(
    
      String email, String password, String name) async {
     await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Update the username
    FirebaseUser user = await updateUserName(name);
    return user.uid;
  }

  Future<FirebaseUser> updateUserName(String name) async {
     FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await user.updateProfile(userUpdateInfo);
    await user.reload();
    return user;
  }

  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user.uid;
  }

  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }
  //Reaset password
  Future sendPasswordResetEmail(String email)async{
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
  // Create Anonymous User
  Future signInAnonymously(){
    return _firebaseAuth.signInAnonymously();
  }
   
   Future convertUserWithEmail(String email, String password, String name)async{
     final currentUser =await _firebaseAuth.currentUser();
     final credential =EmailAuthProvider.getCredential(email: email, password: password);
     FirebaseUser user = await FirebaseAuth.instance.currentUser();
     await currentUser.linkWithCredential(credential);
     await updateUserName(name);

   }

   Future convertWithGoogle()async{
    final currentUser =await _firebaseAuth.currentUser();
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _gooleAuth =await account.authentication;
    final AuthCredential credential =GoogleAuthProvider.getCredential(
      idToken: _gooleAuth.idToken,
      accessToken: _gooleAuth.accessToken,
    );
    await currentUser.linkWithCredential(credential);
    await updateUserName(_googleSignIn.currentUser.displayName);
   }

  //Google
  Future <String> signInWithGoogle()async{
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _gooleAuth =await account.authentication;
    final AuthCredential credential =GoogleAuthProvider.getCredential(
      idToken: _gooleAuth.idToken,
      accessToken: _gooleAuth.accessToken,
    );
   return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
  }

}

class NameValidator {
  static String validate(String value){
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 4) {
      return "Name must be atleast 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value){
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value){
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}