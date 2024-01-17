import 'dart:convert';
import 'package:flutter_application_1/product.dart';
import 'package:dio/dio.dart';

class ProductController {
  Future<List<Product>> getProducts() async {
    var dio = Dio();
    var url = 'https://fakestoreapi.com/products';

    try {
      var response = await dio.get(url);

      if (response.statusCode == 200) {
        List<dynamic> productsJson = response.data;
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
