import 'package:flutter/material.dart';

class expenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  final Function deleteTile;
  final bool isExpense;

  expenseTile(
      {super.key,
      required this.isExpense,
      required this.name,
      required this.amount,
      required this.dateTime,
      required this.deleteTile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
          vertical: MediaQuery.sizeOf(context).height / 130,
          horizontal: MediaQuery.sizeOf(context).width / 50),
      child: GestureDetector(
        onLongPress: () => deleteTile(),
        child: ListTile(
          tileColor: isExpense ? Colors.red.shade400 : Colors.green.shade400,
          title: Text(
            name,
            style: TextStyle(color: Colors.black),
          ),
          subtitle: Text(
            dateTime.day.toString() +
                " / " +
                dateTime.month.toString() +
                " / " +
                dateTime.year.toString(),
            style: TextStyle(color: Colors.grey.shade800),
          ),
          trailing: Text(
            amount + " Rs. ",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
