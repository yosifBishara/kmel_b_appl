import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'myFirestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class Reveal extends StatefulWidget {
  @override
  _RevealState createState() => _RevealState();
}

class _RevealState extends State<Reveal> {

  final controlNum = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FireHelper db = FireHelper();
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
  appRemovedSucc(BuildContext context){
    AlertDialog alert = AlertDialog(
      title: Center(
        child: Text(
          "!התור שלך בוטל",

        ),
      ),
      content: Text(""),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  areUSureAlert(BuildContext context, String phoneNumber){
    Widget yesButton = TextButton(
      child: Text('כן'),
      onPressed: () async {
        await db.deleteApp(phoneNumber);
        await FlutterLocalNotificationsPlugin().cancelAll();
        Navigator.pushNamed(context, '/home');
        appRemovedSucc(context);
      },
    );

    Widget noButton = TextButton(
      child: Text('לא'),
      onPressed: () {
        Navigator.pushNamed(context, '/home');
        showUnchangedAlertDialog(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(
        "!שים לב",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      content: Text("?האם אתה מאשר את ביטול התור שלך"),
      actions: [
        yesButton,
        noButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showCustomerAppointment(BuildContext context, String phoneNumber) async {
    DocumentSnapshot? doc = await db.returnAppointmentData(phoneNumber);

    AlertDialog alertNotHasApp = AlertDialog(
      title: Text(""),
      content: Text(
        ".לא קיים תור במערכת",
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if(doc == null){
          return alertNotHasApp;
        }
        Widget yesButton = TextButton(
          child: Text('כן'),
          onPressed: () {
            // Navigator.pushNamed(context, '/home');
            areUSureAlert(context, phoneNumber);
          },
        );

        Widget noButton = TextButton(
          child: Text('לא'),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
            showUnchangedAlertDialog(context);
          },
        );
        return AlertDialog(
          title: Text(
            "התור שלך במערכת:",
            textDirection: TextDirection.rtl,
          ),
          content: Text(
            "${doc.get('date')} - ${doc.get('time')}" + "\n" + "האם תרצה לבטל?",
            textDirection: TextDirection.rtl,
          ),
          actions: [
            yesButton,
            noButton,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    controlNum.text = '';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          ''
        ),
        backgroundColor: CupertinoColors.black,
        shadowColor: Colors.grey,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.55,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    ':הכנס מספר טלפון',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.015,),

                  TextFormField(
                    enableSuggestions: true,
                    // ignore: missing_return
                    validator: (value) {
                      if(controlNum.text.isEmpty)
                        return 'הזן מספר טלפון';

                      if (!(controlNum.text[0]=='0' && controlNum.text[1]=='5' && controlNum.text.length==10))
                        return 'מספר טלפון לא תקין';
                    },
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    controller: controlNum,
                    key: Key('phone number'),
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      counterText: '',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.5),
                      ),
                      hintText: 'מספר טלפון',
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          // Navigator.pushNamed(context, '/home');
                          if (controlNum.text.isNotEmpty) {
                            _showCustomerAppointment(context, controlNum.text);
                          }
                        }
                      }, // change this to real function
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'אישור',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                side: BorderSide(color: Colors.grey),
                              )
                          )
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

        ),

      ),
    );
  }
}
