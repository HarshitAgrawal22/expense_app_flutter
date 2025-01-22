// This is the model for the expenses we are creating
class ExpenseItem {
  final String name;
  final String amount;
  final DateTime dateTime;
  final String task;

  ExpenseItem(
      {required this.name,
      required this.task,
      required this.amount,
      required this.dateTime});
  @override
  String toString() {
    // TODO: implement toString
    return "${this.amount}    ${this.task}      ${this.amount}       ${this.dateTime} ";
  }
}
