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
  List<String> categorylist = [
    'fuel',
    'cloth',
    'food',
    'entertainment',
    'health'
  ];
  double total = 0;

  Map<String, double> datamap = {
    'food': 0,
    'fuel': 0,
    'cloth': 0,
    'entertainment': 0,
    'health': 0
  };

  updatedatamap(newdatamap, newtotal) {
    setState(() {
      datamap = newdatamap;
      total = newtotal;
    });
  }

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
    getChartData(widget.transactions, monthId, updatedatamap);
    return Scaffold(
      // appBar: AppBar(),
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
          Container(
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
              formatChartValues: (double v) => '${(v * 100 / total).round()}%',
              chartValuesOptions: ChartValuesOptions(
                  decimalPlaces: 0, showChartValuesOutside: true),
              animationDuration: Duration(seconds: 1),
              emptyColor: Colors.transparent,
              dataMap: datamap,
              chartType: ChartType.ring,
              centerText: 'Total:\n${total.round()}',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categorylist.length,
              itemBuilder: (context, id) {
                if (datamap[categorylist[id]] != 0) {
                  return category(categorylist[id], datamap[categorylist[id]]);
                } else {
                  return SizedBox();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

void getChartData(Map<String, List<Transaction>> transaction, int monthid,
    Function updatedatamap) {
  double food = 0;
  double fuel = 0;
  double entertainment = 0;
  double cloth = 0;
  double health = 0;

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
              break;
            case 'health':
              health += tr.amount;
          }
          return;
        });
      }
    },
  );

  double total = food + fuel + cloth + entertainment;

  print('$food-$fuel-$cloth-$entertainment');
  Map<String, double> datamap = {
    'food': food,
    'fuel': fuel,
    'cloth': cloth,
    'entertainment': entertainment,
    'health': health
  };
  updatedatamap(datamap, total);
}

Container category(type, amount) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Image.asset(
            'assets/images/$type.png',
          ),
        ),
        Expanded(
          flex: 7,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$type',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                //Text('1 transactions')
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Text(
              '₹$amount',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
        ),
      ],
    ),
  );
}
