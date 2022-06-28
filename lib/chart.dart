import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pie_chart/pie_chart.dart';

import './models/transaction.dart';

class Chart extends StatefulWidget {
  final Map<String, List<Transaction>> transactions;

  Chart({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late double expenseTotal;
  int monthId = int.parse(DateFormat.M().format(DateTime.now()));

  List<bool> btnSelected = [];
  List<String> categorylist = [
    'cloth',
    'food',
    'entertainment',
    'health',
    'others'
  ];

  Map<String, double> datamap = {
    'food': 0,
    'cloth': 0,
    'entertainment': 0,
    'health': 0,
    'others': 0
  };

  updatedatamap(newdatamap, newtotal) {
    setState(() {
      datamap = newdatamap;
      expenseTotal = newtotal;
    });
  }

  List<String> months = [
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
  ScrollController scrolljump = ScrollController();

  void changeSelectedBtnColor() {
    setState(() {
      for (int i = 0; i < 12; i++) {
        if (monthId == (i + 1)) {
          btnSelected[i] = true;
        } else
          btnSelected[i] = false;
      }
    });
  }

  _ChartState() {
    for (int i = 0; i < 12; i++) {
      btnSelected.add(false);
    }
    btnSelected[monthId - 1] = true;
  }

  Color selectedColor = Colors.black;

  void goToElement(int index) {
    if (index <= 3) return;
    scrolljump.animateTo(
      (75.0 *
          (index -
              3)), // 100 is the height of container and index of 6th element is 5
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    getChartData(widget.transactions, monthId, updatedatamap);
    Future.delayed(Duration.zero, () => goToElement(monthId));

    print(monthId);

    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40,
            child: ListView(
              controller: scrolljump,
              scrollDirection: Axis.horizontal,
              children: months
                  .map(
                    (String mo) => Container(
                      margin: EdgeInsets.all(5),
                      width: 65,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: btnSelected[months.indexOf(mo)]
                              ? selectedColor
                              : Colors.blue,
                        ),
                        onPressed: () {
                          print("${months.indexOf(mo)} inside");
                          setState(
                            () {
                              monthId = months.indexOf(mo) + 1;
                              changeSelectedBtnColor();
                            },
                          );
                        },
                        child: Text(mo),
                      ),
                    ),
                  )
                  .toList(),
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
              formatChartValues: (double v) =>
                  '${(v * 100 / expenseTotal).round()}%',
              chartValuesOptions: ChartValuesOptions(
                  decimalPlaces: 0, showChartValuesOutside: true),
              animationDuration: Duration(seconds: 1),
              emptyColor: Colors.transparent,
              dataMap: datamap,
              chartType: ChartType.ring,
              centerText: 'Total:\n${expenseTotal.round()}',
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: categorylist.length,
                itemBuilder: (context, id) {
                  if (datamap[categorylist[id]] != 0) {
                    return category(
                        categorylist[id], datamap[categorylist[id]]);
                  } else {
                    return SizedBox();
                  }
                },
              ),
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
  double entertainment = 0;
  double cloth = 0;
  double health = 0;
  double others = 0;

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
            case 'others':
              others += tr.amount;
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

  double total = food + others + cloth + entertainment + health;

  print('$food-$others-$cloth-$entertainment');
  Map<String, double> datamap = {
    'food': food,
    'cloth': cloth,
    'entertainment': entertainment,
    'health': health,
    'others': others
  };
  updatedatamap(datamap, total);
}

Container category(type, amount) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 60,
          width: 60,
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
