import 'package:expense_app/components/bar_graph.dart';
import 'package:expense_app/database/expenseData.dart';
import 'package:expense_app/datetime/date__time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class expenseSummary extends StatelessWidget {
  final DateTime startOfWeek;

  expenseSummary({super.key, required this.startOfWeek});

  double getMax({required List list}) {
    double max = 0;

    for (double num in list) {
      if (max < num) {
        max = num;
      }
    }

    return max;
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
      builder: (context, value, child) => SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: MyGraph(
            maxY: getMax(
              list: value.calculateDailyExpenseSummary().values.toList(),
            ),
            sunExpenses: value.getAllExpenses()[sunday] ?? [],
            monExpenses: value.getAllExpenses()[monday] ?? [],
            tueExpenses: value.getAllExpenses()[tuesday] ?? [],
            wedExpenses: value.getAllExpenses()[wednesday] ?? [],
            thuExpenses: value.getAllExpenses()[thursday] ?? [],
            friExpenses: value.getAllExpenses()[friday] ?? [],
            satExpenses: value.getAllExpenses()[saturday] ?? []),
      ),
    );
  }
}
