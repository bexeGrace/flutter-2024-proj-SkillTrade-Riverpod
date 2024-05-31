import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String labelText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool toggleText;
  final bool multiline;
  final bool requiredField;

  const MyTextField({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    this.suffixIcon,
    required this.controller,
    required this.toggleText,
    this.multiline=false,
    this.obscureText = false,
    this.onChanged,
    this.requiredField = true,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
 
  bool _obscure = false;
  IconButton? _suffixIcon;
  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.suffixIcon != null){
      _suffixIcon = IconButton(
          icon: Icon(widget.suffixIcon,
          color: Colors.grey[600],
          size: 25,),
          onPressed: (){ 
            if (widget.toggleText){
              setState(() { 
                _obscure = !_obscure;

              });
            }
          },

        );
    }
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      // onChanged: widget.onChanged,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 16.0,
      ),
    
      maxLines: widget.multiline ? null : 1, 
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          if (widget.requiredField)
          { return 'Please enter your ${widget.labelText}';}
          return null;
        }
        return null;
      },
        
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: Icon(
          widget.prefixIcon,
          color: Colors.grey[600],
          size: 25,
        ),
        
            
        suffixIcon: _suffixIcon,
        
        filled: true,
        fillColor: Colors.white,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red),
        ),
        labelStyle: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}


