import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/components/expense_tile.dart';
import 'package:expense_tracker/datetime/datetime_helper.dart';
import 'package:expense_tracker/models/expense_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Text Controllers for input
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).presentData();
  }

  //Adding new expese
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Expense'),
        elevation: 50,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Expense Title
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(hintText: "What was it for?"),
              textCapitalization: TextCapitalization.sentences,
            ),

            //Expense Amount
            TextField(
              controller: newExpenseAmountController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: "How much did you spend?"),
            )
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  //Delet an expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  //Save adds stuff to the ExpenseData
  void save() {
    ExpenseItem newExpense = ExpenseItem(
        item: newExpenseNameController.text,
        date: DateTime.now(),
        amount: newExpenseAmountController.text);
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    clearControllers();
    Navigator.pop(context);
  }

  //Cancel
  void cancel() {
    Navigator.pop(context);
    clearControllers();
  }

  //Clear Controllers
  void clearControllers() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
        builder: ((context, value, child) => Scaffold(
            backgroundColor: Colors.grey[300],
            floatingActionButton: FloatingActionButton(
              onPressed: addNewExpense,
              backgroundColor: Colors.black,
              child: const Icon(Icons.add),
            ),
            body: Column(
              children: [
                //Weekly Expenditure Graph
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ExpenseSummary(startOfWeek: value.startOfWeekDate()),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Divider(
                    height: 2.0,
                    color: Colors.grey,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      listOfExpenses(value, deleteExpense),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 55),
                  child: Text(''),
                ),
              ],
            ))));
  }
}

Widget listOfExpenses(ExpenseData value, Function deleteExpense) {
  if (value.getExpenseList().isNotEmpty) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: value.getExpenseList().length,
        itemBuilder: (context, index) => ExpenseTile(
              name: value.getExpenseList()[index].item,
              date: dateDisplayFormat(value.getExpenseList()[index].date),
              amount: '\$${value.getExpenseList()[index].amount}',
              deleteTapped: ((p0) =>
                  deleteExpense(value.getExpenseList()[index])),
            ));
  } else {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/nothing.png',
            scale: 3,
          ),
        ),
        const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ],
    );
  }
}
