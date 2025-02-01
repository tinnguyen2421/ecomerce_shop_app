// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Order {
  final String id;
  final String productId;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String productName;
  final int productPrice;
  final int quantity;
  final String category;
  final String image;
  final String buyerId;
  final String vendorId;
  final bool processing;
  final bool delivered;
  final String paymentStatus;
  final String paymentIntentId;
  final String paymentMethod;

  Order({
    required this.id,
    required this.productId,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.category,
    required this.image,
    required this.buyerId,
    required this.vendorId,
    required this.processing,
    required this.delivered,
    required this.paymentStatus,
    required this.paymentIntentId,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productId': productId,
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'category': category,
      'image': image,
      'buyerId': buyerId,
      'vendorId': vendorId,
      'processing': processing,
      'delivered': delivered,
      'paymentStatus': paymentStatus,
      'paymentIntentId': paymentIntentId,
      'paymentMethod': paymentMethod,
    };
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] as String,
      productId: map['productId'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      state: map['state'] as String,
      city: map['city'] as String,
      locality: map['locality'] as String,
      productName: map['productName'] as String,
      productPrice: map['productPrice'] as int,
      quantity: map['quantity'] as int,
      category: map['category'] as String,
      image: map['image'] as String,
      buyerId: map['buyerId'] as String,
      vendorId: map['vendorId'] as String,
      processing: map['processing'] as bool,
      delivered: map['delivered'] as bool,
      paymentStatus: map['paymentStatus'] as String,
      paymentIntentId: map['paymentIntentId'] as String,
      paymentMethod: map['paymentMethod'] as String,
    );
  }
}
