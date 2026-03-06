import 'package:uuid/uuid.dart';

class Ids {
  static const Uuid _uuid = Uuid();
  static String v4() => _uuid.v4();
}