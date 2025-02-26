import 'package:flutter/material.dart';
import 'package:flutter_final_exam/components/category_filtered_colour.dart';
import 'package:flutter_final_exam/components/edit_dialog_box.dart';
import 'package:flutter_final_exam/components/show_add_dialog_box.dart';
import 'package:flutter_final_exam/controller/auth_controller.dart';
import 'package:flutter_final_exam/controller/expense_controller.dart';
import 'package:flutter_final_exam/screens/login_page.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final ExpenseController expenseController = Get.put(ExpenseController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    expenseController.fetchExpenses();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Expense Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              Get.find<AuthController>().logout();
              Get.offAll(() => LoginPage());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search your category...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                ),
                onChanged: (query) {
                  expenseController.searchQuery.value = query;
                },
              ),
            ),
            Expanded(
              child: Obx(() {
                final filteredExpenses = expenseController.filteredExpenses;
                if (filteredExpenses.isEmpty) {
                  return Center(child: Text('No expenses found.'));
                }
                return ListView.builder(
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = filteredExpenses[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        title: Text(
                          expense.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          '\$${expense.amount} on ${expense.date}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        tileColor: getCategoryColor(expense.category),
                        onTap: () {},
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                showEditExpenseDialog(context, expense);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                expenseController.deleteExpense(expense.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddExpenseDialog(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        tooltip: 'Add Expense',
      ),
    );
  }
}
