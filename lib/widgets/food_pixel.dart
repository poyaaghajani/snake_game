import 'package:flutter/material.dart';

class FoosPixel extends StatelessWidget {
  const FoosPixel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
