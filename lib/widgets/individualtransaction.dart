import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IndividualTransaction extends StatelessWidget {
   IndividualTransaction({
    Key key,
    @required this.transaction,
    @required this.deleteItem,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      
        elevation: 5,
      margin: EdgeInsets.symmetric(vertical:8,horizontal:5),
        child: ListTile(
          leading:CircleAvatar(backgroundColor: Theme.of(context).primaryColor,radius: 30,child:Padding(padding: EdgeInsets.all(6),child: FittedBox(child: Text('\$${transaction.amount}'))),),
          title: Text(transaction.title,),
          subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
          trailing:
          MediaQuery.of(context).size.width>470?
          FlatButton.icon(icon:Icon(Icons.delete),onPressed: (){deleteItem(transaction.id);},textColor:Theme.of(context).errorColor,label:Text("Delete item"),):
          IconButton(icon: Icon(Icons.delete), onPressed: (){deleteItem(transaction.id);},color: Theme.of(context).errorColor,)
    ));
  }
}