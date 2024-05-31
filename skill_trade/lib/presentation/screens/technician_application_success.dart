import 'package:flutter/material.dart';

class TechnicianApplicationSuccess extends StatelessWidget {
  const TechnicianApplicationSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Center( 
        child: Container( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Success", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),),
              SizedBox(height: 15,),
              Text("Your application is sent successfully.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, )),
              SizedBox(height: 15,),
              Text("You will be contacted via the provided email.")
            ],
          ),
        
        ),
      ),
    );
  }
}