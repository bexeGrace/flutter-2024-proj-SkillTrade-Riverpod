import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData( 
  appBarTheme: const AppBarTheme( 
    color: Color.fromARGB(255, 81, 143, 101),
  ),
  colorScheme: ColorScheme.light( 
    background: Colors.white,
    primary: const Color.fromARGB(255, 81, 143, 101),
    secondary: Colors.grey.shade200,


  ),
);

ThemeData darkMode = ThemeData( 
  appBarTheme: const AppBarTheme( 
    color: Color.fromARGB(255, 81, 143, 101),
  ),
  colorScheme: const ColorScheme.light( 
    background: Colors.black,
    primary: Color.fromARGB(255, 87, 155, 109),
    secondary: Color.fromARGB(255, 128, 124, 124),
  ),
);