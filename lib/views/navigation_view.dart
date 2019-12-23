import 'package:flutter/material.dart';
import 'package:lap/models/Trip.dart';
import 'package:lap/views/home_view.dart';
import 'package:lap/views/new_trips/location_view.dart';
import 'package:lap/pages.dart';
import 'package:lap/widgets/provider_widget.dart';
import 'package:lap/services/auth_service.dart';



 class Home extends StatefulWidget {
   @override
   _HomeState createState() => _HomeState();
 }
 
 class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _chidren = [
    HomeView(),
    ExplorePage(),
    PastTripsPage(),
  ];

   @override
   Widget build(BuildContext context) {
     final newTrip = Trip(null, null, null, null, null, null);
     return Scaffold(
       appBar: AppBar(
         title: Text("Takoo"),
         actions: <Widget>[
           IconButton(
             icon: Icon(Icons.add),
             onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => NewTripLocationView(trip: newTrip,)));
             },
           ),
            IconButton(
             icon: Icon(Icons.undo),
             onPressed: ()async{
               try {
                 AuthService auth =Provider.of(context).auth;
                 await auth.signOut();
                 print("signedOut!");
               } catch (e) {
                 print(e);
               }
             },
           ),
           IconButton(
             icon: Icon(Icons.account_circle),
             onPressed: ()async{
              Navigator.of(context).pushNamed('/convertUser');
             },
           ),
         ],
       ),
       body: _chidren[_currentIndex],
       bottomNavigationBar: BottomNavigationBar(
         onTap: onTabTapped,
         currentIndex: _currentIndex,
         items: [
           BottomNavigationBarItem(                          
             icon:Icon(Icons.home),
             title: Text('Home'),
           ),
           BottomNavigationBarItem(
             icon:Icon(Icons.explore),
             title: Text('Explore'),
           ),
           BottomNavigationBarItem(
             icon:Icon(Icons.history),
             title: Text('Past Trips'),
           )
         ],
       ),
     );
   }
   void onTabTapped(int index){
     setState(() {
       _currentIndex =index;
     });
   }
 }