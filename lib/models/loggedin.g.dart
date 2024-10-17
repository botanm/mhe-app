// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loggedin.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class loggedinAdapter extends TypeAdapter<loggedin> {
  @override
  final int typeId = 0;

  @override
  loggedin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return loggedin()..data = (fields[0] as Map).cast<String, dynamic>();
  }

  @override
  void write(BinaryWriter writer, loggedin obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is loggedinAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
