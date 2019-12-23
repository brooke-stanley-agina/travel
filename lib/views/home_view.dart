import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lap/widgets/provider_widget.dart';
import 'package:lap/models/Trip.dart';





class HomeView extends StatelessWidget {
 
   
  
  @override
  Widget build(BuildContext context) {
    return Container(
      
      color: Colors.grey,
      child: StreamBuilder(
        stream: getUsersTripsStreamSnapshots(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context,  index) => buildTripCard(context, snapshot.data.documents[index])
              
            
          );
        }
      ),
    );
  }

  Stream<QuerySnapshot>getUsersTripsStreamSnapshots(BuildContext context)async*{
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection('userData').document(uid).collection('trips').snapshots();
  }

  Widget buildTripCard(BuildContext context, DocumentSnapshot document){
    final trip = Trip.fromSnapshot(document);
    final tripType = trip.types();

    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
          height: 170.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20.0)
          ),
               child: Padding(
               padding:  EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
               child: Column(
                 children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
                     child: Row(
                       children:<Widget>[
                        Text(trip.title, style: TextStyle(fontSize: 20.0,
                        fontFamily: 'NaumGothic'
                        ),),
                        Spacer()
                       ]
                     ),
                   ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                       children:<Widget>[
                        Text('${DateFormat('dd/MM/yyy').format(trip.startDate).toString()} - ${DateFormat('dd/MM/yyy').format(trip.endDate).toString()}'),
                        Spacer()
                       ]
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Row(
                      children: <Widget>[
                        Text("Shs ${(trip.budget ==null)?'n/a':trip.budget.toStringAsFixed(2)}",style: new TextStyle(fontSize: 25.0),),
                        Spacer(),
                       Icon(Icons.chrome_reader_mode)
                       
                        
                      ],
                    ),
                  )
                  ]
            ),
             ),
        )
      ],
            
          );
  }
  //  Widget chooseOption(BuildContext context, DocumentSnapshot document){
  //    return Container(
  //      child: Column(
  //        children: <Widget>[
  //          Row(
  //            children: <Widget>[
  //              Icon(
  //                Icons.person,
  //                size: 30,
  //              ),
  //              Icon(
  //                Icons.people,
  //                size: 30,
  //              )
  //            ],
  //          )
  //        ],
  //      ),
  //    );
  //  }
}