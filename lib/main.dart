import 'dart:core';
import 'dart:io';

import 'package:expenses_app/widgets/chart.dart';
import 'package:expenses_app/widgets/new_Transaction.dart';
import 'package:expenses_app/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/transaction.dart';

void main() 
{/*
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]
  );*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme:ThemeData(
        primaryColor: Colors.purple,accentColor:Colors.redAccent,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(title:TextStyle(fontFamily: 'Opensans',fontSize: 18,fontWeight: FontWeight.bold), button: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(textTheme: ThemeData.light().textTheme.copyWith(title:TextStyle(fontFamily: 'Opensans',fontSize: 20,fontWeight: FontWeight.bold)) )),
        home: MyHomePage(),

    );
  } 
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> transactions = [
  
  ];
  bool _showChart=false;
  List<Transaction> get _recentTransactions{
    return transactions.where((tx){
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }
  void getItem(String title,double amount,DateTime d){
    
    setState(() {
       transactions.add(Transaction(amount: amount,title: title,id:DateTime.now().toString(),date: d));
    });
  }
  void deleteItem(String id){
    setState(() {
    transactions.removeWhere((tx){
      return tx.id==id;
    });
    });
  }
void startNewTransaction(BuildContext ctx){
  showModalBottomSheet(context: ctx, builder: (_){
    return NewTransaction(getItem);
  });
}
  
Widget appBarAndroid(){
  return AppBar(title: Text('Personal Expenses',),actions: <Widget>[IconButton(icon:Icon(Icons.add,),onPressed: (){startNewTransaction(context);}),],);

}
Widget appBarIos(){
  return CupertinoNavigationBar(middle:Text('Personal Expenses'),
trailing:Row(
  mainAxisSize: MainAxisSize.min,
  children:[
  GestureDetector(onTap:(){startNewTransaction(context);} ,child: Icon(CupertinoIcons.add),),
  ]
)
);
}

List<Widget> buildLandscapeContent(MediaQueryData mediaQuery,AppBar appBar,Widget transactionListWidget){
  return [Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Text("Show Chart",style:Theme.of(context).textTheme.title),
              Switch.adaptive(
                activeColor: Theme.of(context).accentColor,
                value: _showChart,onChanged: (value){
                setState(() {
                  _showChart=value;
                });
                
              },)]),
           _showChart?Container(child: Chart(_recentTransactions),height:(mediaQuery.size.height-appBar.preferredSize.height-mediaQuery.padding.top)*0.65)
          :transactionListWidget,
  ];
  
}
List<Widget> buildPortraintContent(MediaQueryData mediaQuery,AppBar appBar,Widget transactionListWidget){
  return [
    Container(child: Chart(_recentTransactions),height: (mediaQuery.size.height-appBar.preferredSize.height-mediaQuery.padding.top)*0.30),
   transactionListWidget

  ];
}
  @override
  Widget build(BuildContext context) {
final mediaQuery= MediaQuery.of(context);
final isLandscape=MediaQuery.of(context).orientation==Orientation.landscape;
final PreferredSizeWidget appBar=Platform.isIOS?appBarIos():appBarAndroid();
final transactionListWidget=Container(child: TransactionList(transactions,deleteItem),height: (mediaQuery.size.height-appBar.preferredSize.height-mediaQuery.padding.top)*0.70);
final body=SafeArea(child:SingleChildScrollView(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if(isLandscape)
              ...buildLandscapeContent(mediaQuery, appBar, transactionListWidget),
           if(!isLandscape)
           ...buildPortraintContent(mediaQuery, appBar, transactionListWidget),

          ],
    )
    ));
    return Platform.isIOS?CupertinoPageScaffold(child: body, navigationBar: appBar,):Scaffold(
        appBar: appBar,
        body: body,
     floatingActionButton:Platform.isIOS?Container(): FloatingActionButton(child:Icon(Icons.add),onPressed: (){startNewTransaction(context);},),
     floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,);
    
  }
}
