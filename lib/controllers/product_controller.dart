import 'dart:convert';

import 'package:ecomerce_shop_app/global_variables.dart';
import 'package:ecomerce_shop_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductController {
  //Define a function that returns a future containing list of the product model objects
  Future<List<Product>> loadPopularProducts() async {
    // use  a try block to handle any exceptions that might occur in the http request proccss
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/popular-products"),
        // set the http headers for the request , specifying that the content type is json with the UTF-8 encoding
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8 ',
        },
      );
      //print(response.body);
      //check if the HTTP response status code is 200, whihc means  the request was successfull

      if (response.statusCode == 200) {
        //Decode the json response body into a list  of dynamic object
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        //map each items in the list to product model object which we can use

        List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        //if status code is not 200 , throw an execption   indicating failure to load the popular products
        throw Exception('Failed to load popular products');
      }
    } catch (e) {
      throw Exception('Error loading product : $e');
    }
  }

//load product by category function
  Future<List<Product>> loadProductByCategory(String category) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products-by-category/$category'),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8 ',
        },
      );
      if (response.statusCode == 200) {
        //Decode the json response body into a list  of dynamic object
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        //map each items in the list to product model object which we can use

        List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        //if status code is not 200 , throw an execption   indicating failure to load the popular products
        throw Exception('Failed to load popular products');
      }
    } catch (e) {
      throw Exception('Error loading product : $e');
    }
  }

  //display related products by subcategory
  Future<List<Product>> loadRelatedProductsBySubcategory(
      String productId) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/related-products-by-subcategory/$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8 ',
        },
      );
      if (response.statusCode == 200) {
        //Decode the json response body into a list  of dynamic object
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        //map each items in the list to product model object which we can use

        List<Product> relatedProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return relatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        //if status code is not 200 , throw an execption   indicating failure to load the popular products
        throw Exception('Failed to load related products');
      }
    } catch (e) {
      throw Exception('Error related product : $e');
    }
  }

  //method to get the top 10 highest-rated products
  Future<List<Product>> loadTopRatedProduct() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/top-rated-products'),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8 ',
        },
      );
      if (response.statusCode == 200) {
        //Decode the json response body into a list  of dynamic object
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        //map each items in the list to product model object which we can use

        List<Product> topRatedProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return topRatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        //if status code is not 200 , throw an execption   indicating failure to load the popular products
        throw Exception('Failed to load top Rated  products');
      }
    } catch (e) {
      throw Exception('Error related product : $e');
    }
  }

  //method to load all products
  Future<List<Product>> loadAllProduct() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/all-products'),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8 ',
        },
      );
      if (response.statusCode == 200) {
        //Decode the json response body into a list  of dynamic object
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        //map each items in the list to product model object which we can use

        List<Product> Products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return Products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        //if status code is not 200 , throw an execption   indicating failure to load the popular products
        throw Exception('Failed to load all  products');
      }
    } catch (e) {
      throw Exception('Error alll product : $e');
    }
  }

  //get product by subcategoy
  Future<List<Product>> loadProductBySubcategory(String subCategoryName) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products-by-subcategory/$subCategoryName'),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8 ',
        },
      );
      if (response.statusCode == 200) {
        //Decode the json response body into a list  of dynamic object
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        //map each items in the list to product model object which we can use
        print(response.body);
        List<Product> Products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return Products;
      } else if (response.statusCode == 404) {
        print(null);
        return [];
      } else {
        //if status code is not 200 , throw an execption   indicating failure to load the popular products
        throw Exception('Failed to load products by subcategory Name');
      }
    } catch (e) {
      throw Exception('Error subcategory Name : $e');
    }
  }

  Future<List<Product>> loadProductsBySubcategory(String subCategory) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products-by-subcategory/$subCategory'),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8 ',
        },
      );
      if (response.statusCode == 200) {
        //Decode the json response body into a list  of dynamic object
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        //map each items in the list to product model object which we can use

        List<Product> relatedProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return relatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        //if status code is not 200 , throw an execption   indicating failure to load the popular products
        throw Exception('Failed to load subCategory products');
      }
    } catch (e) {
      throw Exception('Error subCategory product : $e');
    }
  }

  //method for searching product by Name
  Future<List<Product>> searchProducts(String query) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/search-products?query=$query'),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8 ',
        },
      );
      if (response.statusCode == 200) {
        print("Dữ liệu trả về: ${response.body}");
        //Decode the json response body into a list  of dynamic object
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        //map each items in the list to product model object which we can use

        List<Product> searchedProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return searchedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        //if status code is not 200 , throw an execption   indicating failure to load the popular products
        throw Exception('Failed to searched products');
      }
    } catch (e) {
      throw Exception('Error searched product : $e');
    }
  }

  Future<List<Product>> loadVendorProducts(String vendorId) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      http.Response response = await http.get(
        Uri.parse('$uri/api/products/vendor/$vendorId'),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8 ',
          "x-auth-token": token!,
        },
      );
      print('subcategory product response..${response.body}');
      if (response.statusCode == 200) {
        //Decode the json response body into a list  of dynamic object
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        //map each items in the list to product model object which we can use

        List<Product> vendorProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return vendorProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        //if status code is not 200 , throw an execption   indicating failure to load the popular products
        throw Exception('Failed to load vendors products');
      }
    } catch (e) {
      throw Exception('Error vendors product : $e');
    }
  }
}
