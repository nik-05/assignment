// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PayoutModelAdapter extends TypeAdapter<PayoutModel> {
  @override
  final int typeId = 0;

  @override
  PayoutModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PayoutModel(
      id: fields[0] as String,
      beneficiaryName: fields[1] as String,
      accountNumber: fields[2] as String,
      ifscCode: fields[3] as String,
      amount: fields[4] as double,
      createdAt: fields[5] as DateTime,
      status: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PayoutModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.beneficiaryName)
      ..writeByte(2)
      ..write(obj.accountNumber)
      ..writeByte(3)
      ..write(obj.ifscCode)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayoutModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
