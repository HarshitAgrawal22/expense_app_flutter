import 'package:expense_app/components/to_take_tile.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/components/expense_summary.dart' as expense_summary;
import 'package:expense_app/components/expense_title.dart';
import 'package:expense_app/database/expenseData.dart';
import 'package:expense_app/models/expenseItems.dart';
import 'package:provider/provider.dart';

class totalExpensePage extends StatefulWidget {
  const totalExpensePage({super.key});

  @override
  State<totalExpensePage> createState() => _totalExpensePageState();
}

class _totalExpensePageState extends State<totalExpensePage> {
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
    return Consumer<ExpenseData>(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Column(children: [
                  Text(
                    "Transactions",
                    style: TextStyle(
                        fontSize: MediaQuery.sizeOf(context).height / 30),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Expenses => ${getTotal(value.getAllExpenses().values.toList())}",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: MediaQuery.sizeOf(context).width / 25),
                      ),
                      Text(
                        "Credits => ${getTotal(value.getAllCredits().values.toList())}",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: MediaQuery.sizeOf(context).width / 25),
                      )
                    ],
                  ),
                ]),
                centerTitle: true,
                toolbarHeight: 120,
              ),
              backgroundColor: Colors.black,
              body: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: value.getAllExpenseList().length,
                  itemBuilder: (context, index) => to_take_tile(
                      deleteTile: () =>
                          value.deleteExpense(value.getAllExpenseList()[index]),
                      task: value.getAllExpenseList()[index].task,
                      name: value.getAllExpenseList()[index].name,
                      amount: value.getAllExpenseList()[index].amount,
                      dateTime: value.getAllExpenseList()[index].dateTime),
                ),
              ),
            ));
  }
}
