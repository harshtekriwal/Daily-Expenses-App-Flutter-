import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chartbar.dart';

class Chart extends StatelessWidget {

final List<Transaction> recentTransactions;
Chart(this.recentTransactions);
  List<Map<String,Object>> get groupedTransactionValues{
    return List.generate(7 , (index){
      final weekDay=DateTime.now().subtract(Duration(days:index),);
      double totalSum=0.0;
      for(int i=0;i<recentTransactions.length;i++){
        if(recentTransactions[i].date.day == weekDay.day && recentTransactions[i].date.month == weekDay.month && recentTransactions[i].date.year == weekDay.year)
        totalSum=totalSum+recentTransactions[i].amount;
      }
      return {'day':DateFormat.E().format(weekDay).substring(0,1),'amount':totalSum};
    }).reversed.toList();
  }
  
  double get maxSpending{
    double sum=0.0;
    for(int i=0;i<recentTransactions.length;i++){
      sum+=recentTransactions[i].amount;
    }
    return sum;
  }
  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      elevation:6,
      margin: EdgeInsets.all(25),
      child:Container(
        padding: EdgeInsets.all(10),
        child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[...groupedTransactionValues.map((data){
          return Flexible(fit:FlexFit.tight,child: ChartBar(data['day'],data['amount'],maxSpending==0?0:(data['amount'] as double) / maxSpending));
        }).toList(),
        ]      
        
      )

      
    ) )  ;
  }
}