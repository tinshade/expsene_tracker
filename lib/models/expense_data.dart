import 'package:expense_tracker/data/hive_database.dart';
import 'package:expense_tracker/datetime/datetime_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//[item, date, amount]
class ExpenseItem {
  final String item;
  final DateTime date;
  final String amount;

  ExpenseItem({
    required this.item,
    required this.date,
    required this.amount,
  });
}

class ExpenseData extends ChangeNotifier {
  //List of all expenses
  List<ExpenseItem> overallExpenseList = [];

  //get expense list
  List<ExpenseItem> getExpenseList() {
    return overallExpenseList;
  }

  final db = HiveDatabase();

  void presentData() {
    //using guard pattern
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  //add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //update expense
  void updateExpense(ExpenseItem existingExpense) {
    debugPrint("WIP");
    // notifyListeners();
    // db.saveData(overallExpenseList);
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //get weekday
  String getDayName(DateTime dateTime) {
    const lookup = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun',
    };
    return lookup[dateTime.weekday].toString();
  }

  //Display from start of week
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      //date (yyyymmdd) : amountTotalForDay
    };

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.date);
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
}
