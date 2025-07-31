import 'package:flutter/material.dart';

class TransactionsForm extends StatelessWidget {
  final titleController = TextEditingController();
  final valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
              ),
            ),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text(
                    'Nova Transação',
                    style: TextStyle(
                    color: Color.fromARGB(255, 125, 3, 240),
                    ),
                  ),
                  onPressed: () {
                    print(titleController.text);
                    print(valueController.text);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
