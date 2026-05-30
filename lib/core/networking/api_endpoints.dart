class ApiEndpoints {
  static const String baseUrl = "http://10.0.2.2:5214";
  static const String allCategories = "/api/Category/All";
 static const String allProducts = "/api/Product/All";
  static const String register = "/api/Authentication/create";
  static const String productsByCategoryId = "/api/Product/GetProductByCategoryId";

  static const String login = "/api/Authentication/login";
   static const String myCarts = "/api/Cart/my-cart";
  static const String addToCart = "/api/Cart/add";
  static const String removeCartItem = "/api/Cart/remove";
  static const String incrementCartItem = "/api/Cart/increment-quentitey";
  static const String decrementCartItem = "/api/Cart/decrement-quentitey";
  static const String checkout = "/api/Order/Create";
  static const String myOrderSummaries = "/api/Order/OrderSummaries";
  static const String orderDetailsByOrderId = "/api/Order/GetById";
  static const String updateFullName = "/api/User/UpdateFullName";
  static const String updatePhoneNumber = "/api/User/UpdatePhoneNumber";
  static const String userDetailsById = "/api/User/GetUserById";
  static const String updatePassword = "/api/Authentication/ChangePassword";
 



 
  static const String refreshToken = "/auth/refresh-token";

  static const String carts = "/carts";

  static const String products = "/products";
  static const String categories = "/products/categories";

  static const String catProducts = "/category";
}
