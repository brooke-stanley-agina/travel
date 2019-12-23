import 'package:flutter/material.dart';
import 'package:lap/models/Trip.dart';
import 'package:lap/widgets/divider_with_Text.dart';
import 'package:flutter/services.dart';
import 'package:lap/views/new_trips/summery_view.dart';


enum budgetType{simple, complex}

class NewTripBudgetView extends StatefulWidget {
final Trip trip;
NewTripBudgetView ({Key key, @required this.trip}) : super(key:key);

  @override
  _NewTripBudgetViewState createState() => _NewTripBudgetViewState();
}

class _NewTripBudgetViewState extends State<NewTripBudgetView> {
var _budgetState =budgetType.simple;
var _switchButtonText = "Build Budget";
var _budgetTotal = 0;
 TextEditingController _budgetController =new TextEditingController();
 TextEditingController _transportationController =new TextEditingController();
 TextEditingController _foodController =new TextEditingController();
 TextEditingController _lodgingController =new TextEditingController();
 TextEditingController _entertainmentController =new TextEditingController();
 
 @override
 void initState(){
   super.initState();
   _transportationController.addListener(_setTotalBudget);
   _foodController.addListener(_setTotalBudget);
   _lodgingController.addListener(_setTotalBudget);
  _entertainmentController.addListener(_setTotalBudget);
 }

_setTotalBudget(){
 var total =0;
  total = (_transportationController.text == "")? 0 :int.parse(_transportationController.text);
  total += (_foodController.text == "")? 0 :int.parse(_foodController.text);
  total += (_lodgingController.text == "")? 0 :int.parse(_lodgingController.text);
  total += (_entertainmentController.text == "")? 0 :int.parse(_entertainmentController.text);
  setState(() {
    _budgetTotal =total;
  });

}


List<Widget> setBudgetFields(_budgetController){
  List<Widget>fields =[];

  if (_budgetState ==budgetType.simple) {
    
    _switchButtonText = "Build Budget";
    fields.add(Text("Enter a Trip Budget"),);
    fields.add( generateTextField(_budgetController, "Daily estimated budget"));
  }else { //assume complex)
    
    _switchButtonText = "Simple Budget";
    fields.add(Text("Enter How much you want to spend in each area"),);
    fields.add( generateTextField(_transportationController, "Daily estimated budget"));
    fields.add( generateTextField(_foodController, "Daily estimated budget"));
    fields.add( generateTextField(_lodgingController, "Daily estimated budget"));
    fields.add( generateTextField(_entertainmentController, "Daily estimated budget"));
    fields.add(Text("Total: \$$_budgetTotal"));

  }
   fields.add(
     FlatButton(
               child: Text('Continue', style: TextStyle(fontSize: 25, color: Colors.blue),),
              onPressed: () async{
                 widget.trip.budget = _budgetTotal.toDouble();
                 widget.trip.budgetTypes = {
                    'transportation':(_transportationController.text=="")? 0.0 : double.parse(_transportationController.text),
                    'food':(_foodController.text=="")? 0.0 : double.parse(_foodController.text),
                    'lodging':(_lodgingController.text=="")? 0.0 : double.parse(_lodgingController.text),
                    'entertainment':(_entertainmentController.text=="")? 0.0 : double.parse(_entertainmentController.text),

                 };
                
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>NewTripSummaryView(trip: widget.trip)));
               },
             ),
   );
    fields.add(DividerWithText(dividerText: "or",));        
    fields.add(
       FlatButton(
               child: Text(_switchButtonText, style: TextStyle(fontSize: 25, color: Colors.blue),),
              onPressed: () {
                setState(() {
                  _budgetState = (_budgetState ==budgetType.simple)? budgetType.complex :budgetType.simple;
                });
               },
             ),
    );
  return fields;
}

  @override
  Widget build(BuildContext context) {
   _budgetController.text = (_budgetController.text == "0")? "":_budgetTotal.toString();

       return Scaffold(
      appBar: AppBar(
        title: Text('Create Trip-Budget'),
      ),
      body: SingleChildScrollView(
              child: Center(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children:setBudgetFields(_budgetController),
          ),
        ),
      )
    );
  }
  Widget generateTextField(controller, helperText){
    Widget textField=Padding(
      padding: const EdgeInsets.all(30.0),
      child: TextField(
        controller: controller,
        maxLines: 1,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.attach_money),
          helperText:helperText,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: false),
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly
        ],
        autofocus: true,
      ),
        );
        return textField;
  }
}