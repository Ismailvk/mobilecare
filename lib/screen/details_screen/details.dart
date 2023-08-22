// ignore_for_file: must_be_immutable

import 'package:first_project/database/db/database.dart';
import 'package:first_project/screen/details_screen/show_picture.dart';
import 'package:first_project/screen/widget/choicechips_widget.dart';
import 'package:first_project/screen/widget/dropdown_widget.dart';
import 'package:first_project/screen/widget/text_form_field.dart';
import 'package:first_project/screen/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widget/appbar.dart';

class ScreenDetails extends StatefulWidget {
  const ScreenDetails(
      {super.key,
      required this.userdata,
      required this.customerData,
      required this.valueNotifier});

  final Map<String, dynamic> userdata;
  final Map<String, dynamic> customerData;
  final ValueNotifier valueNotifier;

  @override
  State<ScreenDetails> createState() => _ScreenDetailsState();
}

class _ScreenDetailsState extends State<ScreenDetails> {
  final amountkey = GlobalKey<FormState>();

  TextEditingController spareChargeController = TextEditingController();
  TextEditingController serviceChargeController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  late var total;
  String? comment;
  int? service;
  int? spare;
  int? oldSpare;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper.instance.getinputStatusDetaills(
          widget.customerData[DatabaseHelper.detailscoloumId]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        } else {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Text('No processing data found.');
          }
          List<Map<String, dynamic>>? data = snapshot.data;

          if (data != null && data.isNotEmpty) {
            spare = data[0][DatabaseHelper.coloumSpareAmount];
            oldSpare = data[0][DatabaseHelper.coloumSpareAmount] ?? 0;
            service = data[0][DatabaseHelper.coloumServiceAmount];
            comment = data[0][DatabaseHelper.coloumComment];
            total = (service ?? 0) + (spare ?? 0);

            spareChargeController.text = spare == null ? '' : spare.toString();
            serviceChargeController.text =
                service == null ? '' : service.toString();
            commentController.text = comment ?? '';
          }
          return WillPopScope(
            onWillPop: () async {
              final value = await DatabaseHelper.instance
                  .getStatus(widget.customerData[DatabaseHelper.coloumuserId]);

              if (value == 'Billed') {
                showAlertDialogfor();
                return true;
              } else {
                Navigator.of(context).pop();
                return false;
              }
            },
            child: Scaffold(
              backgroundColor: Color(0xFFECECEC),
              appBar: AppBar(
                centerTitle: true,
                title: Text('Details'),
                leading: InkWell(
                  onTap: () async {
                    // Get the current value of the drop-down

                    final value = await DatabaseHelper.instance.getStatus(
                        widget.customerData[DatabaseHelper.coloumuserId]);

                    if (value == 'Billed') {
                      showAlertDialogfor();
                    } else {
                      Navigator.pop(context, true);
                    }
                    setState(() {});
                  },
                  child: Icon(Icons.arrow_back_ios_new),
                ),
                toolbarHeight: 110,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: ClipPath(
                  clipper: AppbarCustom(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.17,
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
              body: ListView(children: [
                Container(
                  child: Column(
                    children: [
                      Card(
                        color: Colors.transparent,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'Set up methods',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    // color: Colors.amber,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 27,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.white,
                                            child: Icon(Icons.picture_as_pdf),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: -2,
                                            child: CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Colors.blue,
                                              child: Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    width: 60,
                                    // color: Colors.amber,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 27,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.white,
                                            child: IconButton(
                                                icon: Icon(Icons.call),
                                                onPressed: () {
                                                  final String phoneNumber =
                                                      widget.customerData[
                                                          DatabaseHelper
                                                              .coloumPhoneNumber];
                                                  final Uri phoneUri = Uri(
                                                      scheme: 'tel',
                                                      path: phoneNumber);
                                                  launchUrl(phoneUri);
                                                }),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: -2,
                                            child: CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Colors.blue,
                                              child: Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 40,
                                          bottom: 14),
                                      child: Text(
                                        'Name :${widget.customerData[DatabaseHelper.coloumCustomerName]}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 40,
                                          bottom: 14),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          DropButtonWidget(
                                              userdata: widget.customerData),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      height: 165,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextWidget(text1st: 'Device:'),
                                          TextWidget(
                                              text1st:
                                                  '${widget.customerData[DatabaseHelper.coloumDeviceName]}'),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(text1st: 'Condition:'),
                                          TextWidget(
                                              text1st:
                                                  '${widget.customerData[DatabaseHelper.coloumDeviceCondition]}'),
                                          SizedBox(height: 10),
                                          TextWidget(text1st: 'Mob.No:'),
                                          Text(
                                            '${widget.customerData[DatabaseHelper.coloumPhoneNumber]}',
                                            style: TextStyle(
                                                color: Color(0xFFBC6C25)),
                                          ),
                                          SizedBox(height: 10),
                                          TextWidget(
                                              text1st: 'Security code :'),
                                          Text(
                                              '${widget.customerData[DatabaseHelper.coloumSequrityCode]}')
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      height: 125,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          TextWidget(text1st: 'Model:'),
                                          TextWidget(
                                              text1st:
                                                  '${widget.customerData[DatabaseHelper.coloumModelName]}'),
                                          SizedBox(height: 10),
                                          TextWidget(text1st: 'Delivery Date:'),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.date_range_outlined,
                                                size: 20,
                                              ),
                                              Text(
                                                  '${widget.customerData[DatabaseHelper.coloumDeliveryDate]}'),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          TextWidget(text1st: 'Aprx amount :'),
                                          Text(
                                              '${widget.customerData[DatabaseHelper.coloumAmount]}')
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      //  Top card endedd  //

                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 1.06,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 80,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24, horizontal: 20),
                                    child: Text(
                                      '${widget.customerData[DatabaseHelper.coloumServiceRequired]}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 41, 161, 110),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                ),

                                //  Display repaire Endedd  //

                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(14),
                                        ),
                                      ),
                                      child: Container(
                                        width: 140,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFE0F0E9),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 14),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 14,
                                              ),
                                              Icon(
                                                Icons.folder_open_sharp,
                                                size: 45,
                                              ),
                                              Text(
                                                'Total',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20),
                                              ),
                                              Text(
                                                total.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20,
                                                  color: Color(0xFFBC6C25),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    //   Total Amount Card  ended //

                                    InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ScreenShowPicture(
                                                userdata: widget.userdata,
                                                imagepath: widget.customerData[
                                                    DatabaseHelper
                                                        .coloumDeviceImage],
                                              ),
                                            ),
                                          );
                                        },
                                        // deatails page's gridview image . like stack
                                        child: ShowStackImage(
                                            image: widget.customerData[
                                                DatabaseHelper
                                                    .coloumDeviceImage])),
                                    // Photo card endedd   //
                                  ],
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 30, top: 15),
                                  child: TextWidget(text1st: 'Spare used'),
                                ),

                                ChoiceChipsWidget(
                                    inputDetails: widget.customerData),
                                //   choice chips   Endedd  //
                                Form(
                                  key: amountkey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        TextFormFieldWidget(
                                            keybordTypes: true,
                                            labelname: 'Spare amount',
                                            validator: (value) {
                                              if (value!.isEmpty ||
                                                  !RegExp(r"(^(?:[+0]9)?[0-9]{0,12}$)")
                                                      .hasMatch(value)) {
                                                return 'Please add your amount';
                                              } else {
                                                return null;
                                              }
                                            },
                                            hinttext: 'Enter spare charge',
                                            controllerr: spareChargeController),
                                        SizedBox(height: 10),
                                        TextFormFieldWidget(
                                            keybordTypes: true,
                                            labelname: 'Service amount',
                                            validator: (value) {
                                              if (value!.isEmpty ||
                                                  !RegExp(r"(^(?:[+0]9)?[0-9]{0,12}$)")
                                                      .hasMatch(value)) {
                                                return 'Please add your amount';
                                              } else {
                                                return null;
                                              }
                                            },
                                            hinttext: 'Add your service amount',
                                            controllerr:
                                                serviceChargeController),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 41, 161, 110),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              minimumSize: Size(120, 40)),
                                          onPressed: () async {
                                            addYourAmountButton();
                                          },
                                          child: Text('Add your amount'),
                                        ),
                                        SizedBox(height: 10),
                                        TextFormFieldWidget(
                                            validator: (value) {
                                              return null;
                                            },
                                            hinttext: 'Add your comment',
                                            controllerr: commentController),
                                        SizedBox(height: 15),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 41, 161, 110),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              minimumSize: Size(120, 40)),
                                          onPressed: () async {
                                            // Navigator.of(context).pop();
                                            if (amountkey.currentState!
                                                .validate()) {
                                              String comments =
                                                  commentController.text;

                                              await DatabaseHelper.instance
                                                  .updateComment(
                                                      widget.userdata[
                                                          DatabaseHelper
                                                              .detailscoloumId],
                                                      comments);

                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            }
                                          },
                                          child: Text('Add your commend'),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ),
          );
        }
      },
    );
  }

  addYourAmountButton() async {
    if (amountkey.currentState!.validate()) {
      // Convert the amount values to double
      int? spareAmount = int.parse(spareChargeController.text);
      int? serviceAmount = int.parse(serviceChargeController.text);

      // Store the values in the database
      await DatabaseHelper.instance.updateSpareAmount(
          widget.customerData[DatabaseHelper.detailscoloumId], spareAmount);
      // update service amount in database
      await DatabaseHelper.instance.updateServiceAmount(
          widget.customerData[DatabaseHelper.detailscoloumId], serviceAmount);
      // get stock amount in database
      final stockData = await DatabaseHelper.instance
          .getStockAmount(widget.userdata[DatabaseHelper.usercoloumId]);
      final updatedData = stockData - spareAmount;
      // update and decrease stock amount in database (when user add his spare amount)
      await DatabaseHelper.instance.decreseStockAmount(
          id: widget.userdata[DatabaseHelper.usercoloumId],
          updatedStockamount: updatedData);

      int revenue = spareAmount + serviceAmount;

      await DatabaseHelper.instance.updateRevenueamount(
          widget.customerData[DatabaseHelper.detailscoloumId], revenue);
      int profit = serviceAmount;
      await DatabaseHelper.instance.updateprofit(
          widget.customerData[DatabaseHelper.detailscoloumId], profit);
      widget.valueNotifier.value = {
        'profitAmount': profit,
        'revenueAmount': revenue,
      };

      widget.valueNotifier.notifyListeners();
      Navigator.of(context).pop();
    }
  }

  showAlertDialogfor() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Please complete all fields before leaving.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
