import 'package:flutter/material.dart';

class TechnicianApplication extends StatelessWidget {

  const TechnicianApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.grey.shade200,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: Colors.purple.shade100,
            margin: EdgeInsets.all(18) ,
            shadowColor: Colors.black54,
            elevation: 15,
            child: Container(  
              padding: EdgeInsets.all(15),
              child:     
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Your application is sent successfully. ",textAlign: TextAlign.center, style: TextStyle(fontSize: 25,fontWeight: FontWeight.w400),),
                  SizedBox(height: 10,),
                  Text("You will be contacted soon via the provided email.", textAlign: TextAlign.center, style: TextStyle(fontSize: 25,fontWeight: FontWeight.w300),),
                  SizedBox(height: 10,),
                
                  Text("Have a good day!", style: TextStyle(fontSize: 25,fontWeight: FontWeight.w400),),

                ],
              ),
            
            ),
          ),
        ],
      ),
    );
  }
}