import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmel_bishara_app/SizeConfig.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    static bool  firstLoad = true;
    SizeConfig x = SizeConfig();

    _calling() async {
      const url = 'tel:+972546441850';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    void _call(){
      try {
        _calling();
      }catch(ex){
        return;
      }
    }

    _launchFb() async {
      const url = 'https://www.facebook.com/profile.php?id=100003938695430';
      if (await canLaunch(url)) {
        await launch(url, forceWebView: false, forceSafariVC: false);
      } else {
        throw 'Could not launch $url';
      }
    }

    _launchIg() async {
      const url = 'https://www.instagram.com/kmelbishara/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    _launchLocation() async {
      const url = 'https://goo.gl/maps/Je4YhL6Kkg5HZHRo8';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

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
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
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
      x.init(context);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);



    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[800],
      body: Container(
        width: x.screenWidth,
        height: x.screenHeight,
        child:Column(
          children: [
          

              //logo picture


                 Padding(
                   padding: EdgeInsets.fromLTRB(0, 60,0, 50),
                   child: Container(
                     width: x.screenWidth,
                     height: x.screenHeight*0.45,
                     child: Center(
                      child: Image.asset('./assets/kme1-06.png',
                      filterQuality: FilterQuality.high,
                      width: x.screenWidth,
                      height: x.screenHeight,),
                     ),
                   ),
                 ),


              
              Expanded(
                flex:1,
                child: Container(
                  child: Column(
                      children: <Widget>[
                        //appointment btn
                        Padding(
                          padding: EdgeInsets.fromLTRB(0,0,0, x.screenHeight*0.025),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/reveal_appointment');
                                    }, // change this to real function
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'התור שלי',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
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
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/fill_details');
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
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                            height: x.screenHeight*0.00085,
                            width: x.screenHeight*0.9,
                            color: Colors.white,
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'צור קשר',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // SizedBox(height: 15,),
                        //contacting button icons
                        Container(
                          margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height*0.003, 0, 0),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.lightGreenAccent,
                                    size: 50,
                                  ),
                                  onPressed: () { _call(); },
                                ),
                              ),

                              // SizedBox(width: 40,),

                              Expanded(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                  onPressed: () { _launchLocation(); },
                                ),
                              ),

                              // SizedBox(width: 40,),

                              Expanded(
                                child: IconButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.facebookSquare,
                                    color: Colors.blue[600],
                                    size: 50,
                                  ),
                                  onPressed: () { _launchFb(); },
                                ),
                              ),

                              // SizedBox(width: 40,),

                              Expanded(
                                child: IconButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.instagram,
                                    size: 50,
                                    color: Colors.amber,
                                  ),
                                  onPressed: () { _launchIg(); },
                                ),
                              ),

                              // SizedBox(width: 40,),
                            ],
                          ),
                        ),
                      ],
                ),


          ),
              ),
        ]),
      ),

    );

  }
}
