// ignore_for_file: use_super_parameters, sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'ui/widgets/transaction_form.dart';
import 'components/transaction_list.dart';
import 'ui/widgets/chart.dart';
import 'models/transaction.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const ExpensesApp()));
}

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.grey,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
        fontFamily: 'MozillaHeadline',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: const TextStyle(
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
    final today = DateTime.now();
    final sevenDaysAgo = today.subtract(const Duration(days: 6));

    return _transactions.where((tr) {
      final trDate = DateTime(tr.date.year, tr.date.month, tr.date.day);
      return trDate.isAfter(sevenDaysAgo.subtract(const Duration(days: 1)));
    }).toList();
  }

  void _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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
      const SnackBar(
        content: Text('Transação removida com sucesso!'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openTransactionFormModal(BuildContext context,
      {Transaction? transactionToEdit}) {
    showModalBottomSheet(
      isScrollControlled: true, // permite abrir melhor com teclado
      context: context,
      builder: (_) {
        if (transactionToEdit != null) {
          return TransactionsForm(
            (title, value, date) =>
                _updateTransaction(title, value, date, transactionToEdit.id),
            transactionToEdit: transactionToEdit,
          );
        } else {
          return TransactionsForm(_addTransaction);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      leading: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0.0, 8.0),
        child: Image.asset(
          'assets/images/app_icon.ico',
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        'Despesas Pessoais',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontFamily: 'MozillaHeadline',
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context),
        ),
        if (isLandscape)
          IconButton(
            icon: Icon(_showChart ? Icons.list : Icons.show_chart),
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            },
          ),
      ],
    );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) ...[
              _showChart
                  ? SizedBox(
                      height: availableHeight * 0.5,
                      child: Chart(_recentTransactions),
                    )
                  : SizedBox(
                      height: availableHeight * 0.5,
                      child: TransactionList(
                          _transactions, _removeTransaction, _editTransaction),
                    ),
            ] else ...[
              SizedBox(
                height: availableHeight * 0.3,
                child: Chart(_recentTransactions),
              ),
              SizedBox(
                height: availableHeight * 0.5,
                child: TransactionList(
                    _transactions, _removeTransaction, _editTransaction),
              ),
            ]
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
