import 'package:flutter/material.dart';
import 'package:shamo_app/services/product_service.dart';

import '../models/product_model.dart';

class ProductProvider with ChangeNotifier{

  List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  set products (List<ProductModel> products) {
    _products = products;
    notifyListeners();
  }

  Future<void> getProducts() async {

    try{
      List<ProductModel> products = await ProductService().getProducts();
      _products = products;

    }catch (e){
      print(e);

    }
  }



}