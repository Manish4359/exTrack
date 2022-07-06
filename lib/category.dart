import 'package:extrack/models/expense.dart';
import 'package:flutter/material.dart';

import './models/expense.dart';

class Category extends StatefulWidget {
  final Map<String, List<Expense>> expenses;
  const Category({Key? key, required this.expenses}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 48, 228, 111),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageTitle(title: "Categories"),
              PageSubtitle(
                subtitle: "Show all categories ",
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFECEBEB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        8,
                      ),
                    ),
                  ),
                ),
                child: CategoryInfo(
                  CategoryName: "Food",
                  type: 'food',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFECEBEB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        8,
                      ),
                    ),
                  ),
                ),
                child: CategoryInfo(
                  CategoryName: "Health",
                  type: 'health',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFECEBEB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        8,
                      ),
                    ),
                  ),
                ),
                child: CategoryInfo(
                  CategoryName: "Entertainment",
                  type: 'entertainment',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFECEBEB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        8,
                      ),
                    ),
                  ),
                ),
                child: CategoryInfo(
                  CategoryName: "Cloth",
                  type: 'cloth',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFECEBEB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        8,
                      ),
                    ),
                  ),
                ),
                child: CategoryInfo(
                  CategoryName: "Others",
                  type: 'others',
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryInfo extends StatelessWidget {
  const CategoryInfo({
    Key? key,
    required this.CategoryName,
    required this.type,
  }) : super(key: key);

  final String CategoryName;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                  ),
                ),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('assets/images/$type.png'),
                      fit: BoxFit.fill,
                    )),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CategoryName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PageSubtitle extends StatelessWidget {
  const PageSubtitle({
    Key? key,
    required this.subtitle,
  }) : super(key: key);

  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  PageTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
