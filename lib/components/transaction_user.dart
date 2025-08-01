// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';
import 'transactions_form.dart';
import 'transaction_list.dart';
import '../models/transaction.dart';

class TransactionUser extends StatefulWidget{
  @override
  _TransactionUserState createState() => _TransactionUserState();
}

class _TransactionUserState extends State<TransactionUser> {
   final _transactions = [
    Transaction(
      id: 't1',
      title: 'Novo Tênis de Corrida',
      value: 310.76,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Conta de Supermercado',
      value: 211.30,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'Combustível',
      value: 600.00,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'Jogos Steam',
      value: 110.00,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't5',
      title: 'CDs de Música',
      value: 45.50,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't6',
      title: 'Aluguel de Filme',
      value: 15.00,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't7',
      title: 'Assinatura de Streaming',
      value: 29.90,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't8',
      title: 'Livros Digitais',
      value: 75.00,
      date: DateTime.now(),
    ),
  ];

  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _transactions.add(newTransaction);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TransactionList(_transactions),
        TransactionsForm(_addTransaction),
      ],
    );
  }
}