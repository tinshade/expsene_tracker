import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String date;
  final String amount;
  final Function(BuildContext)? deleteTapped;

  const ExpenseTile(
      {super.key,
      required this.name,
      required this.date,
      required this.amount,
      required this.deleteTapped});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: deleteTapped,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(4),
          )
        ],
      ),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(date),
        trailing: Text(amount),
      ),
    );
  }
}
