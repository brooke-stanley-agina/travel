import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lap/models/Trip.dart';
import 'package:lap/models/places.dart';
import 'package:lap/widgets/divider_with_Text.dart';
import 'date_view.dart';
import 'package:lap/Credentials.dart';
import 'package:dio/dio.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
class NewTripLocationView extends StatefulWidget {
final Trip trip;
NewTripLocationView ({Key key, @required this.trip}) : super(key:key);

  @override
  _NewTripLocationViewState createState() => _NewTripLocationViewState();
}

class _NewTripLocationViewState extends State<NewTripLocationView> {
  TextEditingController _searchController =TextEditingController();
  Timer _throttle;
  String _heading;
  List<Place>_placesList;
final List<Place>_suggestedList = [
  Place("New York", 320.00),
  Place("Austin", 250.00),
  Place("Boston", 290.00),
  Place("Florence", 300.00),
  Place("Washington D.C", 190.00)
];
int _calls = 0;
@override
  void initState() {
    
    super.initState();
    _heading="Suggestions";
    _placesList = _suggestedList;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose(){
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged(){
   if(_throttle?.isActive ??false)_throttle.cancel();
   _throttle =Timer(const Duration(milliseconds: 300), (){
    getLocationResults(_searchController.text);
   });
  }
  void getLocationResults(String input)async{
    if (input.isEmpty) {
      setState(() {
        _heading = "Suggestions";
      });
      return;
    }
    String baseURL = 'https://maps.googleqpis.com/maps/api/place/autocomplete/json';
    String type = '(regions)';

    String request = '$baseURL?input=$input&key=$PLACES_API_KEY&type=$type';
    Response response = await Dio().get(request);

    final predictions =response.data['predictions'];
    
    List<Place> _displayedResults = [];

    for (var i = 0; i < predictions.length; i++) {
      String name = predictions[i]['description'];
      double averageBudget = 200.0;
      _displayedResults.add(Place(name, averageBudget));
    }

    setState(() {
      _heading = "Results";
      _placesList =_displayedResults;
      _calls++;
    });
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Trip-Location'),
      ),
      body: Column(
        
        children: <Widget>[
          Text("API calls: $_calls"),
           
           Padding(
             padding: const EdgeInsets.all(10.0),
             child: TextField(
               controller: _searchController,
              // autofocus: false,
             //  autocorrect: true,
               decoration: InputDecoration(
                 prefixIcon: Icon(Icons.search),
               ),
              
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(left: 10.0,right: 10.0),
             child: new DividerWithText(dividerText: _heading,),
           ),
           Expanded(
             child: ListView.builder(
               itemCount: _placesList.length,
               itemBuilder: (BuildContext context, int index)=>buildPlaceCard(context, index),
             ),
           )
          
        ],
      )
    );
  }

  Widget buildPlaceCard(BuildContext context, int index){
  var trip;
    return Hero(
      tag: "SelectedTrip-${_placesList[index].name}",
      transitionOnUserGestures: true,
        child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Stack(
            children: <Widget>[
              Container(
                 margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
            height: 170.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(20.0)
            ),
                child: InkWell(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30.0, 20.0, 20.0, 20.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: AutoSizeText(_placesList[index].name,
                                maxLines: 3,
                                style:TextStyle(fontSize:25.0)),
                              )
                            ],
                          ),
                          SizedBox(height: 10.0,),
                           Row(
                            children: <Widget>[
                              Text("Shs ${_placesList[index].averageBudget.toStringAsFixed(2)}", style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 20.0
                              ),),
                              
                            ],
                          ),
                        //   Row(
                        //     children: <Widget>[
                        //        Text('${DateFormat('dd/MM/yyy').format(trip.startDate).toString()} - ${DateFormat('dd/MM/yyy').format(trip.endDate).toString()}', style: TextStyle(
                        //       fontStyle: FontStyle.normal,
                        //       fontSize: 20.0
                        //     ),)
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20,top: 10),
                  child: Column(
                  
                     children: <Widget>[
                       ClipRRect(
                         borderRadius: BorderRadius.circular(20.0),
                         child: Image(
                        height: 100.0,
                        width: 100.0,
                        image: AssetImage(
                          'assests/images/stmarksbasilica.jpg',
                        ),
                        fit: BoxFit.cover,
                         )
                       )
                     ],
                  ),
                )
              ],
            ),
            onTap: (){
              widget.trip.title =_placesList[index].name;
              Navigator.push(
                context, 
                  MaterialPageRoute(
                builder: (context)=>NewTripDateView(trip: widget.trip,)
                )
                );
            },
          ),
            )
          ],
          
        ),
      ),
    ),
  );
}
}









// RaisedButton(
// child: Text('Continue'),
// onPressed: (){
// trip.title =_titleController.text;
// Navigator.push(context, MaterialPageRoute(builder: (context)=>NewTripDateView(trip:trip)));
// },
// ),