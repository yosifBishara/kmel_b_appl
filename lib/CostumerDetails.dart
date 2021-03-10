import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kmel_bishara_app/myFirestore.dart';
import 'dart:async';
import 'Appointment.dart';
import 'Notifications.dart';
import 'myFirestore.dart';
import 'package:flutter/services.dart';




class CostumerDet extends StatefulWidget {
  @override
  _CostumerDetState createState() => _CostumerDetState();
}

class _CostumerDetState extends State<CostumerDet> {

  FireHelper db = FireHelper();
  LocalNotification _lNf = LocalNotification.ass();
  final _formKey = GlobalKey<FormState>();
  final controlName = TextEditingController(),controlNum = TextEditingController();
  String dropDownValue1,dropDownValue2,dropDownValue3,nameField,phoneField;
  DateTime today = DateTime.now();
  List<String> weekDays = ['ראשון',' ','שלישי','רביעי','חמישי','שישי','שבת',
    'ראשון',' ','שלישי','רביעי','חמישי','שישי','שבת'];
  List<String> hours = [
    '13:00',
    '13:25',
    '13:50',
    '14:15',
    '14:40',
    '15:05',
    '15:30',
    '15:55',
    '16:20',
    '16:45',
    '17:10',
    '17:35',
    '18:00',
    '18:25',
    '18:50',
    '19:15',
    '19:40',
    '20:05',
    '20:30',
    '20:55',
    '21:20',
    '21:45'
  ];
  List<String> personCount = ['1', '2', '3'];

  List<String> availableHours = [];

  List<String> makeDatesDropDown() {

    DateTime tmp = DateTime.now();
    List<String> result = [];
    for(int counter = 0 ; counter < 6 ; ){
      if(tmp.weekday == 1){
        counter--;
      } else{
        result.add('${weekDays[tmp.weekday]}-${tmp.day}/${tmp.month}/${tmp.year}');
        counter++;
      }
      tmp = tmp.add(Duration(days: 1));
    }
    return result;
  }

  List<String> splitString(String DateAndDay){
    List<String> result = DateAndDay.split("-");
    print(result);
    return result;
  }

  Future<void> make1TimeDropDown(BuildContext context) async {
    if (dropDownValue1 != null) {
      availableHours.clear();
      if (dropDownValue1.isNotEmpty) {
        print('zbray');
        Navigator.pushNamed(context, '/load');
        for (int i = 0; i < hours.length ; i++) {
          if(dropDownValue1.split("-")[0]=='שישי' && i<1) { continue; }
          if(dropDownValue1.split("-")[0]=='שישי' && hours[i-1] == '18:25' ){ break; }

          DateTime tmpHour = DateTime(today.year,today.month,today.day,int.parse(hours[i].split(':')[0]),int.parse(hours[i].split(':')[1]));
          List<String> timeList = List<String>();
          timeList.add(hours[i]);
          Appointment tempApp = Appointment(
              '', '', dropDownValue1.split("-")[1],'', 1, timeList);

          // ignore: unrelated_type_equality_checks
          bool taken = await db.takenDateTime(tempApp.date, hours[i]);
          if (taken != true) {
            if (dropDownValue1.split("-")[1]=='${today.day}/${today.month}/${today.year}'){
              if(tmpHour.isAfter(today)){
                availableHours.add(hours[i]);
              }
            } else {
              availableHours.add(hours[i]);
            }
          }
        }
        if (availableHours.isEmpty) {
          availableHours.add('כל השעות תפוסות');
        }
      }
      print(availableHours);
      Future.delayed(Duration(milliseconds: 10));
      Navigator.of(context).pop();
    }
  }

  Future<void> make2TimeDropDown(BuildContext context) async {
    if (dropDownValue1 != null) {
      availableHours.clear();
      if (dropDownValue1.isNotEmpty) {
        print('zbray');
        Navigator.pushNamed(context, '/load');
        for (int i = 0; i < hours.length - 1; i++) {
          if(dropDownValue1.split("-")[0]=='שישי' && i<1) { continue; }
          if(dropDownValue1.split("-")[0]=='שישי' && hours[i-1] == '18:25' ){ break; }

          DateTime tmpHour1 = DateTime(
              today.year,today.month,today.day,int.parse(hours[i].split(':')[0]),int.parse(hours[i].split(':')[1]));
          DateTime tmpHour2 = DateTime(
              today.year,today.month,today.day,int.parse(hours[i+1].split(':')[0]),int.parse(hours[i+1].split(':')[1]));
          List<String> timeList = List<String>();
          timeList.add(hours[i]);
          timeList.add(hours[i+1]);
          Appointment tempApp = Appointment(
              '', '', dropDownValue1.split("-")[1],'', 2, timeList);

          // ignore: unrelated_type_equality_checks
          bool taken1 = await db.takenDateTime(tempApp.date, hours[i]);
          bool taken2 = await db.takenDateTime(tempApp.date, hours[i+1]);

          if (taken1 != true && taken2 != true) {
            if (dropDownValue1.split("-")[1]=='${today.day}/${today.month}/${today.year}'){
              if(tmpHour1.isAfter(today)){
                availableHours.add(hours[i]);
              }
            } else {
              availableHours.add(hours[i]);
            }
          }
        }
        if (availableHours.isEmpty) {
          availableHours.add('כל השעות תפוסות');
        }
      }
      print(availableHours);
      Future.delayed(Duration(milliseconds: 10));
      Navigator.of(context).pop();
    }
  }

  Future<void> make3TimeDropDown(BuildContext context) async {
    if (dropDownValue1 != null) {
      availableHours.clear();
      if (dropDownValue1.isNotEmpty) {
        print('zbray');
        Navigator.pushNamed(context, '/load');
        for (int i = 0; i < hours.length - 2 ; i++) {
          if(dropDownValue1.split("-")[0]=='שישי' && i<1) { continue; }
          if(dropDownValue1.split("-")[0]=='שישי' && hours[i-1] == '18:25' ){ break; }
          DateTime tmpHour1 = DateTime(
              today.year,today.month,today.day,int.parse(hours[i].split(':')[0]),int.parse(hours[i].split(':')[1]));
          DateTime tmpHour2 = DateTime(
              today.year,today.month,today.day,int.parse(hours[i+1].split(':')[0]),int.parse(hours[i+1].split(':')[1]));
          List<String> timeList = List<String>();
          timeList.add(hours[i]);
          timeList.add(hours[i+1]);
          timeList.add(hours[i+2]);
          Appointment tempApp = Appointment(
              '', '', dropDownValue1.split("-")[1],'', 2, timeList);

          // ignore: unrelated_type_equality_checks
          bool taken1 = await db.takenDateTime(tempApp.date, hours[i]);
          bool taken2 = await db.takenDateTime(tempApp.date, hours[i+1]);
          bool taken3 = await db.takenDateTime(tempApp.date, hours[i+2]);

          if (taken1 != true && taken2 != true && taken3 != true) {
            if (dropDownValue1.split("-")[1]=='${today.day}/${today.month}/${today.year}'){
              if(tmpHour1.isAfter(today)){
                availableHours.add(hours[i]);
              }
            } else {
              availableHours.add(hours[i]);
            }
          }
        }
        if (availableHours.isEmpty) {
          availableHours.add('כל השעות תפוסות');
        }
      }
      print(availableHours);
      Future.delayed(Duration(milliseconds: 10));
      Navigator.of(context).pop();
    }
  }

  showAppDoneAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("!התור שלך נקבע בהצלחה"),
      content: Text(
        "$dropDownValue1 - $dropDownValue2" + "\n""תודה שבחרתם בסלון כמיל בשארה",
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showUnchangedAlertDialog(BuildContext context) {

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("!שים לב"),
      content: Text(".התור שלך לא השתנה"),

    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showUpdateAlertDialog(BuildContext context, String prevDate, String prevHour, Appointment newApp){
    //2 buttons
    Widget yesButton = FlatButton(
      child: Text('כן'),
      onPressed: () {
        db.updateApp(newApp);
        Navigator.pushNamed(context, '/home');
        showAppDoneAlertDialog(context);
      },
    );

    Widget noButton = FlatButton(
      child: Text('לא'),
      onPressed: () {
        Navigator.pushNamed(context, '/home');
        showUnchangedAlertDialog(context);
      },
    );

    //alert dialog
    AlertDialog alert = AlertDialog(
      title: Text("!שים לב"),
      content: Text(
        ":יש תור שנקבע קודם ב" + "\n" + '${prevDate} - ${prevHour}' + "\n" + "?האם תרצה לעדכן אותו",
      ),
      actions: [
        yesButton,
        noButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        }
    );
  }

  sendNotifications(Appointment myApp) {
    _lNf = LocalNotification(myApp);

    _lNf.notificationBefore2Hours();
  }

  @override
  Widget build(BuildContext context) {
    // makeTimeDropDown();
    // Firebase.initializeApp();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text('מילוי פרטים'),

        ),
        body: Container(
          width: MediaQuery.of(context).size.width * 0.98,
          height: MediaQuery.of(context).size.height * 0.98765,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //full name field
                  TextFormField(
                    enableSuggestions: true,
                    // ignore: missing_return
                    validator: (String input) {
                      if(input.isEmpty) return 'הזן שם';
                    },
                    controller: controlName,
                    key: Key('username'),
                    maxLengthEnforced: true,
                    maxLength: 25,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white60, width: 2.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.5),
                      ),
                      hintText: 'שם מלא',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  // SizedBox(height: 6,),

                  //phone num field
                  TextFormField(
                    enableSuggestions: true,
                    // ignore: missing_return
                    validator: (value) {
                      if(controlNum.text.isEmpty)
                        return 'הזן מספר טלפון';

                      if (!(controlNum.text[0]=='0' && controlNum.text[1]=='5' && controlNum.text.length==10))
                        return 'מספר טלפון לא תקין';
                    },
                    maxLengthEnforced: true,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    controller: controlNum,
                    key: Key('phone number'),
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      counterText: '',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white60, width: 2.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.5),
                      ),
                      hintText: 'מספר טלפון',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  Center(
                    child: DropdownButtonFormField<String>(
                      hint: Text(
                        'כמות אנשים',
                      ),
                      // ignore: missing_return
                      validator: (String input) {
                        if(input == null || input.isEmpty) return 'בחר כמות';
                      },
                      value: dropDownValue3,
                      dropdownColor: Colors.black,
                      icon: Icon(
                        Icons.arrow_downward,
                        color: Colors.black,
                        size: 30,
                      ),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          )
                      ),
                      onChanged: (String newValue) async {
                        setState(() {
                          dropDownValue3 = newValue;
                        });
                        if(dropDownValue1!=null && dropDownValue1.isNotEmpty) {
                          if (dropDownValue2 != null &&dropDownValue2.isNotEmpty) {
                            setState(() {
                              dropDownValue2 = null;
                            });
                          }
                          if (newValue == '1') {
                            await make1TimeDropDown(context);
                          } else if (newValue == '2') {
                            await make2TimeDropDown(context);
                          } else {
                            await make3TimeDropDown(context);
                          }

                        }
                        setState(() {});

                      },
                      items: personCount.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

                  // SizedBox(height: 30,),

                  //dates drop down
                  Center(
                    child: DropdownButtonFormField(
                      hint: Text(
                          'תאריכים פנויים'
                      ),
                      // ignore: missing_return
                      validator: (String input) {
                        if(input==null || input.isEmpty) return 'הזן תאריך תור';
                      },
                      value: dropDownValue1,
                      dropdownColor: Colors.black,
                      icon: Icon(
                        Icons.arrow_downward,
                        color: Colors.black,
                        size: 30,
                      ),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          )
                      ),
                      // onSaved: ,
                      onChanged: (String newValue) async {
                        if (dropDownValue2 != null &&dropDownValue2.isNotEmpty) {
                          setState(() {
                            dropDownValue2 = null;
                          });
                        }
                        setState(() {
                          dropDownValue1 = newValue;
                        });
                        if(dropDownValue3 == '1') {
                          await make1TimeDropDown(context);
                        } else if(dropDownValue3 == '2'){
                          await make2TimeDropDown(context);
                        } else if(dropDownValue3 == '3'){
                          await make3TimeDropDown(context);
                        }
                        // dropDownValue1 = newValue;
                        setState(() {});
                      },
                      items:
                      makeDatesDropDown().map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

                  // SizedBox(height: 30,),

                  //hours drop down
                  Center(
                    child: DropdownButtonFormField<String>(
                      hint: Text(
                        'שעות פנויות',
                      ),
                      // ignore: missing_return
                      validator: (String input) {
                        if(input == null || input.isEmpty) return 'בחר שעה';
                        if(input == 'כל השעות תפוסות') return 'נא לקבוע תאריך שונה';
                      },
                      value: dropDownValue2,
                      dropdownColor: Colors.black,
                      icon: Icon(
                        Icons.arrow_downward,
                        color: Colors.black,
                        size: 30,
                      ),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          )
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropDownValue2 = newValue;
                        });
                      },
                      items: availableHours.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),



                  // SizedBox(height: 40,),

                  Center(
                    child: RaisedButton(
                      color: Colors.black,
                      onPressed: () async {
                        //Implement
                        if(_formKey.currentState.validate()) {
                          if(dropDownValue3 == '1') {
                            List<String> timeList = List();
                            timeList.add(dropDownValue2);
                            Appointment currentApp = Appointment(
                                controlName.text,
                                controlNum.text,
                                dropDownValue1.split('-')[1],
                                dropDownValue1.split('-')[0],
                                1,
                                timeList);
                            bool alreadyAppointed = await db
                                .personAlreadyAppointed(currentApp.number);
                            if (!(alreadyAppointed)) {
                              db.addApp(currentApp);
                              Navigator.pop(context);
                              // Navigator.pushNamed(context, '/home');
                              showAppDoneAlertDialog(context);
                              //show "appointed successfully" pop up
                            } else {
                              DocumentSnapshot prevApp = await db
                                  .returnAppointmentData(controlNum.text);
                              //UPDATE ONLY ALLOWED 24 HOURS BEFORE
                              //show "do u want to update ur appointment ? " pop
                              //if yes ,get new details, then update
                              //if no, show "appointment did not change" & go back home
                              setState(() {
                                showUpdateAlertDialog(
                                    context,
                                    prevApp.get('date'),
                                    prevApp.get('time')[0],
                                    currentApp
                                );
                              });
                              //show "appointed successfully" pop up, if changed
                              //
                            }
                            sendNotifications(currentApp);
                            return;
                          }else if (dropDownValue3 == '2'){
                            List<String> timeList = List();
                            timeList.add(dropDownValue2);
                            for(int i=0 ; i<hours.length ; i++){
                              if(hours[i] == dropDownValue2){
                                timeList.add(hours[i+1]);
                                break;
                              }
                            }
                            Appointment currentApp = Appointment(
                                controlName.text,
                                controlNum.text,
                                dropDownValue1.split('-')[1],
                                dropDownValue1.split('-')[0],
                                2,
                                timeList);
                            bool alreadyAppointed = await db
                                .personAlreadyAppointed(currentApp.number);
                            if (!(alreadyAppointed)) {
                              await db.addApp(currentApp);
                              Navigator.pushNamed(context, '/home');
                              showAppDoneAlertDialog(context);
                              //show "appointed successfully" pop up
                            } else {
                              DocumentSnapshot prevApp = await db
                                  .returnAppointmentData(controlNum.text);
                              //UPDATE ONLY ALLOWED 24 HOURS BEFORE
                              //show "do u want to update ur appointment ? " pop
                              //if yes ,get new details, then update
                              //if no, show "appointment did not change" & go back home
                              setState(() {
                                showUpdateAlertDialog(
                                    context,
                                    prevApp.get('date'),
                                    prevApp.get('time')[0],
                                    currentApp
                                );
                              });
                              //show "appointed successfully" pop up, if changed
                              //
                            }
                            sendNotifications(currentApp);

                          } else {
                            List<String> timeList = List();
                            timeList.add(dropDownValue2);
                            for(int i=0 ; i<hours.length ; i++){
                              if(hours[i] == dropDownValue2){
                                timeList.add(hours[i+1]);
                                timeList.add(hours[i+2]);
                                break;
                              }
                            }
                            Appointment currentApp = Appointment(
                                controlName.text,
                                controlNum.text,
                                dropDownValue1.split('-')[1],
                                dropDownValue1.split('-')[0],
                                3,
                                timeList);
                            bool alreadyAppointed = await db
                                .personAlreadyAppointed(currentApp.number);
                            if (!(alreadyAppointed)) {
                              await db.addApp(currentApp);
                              Navigator.pushNamed(context, '/home');
                              showAppDoneAlertDialog(context);
                              //show "appointed successfully" pop up
                            } else {
                              DocumentSnapshot prevApp = await db
                                  .returnAppointmentData(controlNum.text);
                              //UPDATE ONLY ALLOWED 24 HOURS BEFORE
                              //show "do u want to update ur appointment ? " pop
                              //if yes ,get new details, then update
                              //if no, show "appointment did not change" & go back home
                              setState(() {
                                showUpdateAlertDialog(
                                    context,
                                    prevApp.get('date'),
                                    prevApp.get('time')[0],
                                    currentApp
                                );
                              });
                              //show "appointed successfully" pop up, if changed
                              //
                            }
                            sendNotifications(currentApp);
                          }

                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(2.8,),
                        child: Text(
                          'קבע תור',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // SizedBox(height: 25,),


                  //bottom loihab
                  Center(
                    child: Container(
                      child: Image.asset('assets/app_icon.png'),
                      width: 120,
                      height: 120,
                    ),
                  ),

                  //straight line
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 0.3,
                      width: 360.0,
                      color: Colors.white,
                    ),
                  ),

                  // SizedBox(height: 3,),

                  //CopyRigths~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.copyright),
                      SizedBox(width: 3,),
                      Text(
                        'Developed By: Yosif & Bishara - Bishara',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}