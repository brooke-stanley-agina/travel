import 'package:flutter/material.dart';
import 'package:lap/models/Trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lap/widgets/provider_widget.dart';
import 'package:intl/intl.dart';

class NewTripSummaryView extends StatelessWidget {
final db =Firestore.instance;
final Trip trip;

// final tripTypes =["Car", "Bus", "Train", "Plane", "Ship", "Other"];
NewTripSummaryView ({Key key, @required this.trip}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    final tripTypes =trip.types();
    var tripKeys =tripTypes.keys.toList();
       return Scaffold(
      appBar: AppBar(
        title: Text('Trip Sammary'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[
            
             Text('Finish'),
             Text("Location ${trip.title}"),
             Text('${DateFormat('dd/MM/yyy').format(trip.startDate).toString()} - ${DateFormat('dd/MM/yyy').format(trip.endDate).toString()}'),

             Expanded(
               child: GridView.count(
                 crossAxisCount: 3,
                 scrollDirection: Axis.vertical,
                 primary: false,
                 children: List.generate(tripTypes.length, (index){
                   return FlatButton(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         tripTypes[tripKeys[index]],
                         Text(tripKeys[index])
                       ],
                     ),
                     onPressed: ()async{
                         trip.travelType = tripKeys[index];
                         final uid =await Provider.of(context).auth.getCurrentUID();
                         await db.collection("userData").document(uid).collection("trips").add(trip.toJson());
                         Navigator.of(context).popUntil((route)=>route.isFirst);
               
                     },
                   );
                 })
               ),
             ),
             
            //  RaisedButton(
            //    child: Text('Finish'),
            //   onPressed: () async{
            //      // save data to firebase
            //      final uid =await Provider.of(context).auth.getCurrentUID();
            //      await db.collection("userData").document(uid).collection("trips").add(trip.toJson());
            //      Navigator.of(context).popUntil((route)=>route.isFirst);
            //    },
            //  ),
          ],
        ),
      )
    );
  }
}