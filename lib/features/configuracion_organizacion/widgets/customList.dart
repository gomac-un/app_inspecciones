import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  final String text;

  const CustomListItem({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0)
          .copyWith(left: 15),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 10),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          )
        ],
      ),
    );
  }
}
