import 'package:flutter/material.dart';

class to_take_tile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  final Function deleteTile;
  final String task;

  const to_take_tile(
      {super.key,
      required this.task,
      required this.name,
      required this.amount,
      required this.dateTime,
      required this.deleteTile});
  Color taskSelector(String task) {
    print(task);
    if (task == "expense") {
      return Colors.red.shade800;
    } else if (task == "credit") {
      return Colors.green.shade800;
    } else if (task == "lent") {
      return Colors.blue.shade800;
    } else if (task == "borrowed") {
      return Colors.purple.shade800;
    }
    return Colors.white;
  }

  String weekDaySelector(int dayNum) {
    switch (dayNum) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";

      default:
        return "Not valid date";
    }
  }

  String taskExplainer(String task, DateTime day) {
    // dateTime.add(Duration(days: 5)).difference(DateTime.now()).inDays;
    if (task == "credit") {
      return "\n${DateTime.now().difference(dateTime).inDays} days ago";
    } else if (task == "expense") {
      return "\n${DateTime.now().difference(dateTime).inDays} days ago";
    } else if (task == "borrowed") {
      return "\n${dateTime.add(Duration(days: 5)).difference(DateTime.now()).inDays} days left to repay";
    } else if (task == "lent") {
      return "\n${dateTime.add(Duration(days: 5)).difference(DateTime.now()).inDays} days to get back";
    }
    return "invalid task";
  }

  void showDetails(String name, String amount, DateTime dateTime, String task,
      BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name.toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Amount: ${amount} Rs.",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: task == "expense"
            ? Colors.red.shade700
            : task == "credit"
                ? Colors.green.shade700
                : task == "borrowed"
                    ? Colors.purple.shade700
                    : Colors.blue.shade700,
        content: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                  style: TextStyle(color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${weekDaySelector(dateTime.add(Duration(days: 4)).weekday)}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.sizeOf(context).width / 25),
                    ),
                    Text(
                      "${taskExplainer(task, dateTime)}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.sizeOf(context).width / 25),
                    )
                  ],
                ),
              ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
          vertical: MediaQuery.sizeOf(context).height / 130,
          horizontal: MediaQuery.sizeOf(context).width / 50),
      child: GestureDetector(
        onLongPress: () => showDetails(name, amount, dateTime, task, context),
        onDoubleTap: () => deleteTile(),
        child: ListTile(
          tileColor: taskSelector(task),
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
            style: TextStyle(color: Colors.grey.shade200),
          ),
          trailing: Text(
            amount + " Rs. ",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
