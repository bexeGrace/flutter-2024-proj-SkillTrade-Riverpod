import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ServicesCard extends StatelessWidget {
  final String imageUrl, title, description;
    
  const ServicesCard({super.key, 
      required this.imageUrl,
      required this.title,
      required this.description,});

    @override
    Widget build(BuildContext context) {
      return Card(
        shadowColor: Colors.black38,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20,),
                Image.asset(
                    imageUrl,
                    width: 300,
                    height: 200,
                    fit: BoxFit.cover,
                  ), 
                
              Container( 
                  padding: EdgeInsets.all(8),
                  width: 300,                
                  child: Text(description, style: TextStyle(fontSize: 20),)
                ),
            ],
          ),
        ),
      );
    }
  }
