import 'package:flutter/material.dart';
import 'package:kmel_bishara_app/firestoreClient.dart';
import 'package:kmel_bishara_app/globalConfig.dart';
import 'dart:async';
import 'Appointment.dart';
import 'package:flutter/services.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  final _formKey = GlobalKey<FormState>();
  late String? nameField, phoneField;
  FocusNode phoneNumberFocus = FocusNode();

  final controlName = TextEditingController(),controlNum = TextEditingController();
  bool isNameFieldVisible = false;
  bool isKnownUserFlag = false;

  Future<bool> isKnownUser(String number) async {
    Appointment? userDetails = await fsc.getUserDetails(number);
    globalConfig.nextUserAppointment = userDetails;
    if (userDetails == null) {
      return false;
    }
    globalConfig.name = userDetails.name;
    return true;
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
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[800],
          body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.98,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      //bottom loihab
                      Center(
                        child: Container(
                          child: Image.asset('assets/app_icon.png'),
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.5,
                        ),
                      ),

                      // Phone num field
                      TextFormField(
                        focusNode: phoneNumberFocus,
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
                        onChanged: (String newVal) async {
                          if (newVal.length < 10){
                            isKnownUserFlag = isNameFieldVisible = false;
                            setState(() {});
                            return;
                          }
                          isKnownUserFlag = await isKnownUser(newVal);
                          isNameFieldVisible = !isKnownUserFlag;
                          globalConfig.number = controlNum.text;
                          setState(() {});
                        },
                      ),

                      // Name field
                      Visibility(
                        visible: isNameFieldVisible,
                        child: TextFormField(
                          enableSuggestions: true,
                          // ignore: missing_return
                          validator: (String? input) {
                            if(input == null) return 'הזן שם';
                            if(input.isEmpty) return 'הזן שם';
                          },
                          controller: controlName,
                          key: Key('username'),
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          maxLength: 15,
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
                      ),

                      // Hello somebody!
                      Visibility(
                        visible: isKnownUserFlag,
                        child: Center(
                          child: Text(
                            'שלום ' + globalConfig.name,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.09,
                        width: MediaQuery.of(context).size.width * 0.1
                      ),

                      // Enter System button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              globalConfig.name = controlName.text.isNotEmpty ? controlName.text : globalConfig.nextUserAppointment!.name ;
                              Navigator.pushNamed(context, '/homePage');
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(2.8,),
                            child: Text(
                              'כניסה',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      //straight line
                      Center(
                        // padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: 0.3,
                          width: 360.0,
                          color: Colors.white,
                        ),
                      ),

                      // SizedBox(
                      //     height: MediaQuery.of(context).size.height * 0.01,
                      //     width: MediaQuery.of(context).size.width * 0.1
                      // ),

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
        ),
      ),
    );
  }
}