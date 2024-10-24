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
      NewExpenseAmountController = new TextEditingController(),
      NewIsExpenseController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void save(bool isRecurring) {
    print(isRecurring);
    if (newExpenseNameController.text.isNotEmpty &&
        NewExpenseAmountController.text.isNotEmpty) {
      ExpenseItem newExpense = ExpenseItem(
          name: newExpenseNameController.text,
          amount: NewExpenseAmountController.text,
          isExpense: isRecurring, // Saving the boolean value
          dateTime: DateTime.now());
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
      newExpenseNameController.clear();
      NewExpenseAmountController.clear();
      Navigator.pop(context);
    }
  }

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Add New Expense",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
        content: SingleChildScrollView(
          child: Column(
            children: [
              // Expense name
              TextField(
                controller: newExpenseNameController,
                keyboardType: TextInputType.name,
                style: TextStyle(color: Colors.red),
                decoration: InputDecoration(
                    hintText: "Expense Name...",
                    hintStyle: TextStyle(color: Colors.red)),
              ),
              // Expense amount
              TextField(
                controller: NewExpenseAmountController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.red),
                decoration: InputDecoration(
                    hintText: "Rupees...",
                    hintStyle: TextStyle(color: Colors.red)),
              ),
              // Boolean Input (Recurring Expense)
              TextField(
                controller: NewIsExpenseController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.red),
                decoration: InputDecoration(
                    hintText: "isExpense",
                    hintStyle: TextStyle(color: Colors.red)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    onPressed: () {
                      print("${NewIsExpenseController.text} is the data ");
                      print(double.parse(NewIsExpenseController.text) == 0.0);
                      save(double.parse(NewIsExpenseController.text) == 0.0);
                    }, // Pass updated value
                    child: Text("Save"),
                    color: Colors.green[900],
                  ),
                  MaterialButton(
                    onPressed: cancel,
                    child: Text("Cancel"),
                    color: Colors.red[900],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void cancel() {
    newExpenseNameController.clear();
    NewExpenseAmountController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
            expenseSummary(startOfWeek: value.startOfWeekDate()),
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
                    isExpense: value.getAllExpenseList()[index].isExpense,
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
