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

  void save(String task) {
    if (newExpenseNameController.text.isNotEmpty &&
        NewExpenseAmountController.text.isNotEmpty) {
      ExpenseItem newExpense = ExpenseItem(
          name: newExpenseNameController.text,
          amount: NewExpenseAmountController.text,
          task: task, // Saving the boolean value
          dateTime: DateTime.now());
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
      newExpenseNameController.clear();
      NewExpenseAmountController.clear();
      Navigator.pop(context);
    }
  }

  String? selectedOption;
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
              // TextField(
              //   controller: NewIsExpenseController,
              //   keyboardType: TextInputType.number,
              //   style: TextStyle(color: Colors.red),
              //   decoration: InputDecoration(
              //       hintText: "isExpense",
              //       hintStyle: TextStyle(color: Colors.red)),
              // ),
              DropdownButton<String>(
                borderRadius: BorderRadius.circular(12),
                value: selectedOption,
                hint: Text(
                  "Select an option",
                  style: TextStyle(color: Colors.red),
                ), // Placeholder text
                items: <String>['expense', 'credit', 'borrowed', "lent"]
                    .map((String value1) {
                  return DropdownMenuItem<String>(
                    value: value1,
                    child: Text(
                      value1.toUpperCase(),
                      style: TextStyle(
                          letterSpacing:
                              MediaQuery.sizeOf(context).width / 100),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue; // Update the selected value
                  });
                },
                dropdownColor:
                    Colors.grey[600], // Background color of the dropdown
                icon: Icon(Icons.arrow_drop_down), // Dropdown icon
                style:
                    TextStyle(color: Colors.yellow, fontSize: 16), // Text style
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    onPressed: () {
                      save(selectedOption!);
                      selectedOption = null;
                    }, // Pass updated value
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green[700],
                  ),
                  MaterialButton(
                    onPressed: cancel,
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
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
          backgroundColor: Colors.yellow,
        ),
        body: ListView(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 20,
            ),
            expenseSummary(startOfWeek: value.startOfWeekDate()),
          ],
        ),
      ),
    );
  }
}
