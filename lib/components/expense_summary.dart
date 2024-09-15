import 'package:expense_app/components/bar_graph.dart';
import 'package:expense_app/database/expenseData.dart';
import 'package:expense_app/datetime/date__time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class expenseSummary extends StatelessWidget {
  final DateTime startOfWeek;

  expenseSummary({super.key, required this.startOfWeek});

  double getMax({required List list, required List list2}) {
    // here we are getting the highest expense of the week and according to that
    // all other expenses will be judged
    double max = 0;
    print(list2);
    print(list);
    for (List<double> dayExpense in list2) {
      for (double expense in dayExpense)
        if (max < expense) {
          max = expense;
        }
    }
    print(max);
    return max;
  }

  double getWeekTotal(List weekExpenses) {
    double total = 0;
    for (List<double> dayExpense in weekExpenses) {
      for (double expense in dayExpense) total += expense;
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
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.sizeOf(context).width / 30,
                            vertical: MediaQuery.sizeOf(context).height / 30)),
                    Text(
                      "Week Total :   ",
                      style: TextStyle(
                          fontSize: MediaQuery.sizeOf(context).height / 50,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${getWeekTotal(value.getAllExpenses().values.toList())}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.sizeOf(context).height / 55),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: MyGraph(
                      maxY: getMax(
                          list: value
                              .calculateDailyExpenseSummary()
                              .values
                              .toList(),
                          list2: value.getAllExpenses().values.toList()),
                      sunExpenses: value.getAllExpenses()[sunday] ?? [],
                      monExpenses: value.getAllExpenses()[monday] ?? [],
                      tueExpenses: value.getAllExpenses()[tuesday] ?? [],
                      wedExpenses: value.getAllExpenses()[wednesday] ?? [],
                      thuExpenses: value.getAllExpenses()[thursday] ?? [],
                      friExpenses: value.getAllExpenses()[friday] ?? [],
                      satExpenses: value.getAllExpenses()[saturday] ?? []),
                ),
              ],
            ));
  }
}
