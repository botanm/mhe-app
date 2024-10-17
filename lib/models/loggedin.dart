import 'package:hive/hive.dart';

part 'loggedin.g.dart';

@HiveType(typeId: 0)
class loggedin extends HiveObject {
  @HiveField(0)
  late Map<String, dynamic> data;

  // @HiveField(0)
  // late String name;

  // @HiveField(1)
  // late DateTime createdDate;

  // @HiveField(2)
  // late bool isExpense = true;

  // @HiveField(3)
  // late double amount;
}
