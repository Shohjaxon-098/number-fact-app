
import 'package:hive/hive.dart';
import 'package:numberfactapp/core/models/saved_facts.dart';

class SavedFactAdapter extends TypeAdapter<SavedFact> {
  @override
  final int typeId = 0;

  @override
  SavedFact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedFact(
      fact: fields[0] as String,
      type: fields[1] as String,
      savedAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SavedFact obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.fact)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedFactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
