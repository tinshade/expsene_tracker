import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_data.dart';

class HiveDatabase {
  final _myBox = Hive.box("expense_database");
  void saveData(List<ExpenseItem> allExpense) {
    List<List<dynamic>> allExpenseFormatted = [];
    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.item,
        expense.date,
        expense.amount,
      ];
      allExpenseFormatted.add(expenseFormatted);
    }
    _myBox.put("ALL_EXPENSES", allExpenseFormatted);
  }

  List<ExpenseItem> readData() {
    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      DateTime date = savedExpenses[i][1];
      String amount = savedExpenses[i][2];

      ExpenseItem expense = ExpenseItem(item: name, date: date, amount: amount);
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}
