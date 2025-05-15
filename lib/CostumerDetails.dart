import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kmel_bishara_app/constants.dart';
import 'package:kmel_bishara_app/firestoreClient.dart';
import 'package:kmel_bishara_app/globalConfig.dart';
import 'dart:async';
import 'Appointment.dart';
import 'Notifications.dart';
import 'package:flutter/services.dart';

class CostumerDet extends StatefulWidget {
  @override
  _CostumerDetState createState() => _CostumerDetState();
}

class _CostumerDetState extends State<CostumerDet> {

  LocalNotification _lNf = LocalNotification.ass();
  final _formKey = GlobalKey<FormState>();
  final controlName = TextEditingController(),controlNum = TextEditingController();
  late String? dateDropDownValue='', timeDropDownValue='', personsDropDownValue = '', nameField, phoneField;
  bool selectedAmount = false, selectedDate = false, selectedHour = false;
  DateTime today = DateTime.now();
  // working hours list
  List<String> personCount = ['1', '2', '3'];
  List<String> availableHours = [];

  List<String> makeDatesDropDown() {
    DateTime tmp = DateTime.now();
    List<String> result = [];
    for(int counter = 0 ; counter < 10 ;){
      if ((tmp.weekday == DateTime.monday) && !(globalConfig.enabledMondayDates.contains('${tmp.day}.${tmp.month}.${tmp.year}'))) {
        tmp = tmp.add(Duration(days: 1));
        continue;

      } else {
        result.add('${UtilConst.WEEK_DAYS[tmp.weekday]}-${tmp.day}.${tmp.month}.${tmp.year}');
        counter++;
      }
      tmp = tmp.add(Duration(days: 1));
    }
    return result;
  }

  Map<String, String> splitDateDropdownElement(String? dropdownElemVal){
    if (dropdownElemVal == null || dropdownElemVal.isEmpty) {
      return {'weekday': '', 'date': ''};
    }
    List<String> result = dropdownElemVal.split("-");
    return {'weekday': result[0], 'date': result[1]};
  }

  Future<Map> getAvailableHours (String date) async {
    List unavailableHours = await fsc.getUnavailableTimes(date);
    List workingTimes = await fsc.getWorkingTimes(date);
    List availableHours = List.from(
        Set.from(workingTimes).difference(Set.from(unavailableHours))
    );

    return { for (var item in availableHours) item : true };
  }

  String calculateNextHour(String hour, int offsetMinutes) {
    List hourSplit = hour.split(':');
    DateTime nextHour = DateTime(
      today.year, today.month, today.day,
      int.parse(hourSplit[0]), int.parse(hourSplit[1])
    ).add(Duration(minutes: offsetMinutes));
    return '${nextHour.hour}:${nextHour.minute == 0 ? '00' : nextHour.minute}';
  }

  DateTime hourAsDateTime(String hour) {
    // Parse hours and minutes from the timeString
    final parts = hour.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);

    // Create a DateTime object with the current date and the parsed time
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hours, minutes);
  }

  Future<List<String>> createTimeDropdown(String? persons, String? date, String? weekday, BuildContext context) async {
    List<String> dropdownContent = [];
    if ((date == null) || (date.isEmpty) || (persons == null) || (persons.isEmpty) || (weekday == null) || (weekday.isEmpty)) {
      return dropdownContent;
    }

    Navigator.pushNamed(context, '/load');
    await Future.delayed(Duration(milliseconds: 30));
    Map availableHoursMap  = await getAvailableHours(date);
    String fridayClosingHour = '18:30';

    if (int.parse(persons) > 1) {
      int offsetMinutes = fsc.timeOffsetMin;
      for (String hour in availableHoursMap.keys) {

        if (
          (weekday == 'שישי')
          && (hourAsDateTime(hour).isAfter(hourAsDateTime(fridayClosingHour)))
          && !(globalConfig.enabledFridayDates.contains(date))
        ) {
          break;
        }

        String nextHour = calculateNextHour(hour, offsetMinutes);
        String nextHour2 = calculateNextHour(nextHour, offsetMinutes);

        if (persons == '2' && availableHoursMap.containsKey(nextHour)) {
          dropdownContent.add(hour);
        }

        if (persons == '3' && availableHoursMap.containsKey(nextHour) && availableHoursMap.containsKey(nextHour2)) {
          dropdownContent.add(hour);
        }
      }
    }
    else {
      dropdownContent = List.from(availableHoursMap.keys);
      if (weekday == 'שישי' && !(globalConfig.enabledFridayDates.contains(date))) {
        dropdownContent.removeWhere(
                (hour) =>
                hourAsDateTime(hour).isAfter(hourAsDateTime(fridayClosingHour))
        );
      }
    }
    await Future.delayed(Duration(milliseconds: 30));
    Navigator.of(context).pop();
    return List.from(Set.from(dropdownContent));
  }

  sendNotifications(Appointment myApp) {
    _lNf = LocalNotification(myApp);

    _lNf.notificationBefore2Hours();
  }

  showTakenAppointmentDialog(BuildContext context) async {

    Widget okButton = ElevatedButton(
      child: Text('המשך'),
      onPressed: () async {
        availableHours = await createTimeDropdown(
            personsDropDownValue,
            splitDateDropdownElement(dateDropDownValue)['date'],
            splitDateDropdownElement(dateDropDownValue)['weekday'],
            context
        );
        Navigator.of(context).pop(true);
      },
    );

    //alert dialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "מישהו תפס את התור לפניך!",
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
      ),
      content: Text(
        "נא לבחור שעה אחרת",
        textDirection: TextDirection.rtl,
      ),
      actions: [
        okButton,
      ],
    );

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text('מילוי פרטים'),

        ),
        body: Container(
          width: MediaQuery.of(context).size.width * 0.98,
          height: MediaQuery.of(context).size.height * 0.98,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[


                  // Person Count DropDown
                  Center(
                    child: DropdownButtonFormField<String>(
                      hint: Text(
                        'כמות אנשים',
                      ),
                      // ignore: missing_return
                      validator: (String? input) {
                        if(input == null || input.isEmpty) return 'בחר כמות';
                      },
                      value: selectedAmount ? personsDropDownValue : null,
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
                      onChanged: (String? newValue) async {
                        personsDropDownValue = newValue!;
                        selectedAmount = true;
                        availableHours = await createTimeDropdown(
                            newValue,
                            splitDateDropdownElement(dateDropDownValue)['date'],
                            splitDateDropdownElement(dateDropDownValue)['weekday'],
                            context
                        );
                        if (availableHours.isEmpty) {
                          availableHours = ['כל השעות תפוסות'];
                        }
                        selectedHour = false;
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

                  // Dates drop down
                  Center(
                    child: DropdownButtonFormField(
                      hint: Text(
                          'תאריך ויום'
                      ),
                      // ignore: missing_return
                      validator: (String? input) {
                        if(input==null || input.isEmpty) return 'הזן תאריך תור';
                      },
                      value: selectedDate ? dateDropDownValue : null,
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
                      onChanged: (String? newValue) async {
                        dateDropDownValue = newValue;
                        selectedDate = true;
                        availableHours = await createTimeDropdown(
                            personsDropDownValue,
                            splitDateDropdownElement(newValue)['date'],
                            splitDateDropdownElement(newValue)['weekday'],
                            context
                        );
                        if (availableHours.isEmpty) {
                          availableHours = ['כל השעות תפוסות'];
                        }
                        selectedHour = false;
                        setState(() {});
                      },
                      items: makeDatesDropDown().map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

                  // Time drop down
                  DropdownButtonFormField<String>(
                    hint: Text(
                      'שעות פנויות',
                    ),
                    // ignore: missing_return
                    validator: (String? input) {
                      if(input == null || input.isEmpty) return 'בחר שעה';
                      if(input == 'כל השעות תפוסות') return 'נא לקבוע תאריך שונה';
                    },
                    value: selectedHour ? timeDropDownValue: null,
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
                    menuMaxHeight: MediaQuery.of(context).size.height * 0.65,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        )
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        timeDropDownValue = newValue;
                        selectedHour = true;
                      });
                    },
                    items: availableHours.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  
                  // Appoint button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          List<String> times = [timeDropDownValue!];
                          int persons = int.parse(personsDropDownValue!);
                          if (persons > 1) {
                            String nextHour = calculateNextHour(timeDropDownValue!, fsc.timeOffsetMin);
                            times.add(nextHour);
                            if (persons > 2) times.add(calculateNextHour(nextHour, fsc.timeOffsetMin));
                          }
                          Map dateDaySplit = splitDateDropdownElement(dateDropDownValue!);
                          String result = await fsc.makeNewAppointment(
                              globalConfig.name,
                              globalConfig.number,
                              persons,
                              dateDaySplit['weekday'],
                              dateDaySplit['date'],
                              times
                          );

                          sleep(Duration(milliseconds: 100));

                          if (result == FireStoreArg.APPOINTMENT_PASSED) {
                            // go back to home page
                            setState(() {
                              globalConfig.nextUserAppointment = Appointment(
                                  globalConfig.name,
                                  globalConfig.number,
                                  dateDaySplit['date'],
                                  dateDaySplit['weekday'],
                                  persons,
                                  times
                              );
                            });
                            try {
                              sendNotifications(globalConfig.nextUserAppointment!);
                            } catch (e) {}
                            Navigator.of(context).pushNamed('/homePage');
                          } else {
                            await showTakenAppointmentDialog(context);
                            setState(() {
                              selectedHour = false;
                            });
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