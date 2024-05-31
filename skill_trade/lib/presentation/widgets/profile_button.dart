import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  void handleClick() {
    print("Button was clicked");
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => handleClick(), child: const Text("Update Profile"));
  }
}
