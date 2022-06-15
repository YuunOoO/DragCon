//zmienne globalne

//sciezki do naszych plikow z php na serwerze
import 'mysql/tables.dart';

const String URL_reg = 'http://192.168.2.5/flutter/reg.php';
const String URL_log = 'http://192.168.2.5/flutter/login.php';
const String URL_getData = 'http://192.168.2.5/flutter/get_data.php';
const String URL_update = 'http://192.168.2.5/flutter/update.php';
const String URL_update2 = 'http://192.168.2.5/flutter/update2.php';
const String phpurl = 'http://192.168.2.5/flutter/submit_data_users.php';
const String phpurl2 = 'http://192.168.2.5/flutter/submit_data_tools.php';
const String phpurl3 = 'http://192.168.2.5/flutter/submit_data_tasks.php';
const String phpurl4 = 'http://192.168.2.5/flutter/submit_data_ekipa.php';

//zmienne globalne
//Users user = new Users(admin: 2, id: '', password: '', email: '');
class global {
  late String id = "12";
  late String password;
  late String email = " hejka ";
  late int admin;
  late int ekipa_id;
}

global user = new global();
