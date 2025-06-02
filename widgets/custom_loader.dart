import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final String message;

  const CustomLoader({super.key, this.message = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
