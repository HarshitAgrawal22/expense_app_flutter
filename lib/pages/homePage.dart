import 'package:expense_app/components/expense_summary.dart';
import 'package:expense_app/components/expense_title.dart';
import 'package:expense_app/database/expenseData.dart';
import 'package:expense_app/models/expenseItems.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  TextEditingController newExpenseNameController = new TextEditingController(),
      NewExpenseAmountController = new TextEditingController();
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (contex) => AlertDialog(
        title: Text(
          "Add New Expense",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
        content: SingleChildScrollView(
          child: Column(
            children: [
//Expense name

              TextField(
                controller: newExpenseNameController,
                keyboardType: TextInputType.name,
                style: TextStyle(color: Colors.red),
                // here we have defined the type of keyboard we will need in it (String)
                decoration: InputDecoration(
                    hintText: "Expense Name...",
                    hintStyle: TextStyle(color: Colors.red)),
              ),
              // expense amount
              TextField(
                controller: NewExpenseAmountController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.red),
                // Here we have defined that we will need the number type keyboard
                decoration: InputDecoration(
                    hintText: "Rupees...",
                    hintStyle: TextStyle(color: Colors.red)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    onPressed: save,
                    child: Text("Save"),
                    color: Colors.green[900],
                  ),
                  MaterialButton(
                    onPressed: cancel,
                    child: Text("Cancel"),
                    color: Colors.red[900],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void save() {
    ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: NewExpenseAmountController.text,
        dateTime: DateTime.now());
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    newExpenseNameController.clear();
    NewExpenseAmountController.clear();
    Navigator.pop(context);
    setState(() {});
  }

  void cancel() {
    newExpenseNameController.clear();
    NewExpenseAmountController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // here consumer means it will consume the data
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          child: Icon(Icons.add),
          foregroundColor: Colors.black,
          backgroundColor: Colors.red[900],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 20,
            ),

            // Center(
            //   child: Text(
            //     "commutative expenses",
            //     style: TextStyle(fontSize: 25, color: Colors.white),
            //   ),
            // ),

            expenseSummary(startOfWeek: value.startOfWeekDate()),
            // This is the list of expenses on that day

            SizedBox(
              height: MediaQuery.sizeOf(context).height / 20,
            ),

            SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => expenseTile(
                    deleteTile: () =>
                        value.deleteExpense(value.getAllExpenseList()[index]),
                    name: value.getAllExpenseList()[index].name,
                    amount: value.getAllExpenseList()[index].amount,
                    dateTime: value.getAllExpenseList()[index].dateTime),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
