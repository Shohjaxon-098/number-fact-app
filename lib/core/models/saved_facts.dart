import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class SavedFact extends HiveObject {
  @HiveField(0)
  final String fact;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final DateTime savedAt;

  SavedFact({required this.fact, required this.type, required this.savedAt});
}
