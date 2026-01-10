import 'package:hive/hive.dart';

part 'payment_method_model.g.dart';

enum PaymentType {
  card,
  cash,
}

@HiveType(typeId: 4)
class PaymentMethodModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final PaymentType type;

  @HiveField(2)
  final String? cardNumber;

  @HiveField(3)
  final String? cardHolderName;

  @HiveField(4)
  final String? expiryDate;

  @HiveField(5)
  final bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.type,
    this.cardNumber,
    this.cardHolderName,
    this.expiryDate,
    this.isDefault = false,
  });

  String get displayName {
    if (type == PaymentType.cash) {
      return 'Cash on Delivery';
    }
    return 'Card ending in ${cardNumber?.substring(cardNumber!.length - 4)}';
  }

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] ?? '',
      type: PaymentType.values.firstWhere(
        (e) => e.toString() == 'PaymentType.${json['type']}',
        orElse: () => PaymentType.card,
      ),
      cardNumber: json['cardNumber'],
      cardHolderName: json['cardHolderName'],
      expiryDate: json['expiryDate'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'isDefault': isDefault,
    };
  }

  PaymentMethodModel copyWith({
    String? id,
    PaymentType? type,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    bool? isDefault,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      type: type ?? this.type,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
