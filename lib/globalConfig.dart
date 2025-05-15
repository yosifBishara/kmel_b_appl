import 'package:kmel_bishara_app/Appointment.dart';

class GlobalConfig {
  String name = '';
  String number = '';
  Appointment? nextUserAppointment = null;
  List<String> enabledMondayDates = [];
  List<String> enabledFridayDates = [];
}

GlobalConfig globalConfig = GlobalConfig();
