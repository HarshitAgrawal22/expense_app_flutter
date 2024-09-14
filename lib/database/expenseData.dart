import 'package:expense_app/datetime/date__time_helper.dart';
import 'package:expense_app/models/expenseItems.dart';
import 'package:flutter/material.dart';

// here the extending means this class will provide the data
class ExpenseData extends ChangeNotifier {
  // list of all data
  List<ExpenseItem> overAllExpenseList = [];
// get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overAllExpenseList;
  }

// get the list of expenses in detail way

// add a new expense
  void addNewExpense(ExpenseItem newExpense) {
    overAllExpenseList.add(newExpense);
    notifyListeners();
  }

// delete a expense
  void deleteExpense(ExpenseItem Item) {
    overAllExpenseList.remove(Item);
    notifyListeners();
  }

  // get weekday (mon, tues, wed , thurs , fri , sat , sun )
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return "Mon";
      case 2:
        return "tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
    }
    return "";
  }
  // get the date for the start of the week (sunday)

  DateTime startOfWeekDate() {
    DateTime? startOfWeek;
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == "Sun") {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  /*
  
  we will have two methods to classify the expenses 
  
  1. on daily basis 
  2. on weekly basis 
   
  
  
   */
  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overAllExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;

        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }

  Map<String, List<double>> getAllExpenses() {
    Map<String, List<double>> dailyExpenseSummary = {};
    for (var expense in overAllExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        dailyExpenseSummary[date]!.add(amount);
      } else {
        dailyExpenseSummary.addAll({
          date: [amount]
        });
      }
    }
    return dailyExpenseSummary;
  }
}
