import 'dart:io';
import 'package:first_project/database/db/database.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final String name;
  final String? image;
  final String device;
  final String date;
  final Map<String, dynamic> userdata;
  final Map<String, dynamic> customerData;

  CardWidget(
      {super.key,
      required this.name,
      required this.image,
      required this.device,
      required this.date,
      required this.userdata,
      required this.customerData});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      File(widget.image.toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Name: ${widget.name}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        // DropButtonWidget(),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/star.png',
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 5),
                        Text('Device: ${widget.device}',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 3),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month),
                          Text(widget.date),
                        ],
                      ),
                    ),
                    Container(
                      width: 125,
                      height: 40,
                      child: Card(
                        color: Color.fromARGB(255, 227, 216, 247),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.asset('assets/images/star.png',
                                  height: 20, width: 20),
                              Text(
                                '${widget.customerData[DatabaseHelper.coloumStatus]}',
                                style: TextStyle(
                                    color: Colors.deepPurple.shade400),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
