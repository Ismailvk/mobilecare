import 'package:first_project/database/db/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../widget/appbar.dart';
import '../widget/text_form_field.dart';

class ScreenRevenue extends StatefulWidget {
  ScreenRevenue({super.key, required this.loggeduser});
  final Map<String, dynamic> loggeduser;
  @override
  State<ScreenRevenue> createState() => _ScreenRevenueState();
}

class _ScreenRevenueState extends State<ScreenRevenue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECECEC),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Revenue'),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        toolbarHeight: 110,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipPath(
          clipper: AppbarCustom(),
          child: Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue,
                  Colors.green,
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [CustomTabBar(userData: widget.loggeduser)],
      ),
    );
  }
}

// custom topbar //

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({Key? key, required this.userData});
  final Map<String, dynamic> userData;
  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  List pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      RevenueWidget(userData: widget.userData),
      ScreenStock(logeduser: widget.userData)
    ];
  }

  List<String> items = [
    'Revenue',
    'Stock',
  ];
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        children: [
          SizedBox(
            height: 55,
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      current = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    width: 180, // Adjust the width as per your preference
                    decoration: BoxDecoration(
                      color: current == index
                          ? Color.fromARGB(255, 41, 161, 110)
                          : Color.fromARGB(255, 186, 183, 183),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          items[index],
                          style: TextStyle(
                              color: current == index
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: pages[current],
          )
        ],
      ),
    );
  }
}

//=================== Revenue ====================//
//-----------------------------------------------//

class RevenueWidget extends StatefulWidget {
  RevenueWidget({super.key, required this.userData});
  final Map<String, dynamic> userData;

  @override
  State<RevenueWidget> createState() => _RevenueWidgetState();
}

class _RevenueWidgetState extends State<RevenueWidget> {
  String? valuechoose;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  final formKeys = GlobalKey<FormState>();

  final List<String> listvalue = [
    'Today',
    'Last Month',
    'Custom Range',
  ];
  bool isvisible = false;
  String? revenues;
  String? profits;
  Text hintText = Text('Today');
  String? currentDate;
  String? startDate;
  Map<String, int>? profitAndrevenuelist;
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    todayRevenueAndProfit();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: isvisible == true ? 800 : 600,
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 15),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                height: 55,
                child: DropdownButton<String>(
                  //Drop down widget .......
                  underline: SizedBox(),
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: hintText,
                  ),
                  isExpanded: true,
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FaIcon(FontAwesomeIcons.codeCompare),
                  ),
                  value: valuechoose,
                  items: listvalue.map((String newvalue) {
                    return DropdownMenuItem<String>(
                      // alignment: Alignment.centerRight,
                      value: newvalue,

                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(newvalue),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newvalue) async {
                    // today date
                    currentDate = DateFormat('yyyy/MM/dd').format(today);
                    DateTime startDayofMonth =
                        DateTime(today.year, today.month, 1);
                    startDate =
                        DateFormat('yyyy/MM/dd').format(startDayofMonth);
                    if (newvalue == 'Last Month') {
                      // print('reached');
                      thisMonth();
                    }
                    if (newvalue == 'Today') {
                      todayRevenueAndProfit();
                    }
                    if (newvalue == 'Custom Range') {
                      customDate();
                    }
                    setState(() {
                      valuechoose = newvalue;
                      if (valuechoose == 'Custom Range') {
                        isvisible = true;
                      } else {
                        isvisible = false;
                      }
                    });
                  },
                  //close Drop down
                ),
              ),
            ),
            Visibility(
                visible: isvisible,
                child: Form(
                  key: formKeys,
                  child: Column(
                    children: [
                      TextFormFieldWidget(
                        validator: (value) {
                          if (value == null ||
                              startDateController.text.trim().isEmpty) {
                            return 'Please select your starting date';
                          } else {
                            return null;
                          }
                        },
                        hinttext: 'Start Date',
                        controllerr: startDateController,
                        sufix: true,
                        read: true,
                      ),
                      SizedBox(height: 10),
                      TextFormFieldWidget(
                          read: true,
                          sufix: true,
                          validator: (value) {
                            if (value == null ||
                                endDateController.text.trim().isEmpty) {
                              return 'Please select your date';
                            } else {
                              return null;
                            }
                          },
                          hinttext: 'End Date',
                          controllerr: endDateController),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 41, 161, 110),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: Size(120, 40)),
                        onPressed: () async {
                          if (formKeys.currentState!.validate()) {
                            customDate();
                          }
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  ),
                )),
            ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 195, 231, 216),
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height * .2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, left: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Revenue',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '₹ $revenues',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xFFBC6C25),
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 227, 208, 194),
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height * .2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, left: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profit',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '₹ $profits',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 41, 161, 110),
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Get today revenue and profit

  todayRevenueAndProfit() async {
    profitAndrevenuelist = await DatabaseHelper.instance
        .getRevenueAndProfitForToday(widget.userData['id'], DateTime.now());

    setState(() {
      if (profitAndrevenuelist != null && profitAndrevenuelist!.isNotEmpty) {
        profits = profitAndrevenuelist!['profitAmount'].toString();
        revenues = profitAndrevenuelist!['revenueAmount'].toString();
      }
    });
  }
  // Get this month revenue and profit

  thisMonth() async {
    profitAndrevenuelist = await DatabaseHelper.instance.getRevenueAndProfit(
        userId: widget.userData['id'],
        currentDate: currentDate,
        startDate: startDate);
    // print('profit and revenue list$profitAndrevenuelist');
    setState(() {
      profits = profitAndrevenuelist!['profitAmount'].toString();
      revenues = profitAndrevenuelist!['revenueAmount'].toString();
    });
  }

  customDate() async {
    String startDate = startDateController.text.toString();
    String endDate = endDateController.text.toString();
    profitAndrevenuelist = await DatabaseHelper.instance
        .getCustomRevenueAndProfit(
            userId: widget.userData['id'],
            currentDate: startDate,
            startDate: endDate);
    setState(() {
      if (profitAndrevenuelist != null && profitAndrevenuelist!.isNotEmpty) {
        profits = profitAndrevenuelist!['profitAmount'].toString();
        revenues = profitAndrevenuelist!['revenueAmount'].toString();
      }
    });
  }
}

/// ====================== Stock ======================== //
//-------------------------------------------------------//

class ScreenStock extends StatefulWidget {
  ScreenStock({Key? key, required this.logeduser}) : super(key: key);

  final Map<String, dynamic> logeduser;

  @override
  State<ScreenStock> createState() => _ScreenStockState();
}

class _ScreenStockState extends State<ScreenStock> {
  final stockKey = GlobalKey<FormState>();

  TextEditingController stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: DatabaseHelper.instance
          .getStockAmount(widget.logeduser[DatabaseHelper.usercoloumId]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError || snapshot.data == null) {
          return Text('Error: ${snapshot.error}');
        } else {
          var newStock = snapshot.data;
          print('$newStock is new stock');

          return Padding(
            padding: const EdgeInsets.all(19.0),
            child: Column(
              children: [
                Card(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 200, 249, 241),
                    ),
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * .2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stock',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text('₹ ', style: TextStyle(fontSize: 30)),
                              Text(
                                '${newStock ?? 0}',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 41, 161, 110),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Form(
                  key: stockKey,
                  child: Container(
                      width: 350,
                      height: 51,
                      child: TextFormFieldWidget(
                        validator: (value) {
                          if (value == null ||
                              !RegExp(r'^\d+$').hasMatch(value) ||
                              stockController.text.trim().isEmpty) {
                            print(value);
                            return 'Add your stock amount';
                          } else {
                            return null;
                          }
                        },
                        hinttext: 'Add your stock amount',
                        icon: Icons.money,
                        controllerr: stockController,
                        keybordTypes: true,
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    updateButtonPressed();
                  },
                  child: Text('Update', style: TextStyle(fontSize: 25)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 41, 161, 110),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    side: BorderSide(width: 1, color: Colors.white),
                    minimumSize: Size(200, 50),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }

  updateButtonPressed() async {
    if (stockKey.currentState!.validate()) {
      final tempStock = stockController.text;
      int Stock = int.parse(tempStock);

      final amount = await DatabaseHelper.instance
          .getStockAmount(widget.logeduser[DatabaseHelper.usercoloumId]);

      int newStock = amount + Stock;
      await DatabaseHelper.instance.stockupdate(
          id: widget.logeduser[DatabaseHelper.usercoloumId],
          controllerValue: newStock);
    }
    stockController.text = '';
    setState(() {});
  }
}
