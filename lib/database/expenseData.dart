import 'package:expense_app/database/hiveDB.dart';
import 'package:expense_app/datetime/date__time_helper.dart';
import 'package:expense_app/models/expenseItems.dart';
import 'package:flutter/material.dart';

// here the extending means this class will provide the data
class ExpenseData extends ChangeNotifier {
  // list of all data
  List<ExpenseItem> overAllExpenseList = [];
  List<ExpenseItem> thisWeekExpenseList = [];
// get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overAllExpenseList;
  }

// get the list of expenses in detail way

// add a new expense
  void addNewExpense(ExpenseItem newExpense) {
    overAllExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overAllExpenseList);
  }

  final db = HiveDB();
  void prepareData() {
    if (db.readData().isNotEmpty) {
      overAllExpenseList = db.readData();
    }
  }

// delete a expense
  void deleteExpense(ExpenseItem Item) {
    overAllExpenseList.remove(Item);
    notifyListeners();
    db.saveData(overAllExpenseList);
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

    print("${overAllExpenseList}  are all the transactions");
    for (var expense in overAllExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);
      if (expense.task == "expense") {
        if (dailyExpenseSummary.containsKey(date)) {
          dailyExpenseSummary[date]!.add(amount);
        } else {
          dailyExpenseSummary.addAll({
            date: [amount]
          });
        }
      }
    }
    getAllTransactions();
    return dailyExpenseSummary;
  }

  Map<String, List<double>> getThisWeekExpenses() {
    Map<String, List<double>> dailyExpenseSummary = {};

    print("${overAllExpenseList}  are all the transactions");
    for (var expense in overAllExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);
      if (expense.task == "expense") {
        if (dailyExpenseSummary.containsKey(date)) {
          dailyExpenseSummary[date]!.add(amount);
        } else {
          dailyExpenseSummary.addAll({
            date: [amount]
          });
        }
      }
    }
    getAllTransactions();
    return dailyExpenseSummary;
  }

  List<ExpenseItem> getThisWeekTransactions(
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday) {
    Map<String, List<ExpenseItem>> thisWeekExpenses = {};
    for (var expense in overAllExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);

      if (thisWeekExpenses.containsKey(date)) {
        thisWeekExpenses[date]!.add(expense);
      } else {
        thisWeekExpenses.addAll({
          date: [expense]
        });
      }
    }
    List<ExpenseItem> finalList = [
      ...thisWeekExpenses[sunday] ?? [],
      ...thisWeekExpenses[monday] ?? [],
      ...thisWeekExpenses[tuesday] ?? [],
      ...thisWeekExpenses[wednesday] ?? [],
      ...thisWeekExpenses[thursday] ?? [],
      ...thisWeekExpenses[friday] ?? [],
      ...thisWeekExpenses[saturday] ?? []
    ];
    print("$finalList  is the value in final list");

    return finalList.reversed.toList();
  }

  Map<String, List<ExpenseItem>> getAllTransactions() {
    Map<String, List<ExpenseItem>> allExpenses = {};
    for (var expense in overAllExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);

      if (allExpenses.containsKey(date)) {
        allExpenses[date]!.add(expense);
      } else {
        allExpenses.addAll({
          date: [expense]
        });
      }
    }
    for (var i in allExpenses.values) {
      print(i);
    }

    return allExpenses;
  }

  Map<String, List<double>> getAllCredits() {
    Map<String, List<double>> dailyExpenseSummary = {};
    for (var expense in overAllExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);
      if (expense.task == "credit") {
        if (dailyExpenseSummary.containsKey(date)) {
          dailyExpenseSummary[date]!.add(amount);
        } else {
          dailyExpenseSummary.addAll({
            date: [amount]
          });
        }
      }
    }
    return dailyExpenseSummary;
  }

  Map<String, List<double>> getAllBorrows() {
    Map<String, List<double>> dailyExpenseSummary = {};
    for (var expense in overAllExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);
      if (expense.task == "credit") {
        if (dailyExpenseSummary.containsKey(date)) {
          dailyExpenseSummary[date]!.add(amount);
        } else {
          dailyExpenseSummary.addAll({
            date: [amount]
          });
        }
      }
    }
    return dailyExpenseSummary;
  }

  Map<String, List<double>> getAllLents() {
    Map<String, List<double>> dailyExpenseSummary = {};
    for (var expense in overAllExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);
      if (expense.task == "credit") {
        if (dailyExpenseSummary.containsKey(date)) {
          dailyExpenseSummary[date]!.add(amount);
        } else {
          dailyExpenseSummary.addAll({
            date: [amount]
          });
        }
      }
    }
    return dailyExpenseSummary;
  }
}
