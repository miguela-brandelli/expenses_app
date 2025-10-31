// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace, prefer_const_constructors

import 'package:expenses_app/ui/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:expenses_app/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;
  final void Function(Transaction) onEdit;

  TransactionList(this.transactions, this.onRemove, this.onEdit);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Container(
                    height: constraints.maxHeight * 0.3,
                    child: Text(
                      'Nenhuma transação cadastrada!',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Container(
                    height: constraints.maxHeight * 0.4,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tr = transactions[index];
              return NewWidget(
                key: GlobalObjectKey(tr),
                tr: tr,
                onEdit: onEdit,
                onRemove: onRemove,
              );
            },
          );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.tr,
    required this.onEdit,
    required this.onRemove,
  });

  final Transaction tr;
  final void Function(Transaction p1) onEdit;
  final void Function(String p1) onRemove;

  @override
  Widget build(BuildContext context) {
    return TranscationItem(tr: tr, onEdit: onEdit, onRemove: onRemove);
  }
}
