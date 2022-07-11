import 'package:extrack/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

import 'package:pie_chart/pie_chart.dart';

import 'models/expense.dart';
import './constant.dart';

class Chart extends StatefulWidget {
  final Map<String, List<Expense>> expenses;
  List<String> categorylist;

  Chart({Key? key, required this.expenses, required this.categorylist})
      : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late double expenseTotal;
  int monthId = int.parse(DateFormat.M().format(DateTime.now()));

  /*bool expanded = false;

  void changeexpanded() {
    setState(() {
      expanded = !expanded;
    });
  }*/

  List<bool> btnSelected = [];

  late Map<String, double> count;

  countMap(List<String> list) {
    Map<String, double> map = {};
    map.addEntries(list.map((String cat) => MapEntry(cat, 0)));
    return map;
  }

  Future<void> getChartDataMap(
      List<String> list, Map<String, double> countMap) async {
    Map<String, double> map = {};
    await Future.forEach(list, (String cat) {
      if (countMap[cat] != 0)
        map.addEntries([MapEntry(cat, countMap[cat] ?? 0)]);
    });
    chartDataMap = map;
  }

  updatedatamap(newdatamap, newtotal) {
    setState(() {
      count = newdatamap;
      expenseTotal = newtotal;
    });
  }

  List<String> months = Constants.MONTHS;
  ScrollController scrolljump = ScrollController();

  void _changeSelectedBtnColor() {
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

  void _goToElement(int index) {
    if (index <= 3) return;
    scrolljump.animateTo(
      (75.0 *
          (index -
              3)), // 100 is the height of container and index of 6th element is 5
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  Map<String, double> chartDataMap = {};

  @override
  Widget build(BuildContext context) {
    count = countMap(widget.categorylist);

    getChartDataMap(widget.categorylist, count);

    print(chartDataMap.isEmpty);
    getChartData(widget.expenses, monthId, updatedatamap, getChartDataMap,
        widget.categorylist);
    Future.delayed(Duration.zero, () => _goToElement(monthId));

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
                      margin: const EdgeInsets.all(5),
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
                              _changeSelectedBtnColor();
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
          FutureBuilder(
            future: getChartDataMap(widget.categorylist, count),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return expenseTotal == 0
                    ? Text('NO EXPENSES FOUND')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            child: PieChart(
                              chartLegendSpacing: 20,
                              ringStrokeWidth: 30,
                              legendOptions: LegendOptions(
                                  // legendShape: BoxShape.rectangle,
                                  showLegendsInRow: true,
                                  legendPosition: LegendPosition.top,
                                  legendTextStyle:
                                      TextStyle(color: Colors.white)),
                              formatChartValues: (double v) =>
                                  '${(v * 100 / expenseTotal).round()}%',
                              chartValuesOptions: ChartValuesOptions(
                                  decimalPlaces: 0,
                                  showChartValuesOutside: true),
                              animationDuration: Duration(seconds: 1),
                              emptyColor: Colors.transparent,
                              dataMap: chartDataMap,
                              chartType: ChartType.ring,
                              centerText: 'Total:\n${expenseTotal.round()}',
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Scrollbar(
                              child: ListView.builder(
                                itemCount: widget.categorylist.length,
                                itemBuilder: (context, id) {
                                  print(widget.categorylist[id] +
                                      " " +
                                      "${chartDataMap.containsKey(widget.categorylist[id])}");

                                  if (chartDataMap
                                      .containsKey(widget.categorylist[id])) {
                                    return getCategoryData(
                                      widget.categorylist[id],
                                      chartDataMap[widget.categorylist[id]],
                                      context,
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      );
              }

              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}

void getChartData(Map<String, List<Expense>> expense, int monthid,
    Function updatedatamap, Function categorytomap, List<String> categorylist) {
  double food = 0;
  double entertainment = 0;
  double cloth = 0;
  double health = 0;
  double others = 0;
  double gift = 0;
  double bills = 0;
  double electronics = 0;
  double travel = 0;
  double shopping = 0;

  expense.forEach(
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
              break;
            case 'gift':
              others += tr.amount;
              break;
            case 'bills':
              bills += tr.amount;
              break;
            case 'electronics':
              electronics += tr.amount;
              break;
            case 'travel':
              travel += tr.amount;
              break;
            case 'shopping':
              shopping += tr.amount;
          }
          return;
        });
      }
    },
  );

  double total = 0;

  print('$food-$others-$cloth-$entertainment');
  Map<String, double> datamap = {
    'food': food,
    'cloth': cloth,
    'entertainment': entertainment,
    'health': health,
    'others': others,
    'gift': gift,
    'electronics': electronics,
    'bills': bills,
    'travel': travel,
    'shopping': shopping
  };
  for (MapEntry<String, double> e in datamap.entries) {
    total += e.value;
  }
  updatedatamap(datamap, total);
}

Widget getCategoryData(type, amount, context) {
  return Container(
    // color: const Color.fromARGB(255, 187, 172, 255),
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: 60,
          width: 60,
          child: Image.asset(
            'assets/images/$type.png',
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width * 0.4,
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
        Container(
          child: Text(
            '₹$amount',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
        /*
        GestureDetector(
          child: Container(
            child: Icon(
              Icons.expand_more_rounded,
              size: 35,
            ),
          ),
          onTap: null,
        ),
        */
      ],
    ),
  );
}
