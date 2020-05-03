import 'dart:io';

import 'package:expenses_app/widgets/adaptiveflatbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;
  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titlecontroller = TextEditingController();
  DateTime date;
  final amountcontroller = TextEditingController();

  void onSubmit() {
    if(amountcontroller.text.isEmpty){
      return;
    }
    String title = titlecontroller.text;
    double amount = double.parse(amountcontroller.text);
    if (title.isEmpty || amount <= 0|| date==null) {
      return;
    }
    widget.addTransaction(title, amount,date);
    Navigator.of(context).pop();
  }
  void datePicker(){
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now()).then((pickedDate){
      if(pickedDate==null){
        return;
      }
      else{
        setState(() {
         date=pickedDate;
        });
      }
    })
    ;}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child:Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top:10,
            left:10,
            right:10,
            bottom: MediaQuery.of(context).viewInsets.bottom+10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Title:"),
                controller: titlecontroller,
                
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount:"),
                keyboardType: TextInputType.number,
                controller: amountcontroller,
                
              ),
              Container(
                height: 70,
                child: Row(children: <Widget>[
                  Expanded(child: Text(date==null?'No Date Chosen!':'Picked Date : ${DateFormat.yMd().format(date)}')),
                  AdaptiveFlatButton("Choose Date",datePicker),
                ],),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text("Add Transaction",style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).textTheme.button.color)),
                onPressed: () {
                  onSubmit();
                },
                textColor: Theme.of(context).primaryColor,
              )
            ],  
          ),
        ))
    );
  }
}
