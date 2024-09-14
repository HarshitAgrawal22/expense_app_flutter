import 'package:flutter/material.dart';

class expenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  final Function deleteTile;

  expenseTile(
      {super.key,
      required this.name,
      required this.amount,
      required this.dateTime,
      required this.deleteTile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => deleteTile(),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          dateTime.day.toString() +
              " / " +
              dateTime.month.toString() +
              " / " +
              dateTime.year.toString(),
          style: TextStyle(color: Colors.grey),
        ),
        trailing: Text(
          amount + " Rs. ",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
