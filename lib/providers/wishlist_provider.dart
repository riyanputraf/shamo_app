import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';

class WishlistProvider with ChangeNotifier{

  List<ProductModel> _wishlist = [];

  List<ProductModel> get wishlist => _wishlist;

  set wishlist (List<ProductModel> wishlist) {
    _wishlist = wishlist;
    notifyListeners();
  }

  setProduct(ProductModel product){
    if(!isWishlist(product)){
      _wishlist.add(product);
    } else{
      _wishlist.removeWhere((element) => element.id == product.id);
    }

    notifyListeners();
  }

  isWishlist(ProductModel product){
    if(_wishlist.indexWhere((element) => element.id == product.id) == -1){
      return false;
    }else{
      return true;
    }
  }

  Future<void> getProducts() async {

    try{
      List<ProductModel> products = await ProductService().getProducts();
      _wishlist = products;

    }catch (e){
      print(e);

    }
  }

}