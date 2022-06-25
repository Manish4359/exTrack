import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pie_chart/pie_chart.dart';

import './models/transaction.dart';

class Chart extends StatefulWidget {
  final Map<String, List<Transaction>> transactions;

  Chart({Key? key, required this.transactions}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  int monthId = 6;
  List<String> category = ['fuel', 'cloth', 'food', 'entertainment'];
  int totalFuel = 0;

  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40,
            child: ListView.builder(
              itemCount: 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, index) {
                return Row(
                  children: months
                      .map(
                        (mo) => Container(
                          margin: EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(
                                () {
                                  monthId = months.indexOf(mo) + 1;
                                  print(monthId);
                                },
                              );
                            },
                            child: Text(mo),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
          GestureDetector(
            child: Container(
              height: 190,
              padding: EdgeInsets.all(25),
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 234, 234, 234),
              ),
              child: PieChart(
                ringStrokeWidth: 30,
                //legendOptions: LegendOptions(),
                formatChartValues: (double v) => '${v.round()}%',
                chartValuesOptions: ChartValuesOptions(
                    decimalPlaces: 0, showChartValuesOutside: true),
                animationDuration: Duration(seconds: 1),
                emptyColor: Colors.transparent,
                dataMap: getChartData(widget.transactions, monthId),
                chartType: ChartType.ring,
                centerText: 'Total:5000',
              ),
            ),
          ),
          //Expanded(child: ListView.builder(itemBuilder: (context, index) => {}))
          Container(
            //height: 100,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            color: Color.fromARGB(255, 255, 223, 220),
            child: Row(
              children: [
                Expanded(
                  child: Text('icon'),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'title',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text('date')
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    //margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    //height: double,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      //borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '₹501',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Map<String, double> getChartData(
    Map<String, List<Transaction>> transaction, int monthid) {
  double food = 0;
  double fuel = 0;
  double entertainment = 0;
  double cloth = 0;

  transaction.forEach(
    (k, v) {
      int month = DateFormat('M/dd/yy').parse(k).month;
      //print(DateFormat('M/dd/yy').parse(k).month);

      if (monthid == month) {
        v.forEach((tr) {
          switch (tr.category) {
            case 'food':
              food += tr.amount;
              break;
            case 'fuel':
              fuel += tr.amount;
              break;
            case 'entertainment':
              entertainment += tr.amount;
              break;
            case 'cloth':
              cloth += tr.amount;
          }
          return;
        });
      }
    },
  );
  double total = food + fuel + cloth + entertainment;
  print('$food-$fuel-$cloth-$entertainment');
  return {
    'food': food * 100 / total,
    'fuel': fuel * 100 / total,
    'cloth': cloth * 100 / total,
    'entertainment': entertainment * 100 / total
  };
}
