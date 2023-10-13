//zmienne globalne

//sciezki do naszych plikow z php na serwerze

const String ulrReg = 'http://192.168.2.5/flutter/reg.php';
const String urlLog = 'http://192.168.2.5/flutter/login.php';
const String urlGetData = 'http://192.168.2.5/flutter/get_data.php';
const String ulrUpdate = 'http://192.168.2.5/flutter/update.php';
const String urlUpdate2 = 'http://192.168.2.5/flutter/update2.php';
const String phpurl = 'http://192.168.2.5/flutter/submit_data_users.php';
const String phpurl2 = 'http://192.168.2.5/flutter/submit_data_tools.php';
const String phpurl3 = 'http://192.168.2.5/flutter/submit_data_tasks.php';
const String phpurl4 = 'http://192.168.2.5/flutter/submit_data_ekipa.php';

//zmienne globalne
//Users user = new Users(admin: 2, id: '', password: '', email: '');
class Global {
  late String id = "12";
  late String password;
  late String email = " hejka ";
  late int admin;
  late int ekipaId;
}

Global user = Global();
