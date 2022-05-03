//zmienne globalne

//sciezki do naszych plikow z php na serwerze
import 'mysql/tables.dart';

const String URL_reg = 'http://192.168.2.4/flutter/reg.php';
const String URL_log = 'http://192.168.2.4/flutter/login.php';
const String URL_getData = 'http://192.168.2.4/flutter/get_data.php';
const String URL_update = 'http://192.168.2.4/flutter/update.php';

//zmienne globalne
//Users user = new Users(admin: 2, id: '', password: '', email: '');
class global {
  late String id = "12";
  late String password;
  late String email = " hejka ";
  late int admin;
  late int ekipa_id = 1;
}

global user = new global();
