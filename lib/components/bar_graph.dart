import 'package:expense_app/models/expenseItems.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyGraph extends StatelessWidget {
  final double? maxY;
  final List<ExpenseItem> sunExpenses;
  final List<ExpenseItem> monExpenses;
  final List<ExpenseItem> tueExpenses;
  final List<ExpenseItem> wedExpenses;
  final List<ExpenseItem> thuExpenses;
  final List<ExpenseItem> friExpenses;
  final List<ExpenseItem> satExpenses;

  const MyGraph(
      {super.key,
      required this.maxY,
      required this.sunExpenses,
      required this.monExpenses,
      required this.tueExpenses,
      required this.wedExpenses,
      required this.thuExpenses,
      required this.friExpenses,
      required this.satExpenses});

  @override
  Widget build(BuildContext context) {
    // Define the colors for different expenses
    List<Color> expenseColors = [
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.red,
    ];

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        titlesData: FlTitlesData(
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles:
                SideTitles(showTitles: true, getTitlesWidget: getBottomTitles),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),

        // Create the bars with segmented colors for each expense
        barGroups: [
          createBarGroup(context, 0, sunExpenses, expenseColors),
          createBarGroup(context, 1, monExpenses, expenseColors),
          createBarGroup(context, 2, tueExpenses, expenseColors),
          createBarGroup(context, 3, wedExpenses, expenseColors),
          createBarGroup(context, 4, thuExpenses, expenseColors),
          createBarGroup(context, 5, friExpenses, expenseColors),
          createBarGroup(context, 6, satExpenses, expenseColors),
        ],
      ),
    );
  }

  // This method creates a BarChartGroupData with multiple BarChartRodData for each expense
  BarChartGroupData createBarGroup(BuildContext context, int x,
      List<ExpenseItem> expenses, List<Color> colors) {
    // To track the cumulative height of expenses

    return BarChartGroupData(
      x: x,
      barRods: expenses.asMap().entries.map((entry) {
        int index = entry.key;
        double expense = double.parse(entry.value.amount);

        return BarChartRodData(
          toY: expense,
          color: entry.value.isExpense ? Colors.red : Colors.green,

          //  colors[           index % colors.length], // Use a different color for each expense
          width: MediaQuery.sizeOf(context).width /
              100, // Width of the bar (can adjust)
          borderRadius: BorderRadius.zero,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            color: Colors.grey[700],
            toY: maxY,
          ),
        );
      }).toList(),
    );
  }

  // Bottom titles (days of the week)
  Widget getBottomTitles(double value, TitleMeta meta) {
    const TextStyle style = TextStyle(
        color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12);
    Widget text;

    switch (value.toInt()) {
      case 0:
        text = const Text("Sun", style: style);
        break;
      case 1:
        text = const Text("Mon", style: style);
        break;
      case 2:
        text = const Text("Tue", style: style);
        break;
      case 3:
        text = const Text("Wed", style: style);
        break;
      case 4:
        text = const Text("Thu", style: style);
        break;
      case 5:
        text = const Text("Fri", style: style);
        break;
      case 6:
        text = const Text("Sat", style: style);
        break;
      default:
        text = const Text("", style: style);
        break;
    }

    return SideTitleWidget(
      child: text,
      axisSide: meta.axisSide,
    );
  }
}
