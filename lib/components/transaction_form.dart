// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionsForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;
  final Transaction? transactionToEdit; 

  TransactionsForm(this.onSubmit, {this.transactionToEdit});

  @override
  State<TransactionsForm> createState() => _TransactionsFormState();
}

class _TransactionsFormState extends State<TransactionsForm> {
  final titleController = TextEditingController();
  final valueController = TextEditingController();
  final _dateController = TextEditingController(); 
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.transactionToEdit != null) {
      final transaction = widget.transactionToEdit!;
      titleController.text = transaction.title;
      valueController.text = transaction.value.toStringAsFixed(2);
      _selectedDate = transaction.date;
      _dateController.text = DateFormat('dd/MM/yyyy').format(transaction.date);
    }
  }

  void _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    valueController.dispose();
    _dateController.dispose(); 
    super.dispose();
  }

  _submitForm() {
    final title = titleController.text.trim();
    final value =
        double.tryParse(valueController.text.replaceAll(',', '.')) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preencha todos os campos corretamente.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    widget.onSubmit(title, value, _selectedDate!);

    // Limpa os campos após o envio
    titleController.clear();
    valueController.clear();
    _dateController.clear();
    setState(() {
      _selectedDate = null; 
    });

    // Remove o foco dos campos
    FocusScope.of(context).unfocus();

    final message = widget.transactionToEdit != null 
        ? 'Transação editada com sucesso!' 
        : 'Transação adicionada com sucesso!';
        
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 20,
          right: 20,
          left: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              onSubmitted: (_) => _submitForm(),
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: valueController,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: false),
              onSubmitted: (_) => _submitForm(),
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
                border: OutlineInputBorder(),
                prefixText: 'R\$ ',
              ),
            ),
            SizedBox(height: 10), 
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: _showDatePicker,
              decoration: InputDecoration(
                labelText: 'Data (dd/MM/yyyy)',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _showDatePicker,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(widget.transactionToEdit != null 
                      ? 'Salvar Alterações' 
                      : 'Adicionar Transação'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}