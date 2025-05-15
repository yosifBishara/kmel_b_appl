import 'package:flutter/material.dart';
import 'package:kmel_bishara_app/SizeConfig.dart';
import 'package:flutter/services.dart';
import 'package:kmel_bishara_app/firestoreClient.dart';
import 'package:kmel_bishara_app/globalConfig.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static bool  firstLoad = true;
  SizeConfig sizeConfig = SizeConfig();

  showInitAlertDialog(BuildContext context){
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Icon(Icons.priority_high),
      content: Text(
        'לקוח יקר!'+'\n'+'- נא להגיע בזמן שייקבע בהזמנתך.'+'\n'
            +'- איחור של יותר מ-5 דקות גורר ביטול תורך, ותיאלץ לקבוע תור חדש.'+'\n'
            +'- במידה שקבעת תור והתחרטת, נא לבטל אותו מינימום שעתיים מוקדם.',
        textDirection: TextDirection.rtl,
      ),
      actions: [
        TextButton(
          child: Text(
            'המשך',
            style: TextStyle(
                fontSize: 15
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDeleteAlertDialog(BuildContext context) async {
    //2 buttons
    Widget yesButton = ElevatedButton(
      child: Text('כן'),
      onPressed: () async {
        await fsc.deleteAppointment(globalConfig.nextUserAppointment!);
        setState(() {
          globalConfig.nextUserAppointment = null;
        });
        Navigator.of(context).pop(true);
      },
    );

    Widget noButton = ElevatedButton(
      child: Text('לא'),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );

    //alert dialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "!שים לב",
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
      ),
      content: Text(
        "האם תרצה למחוק את תורך " + '?',
        textDirection: TextDirection.rtl,
      ),
      actions: [
        yesButton,
        noButton,
      ],
    );

    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        }
    );
  }

  showDeleteAccountAlertDialog(BuildContext context) async {
    //2 buttons
    Widget yesButton = ElevatedButton(
      child: Text('כן'),
      onPressed: () async {
        await fsc.deleteUserDetails(globalConfig.number, globalConfig.nextUserAppointment);
        Navigator.of(context).pop(true);
      },
    );

    Widget noButton = ElevatedButton(
      child: Text('לא'),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );

    //alert dialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "!שים לב",
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
      ),
      content: Text(
        "האם תרצה למחוק את חשבונך " + '?',
        textDirection: TextDirection.rtl,
      ),
      actions: [
        yesButton,
        noButton,
      ],
    );

    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        }
    );
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if(firstLoad){
        firstLoad = false;
        showInitAlertDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    sizeConfig.init(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[800],
        body: Container(
          padding: EdgeInsets.fromLTRB(0,sizeConfig.screenHeight*0.1,0, sizeConfig.screenHeight*0.1),
          width: sizeConfig.screenWidth,
          height: sizeConfig.screenHeight,
          child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [


                //logo picture
                Container(
                  width: sizeConfig.screenWidth * 0.9,
                  height: sizeConfig.screenHeight*0.2,
                  child: Card(
                    shadowColor: Colors.black,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(MediaQuery
                          .of(context)
                          .size
                          .width * 0.015),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Visibility(
                          visible: (globalConfig.nextUserAppointment != null) && (globalConfig.nextUserAppointment!.date != ''),
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await showDeleteAlertDialog(context);
                            },
                          ),
                        ),
                        SizedBox(width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.2,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 8, 2),
                          child: Text(
                            (globalConfig.nextUserAppointment == null) ||
                                (globalConfig.nextUserAppointment!.date == '')?
                            'לא נמצא עבורך תור במערכת' :
                            'התור שלך במערכת:'
                                + '\n' + '\n'
                                + globalConfig.nextUserAppointment!.day + ' - '
                                +  globalConfig.nextUserAppointment!.date + '\n'
                                + globalConfig.nextUserAppointment!.time.toString()
                                .replaceAll('[', '')
                                .replaceAll(']', ''),
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: 18
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.095
                ),

                Container(
                  child: Column(
                    children: <Widget>[
                      //appointment btn
                      Padding(
                        padding: EdgeInsets.fromLTRB(0,0,0, sizeConfig.screenHeight*0.025),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () async {
                                    if ((globalConfig.nextUserAppointment != null) && (globalConfig.nextUserAppointment!.date != '')) {
                                      bool delRes = await showDeleteAlertDialog(context);
                                      if (delRes) {
                                        Navigator.pushNamed(context, '/fill_details');
                                      }
                                    } else {
                                      Navigator.pushNamed(context, '/fill_details');
                                    }
                                  }, // change this to real function
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'קביעת תור',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18),
                                            side: BorderSide(color: Colors.grey),
                                          )
                                      )
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),

                      //empty space
                      SizedBox(height: 10,),

                      //straight line
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: sizeConfig.screenHeight*0.00085,
                          width: sizeConfig.screenHeight*0.9,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 20,),

                      TextButton(
                        onPressed: () async {
                          bool delRes = await showDeleteAccountAlertDialog(context);
                          if (delRes) {
                            Navigator.of(context).pushNamed('/home');
                          }
                        }, // change this to real function
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'מחיקת חשבון',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.redAccent),
                                )
                            )
                        ),
                      ),

                    ],
                  ),


                ),
              ]),
        ),

      ),
    );

  }
}