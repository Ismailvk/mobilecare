import 'dart:io';
import 'package:fade_scroll_app_bar/fade_scroll_app_bar.dart';
import 'package:first_project/database/db/database.dart';
import 'package:first_project/screen/page_view/page1.dart';
import 'package:first_project/screen/page_view/page2.dart';
import 'package:first_project/screen/add_screen/add_screen.dart';
import 'package:first_project/screen/home_screen/billed.dart';
import 'package:first_project/screen/home_screen/finished.dart';
import 'package:first_project/screen/home_screen/processing.dart';
import 'package:first_project/screen/home_screen/search.dart';
import 'package:first_project/screen/home_screen/show_all.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'drawer.dart';
import 'not_required.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key, required this.loggeduser});

  final Map<String, dynamic> loggeduser;
  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<Map> profitAndRevenueNotifier = ValueNotifier({});
  List<Widget> pages = [];

  List<String> items = [
    'Show All',
    'Processing',
    'Finished',
    'Billed',
    'Not Repaired',
  ];
  int current = 0;
  final _pageController = PageController();
  File? image;

  @override
  void initState() {
    super.initState();
    pages = [
      ScreenShowAll(
          userdata: widget.loggeduser,
          profitAndRevenueNotifier: profitAndRevenueNotifier),
      ScreenProcessing(
          userdata: widget.loggeduser,
          profitAndRevenueNotifier: profitAndRevenueNotifier),
      ScreenFinished(
          userdata: widget.loggeduser,
          profitAndRevenueNotifier: profitAndRevenueNotifier),
      ScreenBilled(
          userdata: widget.loggeduser,
          profitAndRevenueNotifier: profitAndRevenueNotifier),
      ScreenNotRequired(
          loggeduser: widget.loggeduser,
          profitAndRevenueNotifier: profitAndRevenueNotifier)
    ];
    final imagePath = widget.loggeduser[DatabaseHelper.coloumImage];
    image = imagePath != null ? File(imagePath) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          drawerTheme: DrawerThemeData(
              backgroundColor: Color.fromARGB(255, 192, 192, 190))),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 41, 161, 110),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => ScreenAdd(
                      userData: widget.loggeduser,
                    )));
          },
          child: Icon(Icons.add),
        ),
        body: FadeScrollAppBar(
          appBarActions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                // Use either AssetImage or FileImage based on the image type
                backgroundImage: image == null
                    ? AssetImage('assets/images/user.png')
                    : FileImage(image!) as ImageProvider<Object>,
                radius: 20,
              ),
            ),
          ],
          scrollController: _scrollController,
          appBarLeading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu),
              );
            },
          ),
          appBarTitle:
              Text('Welcome , ${widget.loggeduser[DatabaseHelper.coloumName]}'),
          appBarForegroundColor: Colors.black,
          pinned: true,
          fadeOffset: 120,
          expandedHeight: 400,
          backgroundColor: Colors.white,
          fadeWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Container(
                height: 70,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 0.7, // Spread radius
                      blurRadius: 40, // Blur radius
                      offset: Offset(0, 4), // Offset in the y-axis
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ScrreenSearch(loggeduser: widget.loggeduser)));
                    },
                    decoration: InputDecoration(
                      hintText: 'Search here',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      child: PageView(
                        controller: _pageController,
                        children: [
                          page1(
                              loggeduser: widget.loggeduser,
                              profitAndRevenueNotifier:
                                  profitAndRevenueNotifier),
                          page2(loggeduser: widget.loggeduser)
                        ],
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: 2,
                    )
                  ],
                ),
              ),
            ],
          ),
          bottomWidgetHeight: 60,
          bottomWidget: Container(
            height: 60,
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
                          margin: EdgeInsets.all(5),
                          width: 100, // Adjust the width as per your preference
                          decoration: BoxDecoration(
                            color: current == index
                                ? Color.fromARGB(255, 41, 161, 110)
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                items[index],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: pages[current], // Use the selected page
          ),
        ),
        drawer: NavBar(logeduser: widget.loggeduser),
      ),
    );
  }
}
