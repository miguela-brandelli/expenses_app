import 'dart:math';

import 'package:flutter/material.dart';
import 'package:expenses_app/models/transaction.dart';
import 'package:intl/intl.dart';

class TranscationItem extends StatefulWidget {
  final Transaction tr;
  final void Function(Transaction p1) onEdit;
  final void Function(String p1) onRemove;

  const TranscationItem({
    super.key,
    required this.tr,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  State<TranscationItem> createState() => _TranscationItemState();
}

class _TranscationItemState extends State<TranscationItem> {

  static const colors = [
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.blue,
    Colors.black,
  ];

  late Color _backgroundColor;
  
  @override
  void initState() {
    super.initState(); 
    int i = Random().nextInt(5);
    _backgroundColor = colors[i];
  }

  @override
  Widget build(BuildContext context) {
    final tr = widget.tr;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _backgroundColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: FittedBox(
              child: Text('R\$${tr.value.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          tr.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat('d MMM y').format(tr.date),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => widget.onEdit(tr),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Excluir Transação'),
                      content:
                          Text('Tem certeza que deseja excluir "${tr.title}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.onRemove(tr.id);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Excluir',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
