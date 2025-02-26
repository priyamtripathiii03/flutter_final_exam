import 'package:flutter/material.dart';
import 'package:flutter_final_exam/controller/expense_controller.dart';
import 'package:flutter_final_exam/modals/expense_modal.dart';
import 'package:get/get.dart';

void showAddExpenseDialog(BuildContext context) {
  final ExpenseController expenseController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String category = 'Food';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Expense Title'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: category,
              items: ['Food', 'Transport','Salary', 'Entertainment', 'Other']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                category = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newExpense = Expense(
                title: titleController.text,
                amount: double.parse(amountController.text),
                category: category,
                date: DateTime.now().toString(),
              );
              expenseController.addExpense(newExpense);
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}
