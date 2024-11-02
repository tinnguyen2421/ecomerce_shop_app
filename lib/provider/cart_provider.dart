import 'package:ecomerce_shop_app/models/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//define a StateNotifierProvider to expose an instance of the CartNotifier
//Making it accessible within our app
final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier();
});

//a Notifier class to manage the cart state , extending stateNotifier
//with an initial state of an empty map
class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({});
  //method to add product to the cart
  void addProductToCart({
    required String productName,
    required int productPrice,
    required String category,
    required List<String> image,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
    required String fullName,
  }) {
    //check if the product is already in the cart
    if (state.containsKey(productId)) {
      //if the product is already in the cart update its quantity and maybe other detail
      state = {
        ...state,
        productId: Cart(
          productName: state[productId]!.productName,
          productPrice: state[productId]!.productPrice,
          category: state[productId]!.category,
          image: state[productId]!.image,
          vendorId: state[productId]!.vendorId,
          productQuantity: state[productId]!.productQuantity,
          quantity: state[productId]!.quantity + 1,
          productId: state[productId]!.productId,
          description: state[productId]!.description,
          fullName: state[productId]!.fullName,
        )
      };
    } else {
      //if the product is not in the cart , add id with the provided details
      state = {
        ...state,
        productId: Cart(
            productName: productName,
            productPrice: productPrice,
            category: category,
            image: image,
            vendorId: vendorId,
            productQuantity: productQuantity,
            quantity: quantity,
            productId: productId,
            description: description,
            fullName: fullName)
      };
    }
  }

//method to increment the quantity of a product in the cart
  void incrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;

      //Notify listeners that the state has changed
      state = {...state};
    }
  }

  //Method to decrement the quantity of a product in the cart
  void decrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;

      //Notify listeners that the state has changed
      state = {...state};
    }
  }

  //Method to remove item from the cart
  void removeCartItem(String productId) {
    state.remove(productId);
    //notify listeners that the state chang
    state = {...state};
  }

  //Method to calculate total amout of items we have in cart
  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.quantity * cartItem.productPrice;
    });
    return totalAmount;
  }
}
