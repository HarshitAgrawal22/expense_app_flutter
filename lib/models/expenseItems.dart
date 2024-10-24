// This is the model for the expenses we are creating
class ExpenseItem {
  final String name;
  final String amount;
  final DateTime dateTime;
  final bool isExpense;

  ExpenseItem(
      {required this.name,
      required this.isExpense,
      required this.amount,
      required this.dateTime});
  @override
  String toString() {
    // TODO: implement toString
    return "${this.amount}    ${this.isExpense}      ${this.amount}       ${this.dateTime} ";
  }
}
