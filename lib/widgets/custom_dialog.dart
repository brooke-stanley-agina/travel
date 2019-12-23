import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';


class CustomDialog extends StatelessWidget {
  final String title, description, primaryButtonText, primaryButtonRoute, secondaryButtonText, secondaryButtonRoute; 

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.primaryButtonText,
    @required this.primaryButtonRoute,
    this.secondaryButtonText,
    this.secondaryButtonRoute
   
  });
   static const double padding =2.0;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [BoxShadow(
                color: Colors.black,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0)
              )
              ]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 24.0),
                AutoSizeText(
                  title, 
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 24.0),
                 AutoSizeText(
                  description, 
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 24.0),
                RaisedButton(
                  color: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  child: AutoSizeText(
                    primaryButtonText,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed(primaryButtonRoute);
                  },
                ),
                SizedBox(height: 10.0),
                showSecondaryButton(context)
              ],
            ),
          )
        ],
      ),
    );
  }

   showSecondaryButton(BuildContext context) {
    if (secondaryButtonRoute !=null && secondaryButtonText !=null) {
      return FlatButton(
                child: AutoSizeText(
                  secondaryButtonText,
                  maxLines:1,
                  style:TextStyle(
                    fontSize: 18,
                    color: Colors.redAccent,
                    fontWeight:FontWeight.w300
                  )
                ),
                  onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(secondaryButtonRoute);
                },
              );
    }
    else{
      return SizedBox(height: 10.0,);
    }
    
  }
}