import 'package:expense_app/database/expenseData.dart';
import 'package:expense_app/models/expenseItems.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class HiveDB {
  // reference our box
  final myBox = Hive.box("expenseDB");
  // write data
  void saveData(List<ExpenseItem> allExpense) {
/*
Hive can only store strings and datetime , and not the custom objects like we have expenseItem , 

So we will need to convert ExpenseItem objects into types that can be stored to the Hive DB 

allExpenses = [

ExpenseItem ( name / amount / datetime )

]
-> 

[name , amount , datetime ]
Effortless Al Boost for Free! Try it out!
https://sider.ai/invited?c=2b30f1259d6cece0cb73b038c240318e
*/

    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
        expense.isExpense
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    // at the end store it in database

    myBox.put("all_expenses", allExpensesFormatted);
  }
  // read data

  List<ExpenseItem> readData() {
/*
Data stored in the database is in the string + datetime  format
we will need to convert that to expenseItem objects 
*/

    List savedExpenses = myBox.get("all_expenses") ?? [];
    List<ExpenseItem> allExpenses = [];
    print(savedExpenses);
    for (int i = 0; i < savedExpenses.length; i++) {
      // Collecting individual data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime datetime = savedExpenses[i][2];
      bool isExpense = savedExpenses[i][3];
// Create expenseItem object

      ExpenseItem expense = new ExpenseItem(
          name: name, amount: amount, dateTime: datetime, isExpense: isExpense);

      // add the item to the list
      allExpenses.add(expense);
    }
    return allExpenses;
  }
  // update data
}
