import 'package:expense_app/components/bar_graph.dart';
import 'package:expense_app/components/to_take_tile.dart';
import 'package:expense_app/database/expenseData.dart';
import 'package:expense_app/datetime/date__time_helper.dart';
import 'package:expense_app/models/expenseItems.dart';
import 'package:expense_app/utilities/noti_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/pages/totalExpensespage.dart';
import 'package:expense_app/components/expense_title.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class expenseSummary extends StatelessWidget {
  final DateTime startOfWeek;

  expenseSummary({super.key, required this.startOfWeek});

  double getMax({required List list2}) {
    // here we are getting the highest expense of the week and according to that
    // all other expenses will be judged
    double max = 0;
    print(list2);

    for (List<ExpenseItem> dayExpense in list2) {
      for (ExpenseItem expense in dayExpense)
        if (max < double.parse(expense.amount)) {
          max = double.parse(expense.amount);
        }
    }
    print(max);
    return max;
  }

  double getWeekTotal(List weekExpenses) {
    print("${weekExpenses}  are the");
    double total = 0;
    for (List<double> dayExpense in weekExpenses) {
      for (double expense in dayExpense) {
        total += expense;
      }
    }

    return total;
  }

  List<int> getWeekSummary(List<ExpenseItem> data) {
    int Expenses = 0, Credits = 0, borrowed = 0, loan = 0;
    for (ExpenseItem item in data) {
      if (item.task == "expense") {
        Expenses += int.parse(item.amount);
      } else if (item.task == "credit") {
        Credits += int.parse(item.amount);
      } else if (item.task == "borrowed") {
        borrowed += int.parse(item.amount);
      } else if (item.task == "lent") {
        loan += int.parse(item.amount);
      }
    }
    return [Expenses, Credits, borrowed, loan];
  }

  int getTotal(List weekExpenses) {
    print("${weekExpenses}  are the");
    int total = 0;
    for (List<double> dayExpense in weekExpenses) {
      for (double expense in dayExpense) {
        total += expense.toInt();
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    // getting the date of each day of the week
    String sunday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String monday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String thursday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String friday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String saturday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
        builder: (context, value, child) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Expense: ",
                          style: TextStyle(
                              fontSize: MediaQuery.sizeOf(context).height / 60,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${getWeekSummary(value.getThisWeekTransactions(sunday, monday, tuesday, wednesday, thursday, friday, saturday))[0]}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: MediaQuery.sizeOf(context).height / 55),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Credits: ",
                          style: TextStyle(
                              fontSize: MediaQuery.sizeOf(context).height / 60,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${getWeekSummary(value.getThisWeekTransactions(sunday, monday, tuesday, wednesday, thursday, friday, saturday))[1]}",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: MediaQuery.sizeOf(context).height / 55),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Wallet: ${getTotal(value.getAllCredits().values.toList()) - getTotal(value.getAllExpenses().values.toList())}",
                      style: TextStyle(
                          color: Colors.yellow,
                          fontSize: MediaQuery.sizeOf(context).height / 45),
                    ),
                    Text(
                      "Total: ${getTotal(value.getAllCredits().values.toList()) + getTotal(value.getAllLents().values.toList()) - getTotal(value.getAllExpenses().values.toList()) - -getTotal(value.getAllBorrows().values.toList())}",
                      style: TextStyle(
                          color: Colors.yellow,
                          fontSize: MediaQuery.sizeOf(context).height / 45),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 40,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: MyGraph(
                      maxY: getMax(
                        list2: value.getAllTransactions().values.toList(),
                      ),
                      sunExpenses: value.getAllTransactions()[sunday] ?? [],
                      monExpenses: value.getAllTransactions()[monday] ?? [],
                      tueExpenses: value.getAllTransactions()[tuesday] ?? [],
                      wedExpenses: value.getAllTransactions()[wednesday] ?? [],
                      thuExpenses: value.getAllTransactions()[thursday] ?? [],
                      friExpenses: value.getAllTransactions()[friday] ?? [],
                      satExpenses: value.getAllTransactions()[saturday] ?? []),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Borrowed: ",
                          style: TextStyle(
                              fontSize: MediaQuery.sizeOf(context).height / 60,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${getWeekSummary(value.getThisWeekTransactions(sunday, monday, tuesday, wednesday, thursday, friday, saturday))[2]}",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: MediaQuery.sizeOf(context).height / 55),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Lent: ",
                          style: TextStyle(
                              fontSize: MediaQuery.sizeOf(context).height / 60,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${getWeekSummary(value.getThisWeekTransactions(sunday, monday, tuesday, wednesday, thursday, friday, saturday))[3]}",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: MediaQuery.sizeOf(context).height / 55),
                        )
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Initialize time zone data
                    tz.initializeTimeZones();

                    // Schedule the notification
                    DateTime now = DateTime.now();
                    DateTime reminderTime = now.add(Duration(seconds: 10));

                    await NotificationService().scheduleReminderNotification(
                      title: "Reminder!",
                      body: "Don't forget to complete your task.",
                      scheduledTime: reminderTime,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Reminder scheduled at $reminderTime")),
                    );
                  },
                  child: Text("Set Reminder"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.sizeOf(context).height / 30,
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      NotificationService()
                          .showNotification(title: "billo", body: "rani");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => totalExpensePage()));
                    },
                    // height: MediaQuery.sizeOf(context).height / 5,
                    color: Colors.grey[800],
                    child: Text(
                      "See All Transactions ->",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: value
                        .getThisWeekTransactions(sunday, monday, tuesday,
                            wednesday, thursday, friday, saturday)
                        .length,
                    itemBuilder: (context, index) => to_take_tile(
                        deleteTile: () => value.deleteExpense(value.getThisWeekTransactions(
                            sunday,
                            monday,
                            tuesday,
                            wednesday,
                            thursday,
                            friday,
                            saturday)[index]),
                        task: value
                            .getThisWeekTransactions(sunday, monday, tuesday,
                                wednesday, thursday, friday, saturday)[index]
                            .task,
                        name: value
                            .getThisWeekTransactions(
                                sunday, monday, tuesday, wednesday, thursday, friday, saturday)[index]
                            .name,
                        amount: value.getThisWeekTransactions(sunday, monday, tuesday, wednesday, thursday, friday, saturday)[index].amount,
                        dateTime: value.getThisWeekTransactions(sunday, monday, tuesday, wednesday, thursday, friday, saturday)[index].dateTime),
                  ),
                ),
              ],
            ));
  }
}
