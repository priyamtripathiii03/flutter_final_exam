import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_final_exam/modals/expense_modal.dart';
import 'package:flutter_final_exam/services/db_services.dart';
import 'package:get/get.dart';

class ExpenseController extends GetxController {
  var expenses = <Expense>[].obs;
  var searchQuery = ''.obs;

  // Fetch expenses
  void fetchExpenses() async {
    expenses.value = await DbServices.dbServices.getAllExpenses();
  }

  // Add expense
  Future<void> addExpense(Expense expense) async {
    await DbServices.dbServices.insertExpense(expense);
    fetchExpenses();
    await syncWithFirestore();
  }

  // Update expense
  Future<void> updateExpense(Expense expense) async {
    await DbServices.dbServices.updateExpense(expense);
    fetchExpenses();
    await syncWithFirestore();
  }

  // Delete expense
  Future<void> deleteExpense(int id) async {
    await DbServices.dbServices.deleteExpense(id);
    fetchExpenses();
    await syncWithFirestore();
  }

  // Sync expense in Firestore
  Future<void> syncWithFirestore() async {
    for (var expense in expenses) {
      await FirebaseFirestore.instance.collection('expenses').doc(expense.id.toString()).set(expense.toMap());
    }
  }

  // Filter expenses for search
  List<Expense> get filteredExpenses {
    if (searchQuery.value.isEmpty) return expenses;
    return expenses.where((expense) => expense.title.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
  }
}
