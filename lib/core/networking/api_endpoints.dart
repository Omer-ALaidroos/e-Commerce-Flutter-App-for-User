class ApiEndpoints {
  static const String baseUrl = "http://10.0.2.2:5214";
  static const String allCategories = "/api/Category/All";
 static const String allProducts = "/api/Product/Available";
  static const String searchProducts = "/api/Product/search";
  static const String register = "/api/Authentication/create";
  static const String productsByCategoryId = "/api/Product/category/";

  static const String login = "/api/Authentication/login";
   static const String myCarts = "/api/Cart/my-cart";
  static const String addToCart = "/api/Cart/add";
  static const String removeCartItem = "/api/Cart/remove";
  static const String incrementCartItem = "/api/Cart/increment-quentitey";
  static const String decrementCartItem = "/api/Cart/decrement-quentitey";
  static const String checkout = "/api/Order/Checkout";
  static const String myOrderSummaries = "/api/Order/OrderSummaries";
  static const String orderDetailsByOrderId = "/api/Order/GetById";
  static const String getOrderStatusByOrderId = "/api/Order/GetStatusByOrderId";
  static const String updateFullName = "/api/User/UpdateFullName";
  static const String updatePhoneNumber = "/api/User/UpdatePhoneNumber";
  static const String userDetailsById = "/api/User/GetUserById";
  static const String updatePassword = "/api/Authentication/ChangePassword";
  static const String forgotPassword = "/api/Authentication/ForgotPassword";
  static const String userAddresses = "/api/Address/GetUserAddress";
  static const String addAddress = "/api/Address/Add";
  static const String deleteAddress = "/api/Address/Delete";
  static const String verifyResetCode = "/api/Authentication/VerifyOTPCode";
  static const String resetPassword = "/api/Authentication/ResetPassword";

  static const String refreshToken = "/api/Authentication/refreshtoken";

  static const String getProductDetails = "/api/Product/GetByIdForUser";
  static const String canReview = "/api/ProductReview/can-review";
  static const String addReview = "/api/ProductReview/Add";
  
  static const String addFavorite = "/api/Product/AddToFavorite";
  static const String removeFavorite = "/api/Product/RemoveFromFavorite";
  static const String myFavorites = "/api/Product/MyFavorites";

  static const String getPaymentIntent = "/api/Payment/pay-order";
}
