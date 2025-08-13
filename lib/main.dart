// ignore_for_file: use_super_parameters, sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'components/chart.dart';

import 'models/transaction.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(ExpensesApp()));
}

class ExpensesApp extends StatelessWidget {
  ExpensesApp({Key? key}) : super(key: key);
  final ThemeData tema = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.grey,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
        fontFamily: 'MozillaHeadline',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: TextStyle(
                fontFamily: 'MozillaHeadline',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: const TextStyle(
            fontFamily: 'MozillaHeadline',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.indigoAccent,
          ),
          toolbarTextStyle: ThemeData.light().textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  bool get _hasRecentTransactions {
    return _recentTransactions.isNotEmpty;
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  void _editTransaction(Transaction transaction) {
    _openTransactionFormModal(context, transactionToEdit: transaction);
  }

  void _updateTransaction(
      String title, double value, DateTime date, String id) {
    setState(() {
      final index = _transactions.indexWhere((tr) => tr.id == id);
      if (index >= 0) {
        _transactions[index] = Transaction(
          id: id,
          title: title,
          value: value,
          date: date,
        );
      }
    });

    Navigator.of(context).pop();
  }

  void _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((transaction) => transaction.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transação removida com sucesso!'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  _openTransactionFormModal(BuildContext context,
      {Transaction? transactionToEdit}) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        if (transactionToEdit != null) {
          return TransactionsForm(
            (title, value, date) =>
                _updateTransaction(title, value, date, transactionToEdit.id),
            transactionToEdit: transactionToEdit,
          );
        } else {
          // Modo criação - função que adiciona
          return TransactionsForm(_addTransaction);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Despesas Pessoais',
          style: TextStyle(
              fontSize: 10 * MediaQuery.textScalerOf(context).scale(2))),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context),
        ),
      ],
    );
    final availableHeight =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;
    -MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Exibir Gráfico'),
                Switch(
                  value: _showChart,
                  onChanged: (value) {
                    setState(() {
                      _showChart = value;
                    });
                  },
                  activeColor: 
                      Colors.indigo,
                  activeTrackColor:
                      Colors.indigo[100], 
                  inactiveThumbColor:
                      Colors.grey, 
                  inactiveTrackColor:
                      Colors.grey[300],
                ),
              ],
            ),
            _showChart
                ? Container(
                    height: availableHeight * 0.3,
                    child: Chart(_recentTransactions))
                : Container(
                    height: availableHeight * 0.5,
                    child: TransactionList(
                        _transactions, _removeTransaction, _editTransaction),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
