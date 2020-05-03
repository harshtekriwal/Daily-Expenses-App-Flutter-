import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'individualtransaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteItem;
  TransactionList(this.transactions,this.deleteItem);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty?LayoutBuilder(builder: (ctx,constrains){
      return Column(
          children: <Widget>[
            Text('No transactions added yet!',style: Theme.of(context).textTheme.title,),
            SizedBox(height: 50,),
            Container(height:constrains.maxHeight*0.60,child: Image.asset('assets/images/waiting.png',fit: BoxFit.cover,))
            
          ],
        );
    },):ListView.builder(
          itemBuilder: (ctx, index) {
            return IndividualTransaction(transaction: transactions[index], deleteItem: deleteItem);
          },
          itemCount: transactions.length,
        );
  }
}


