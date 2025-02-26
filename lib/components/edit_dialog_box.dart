import 'package:flutter/material.dart';
import 'package:flutter_final_exam/controller/expense_controller.dart';
import 'package:flutter_final_exam/modals/expense_modal.dart';
import 'package:get/get.dart';

void showEditExpenseDialog(BuildContext context, Expense expense) {
  final ExpenseController expenseController = Get.find();
  final TextEditingController titleController = TextEditingController(text: expense.title);
  final TextEditingController amountController = TextEditingController(text: expense.amount.toString());
  String category = expense.category;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Expense'),
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
              items: ['Food', 'Transport','Salary','Entertainment', 'Other']
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
              final updatedExpense = Expense(
                id: expense.id,
                title: titleController.text,
                amount: double.parse(amountController.text),
                category: category,
                date: expense.date,
              );
              expenseController.updateExpense(updatedExpense);
              Navigator.pop(context);
            },
            child: Text('Update'),
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
