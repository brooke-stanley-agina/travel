import 'package:flutter/material.dart';
import 'package:lap/views/sign_up_view.dart';
import 'package:lap/widgets/provider_widget.dart';
import 'package:lap/views/navigation_view.dart';
import 'package:lap/views/new_trips/first_view.dart';
import 'package:lap/services/auth_service.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
       title: "Travel Budget App",
       theme: ThemeData(
         primarySwatch: Colors.blue,
       ),
       // home: Home(),
       home: HomeController(),
      routes: <String, WidgetBuilder>{
        '/home':(BuildContext context)=>HomeController(),
        '/signUp':(BuildContext context)=>SignUpView(authFormType: AuthFormType.signUp,),
        '/signIn':(BuildContext context)=>SignUpView(authFormType: AuthFormType.signIn,),
        '/anonymoussignIn':(BuildContext context)=>SignUpView(authFormType: AuthFormType.anonymous,),
        '/convertUser':(BuildContext context)=>SignUpView(authFormType: AuthFormType.convert,),
      }
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final AuthService auth = Provider.of(context).auth;
     return StreamBuilder(
       stream: auth.onAuthStateChanged,
       builder: (context, AsyncSnapshot<String> snapshot){
         if (snapshot.connectionState ==ConnectionState.active) {
           final bool signedIn =snapshot.hasData;
           return signedIn ? Home():FirstView();
         }
         return CircularProgressIndicator();
       },
     );
  }
}


