class EndpointDev {
  static final signup =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA8E5_UK_j-IyICfeeL5zYnlSsms16eoZI';

  static final signin =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA8E5_UK_j-IyICfeeL5zYnlSsms16eoZI';

  static String urlDev() {
    return 'https://flutter-shop-app-214.firebaseio.com';
  }

  static String products(String authToken) {
    return 'https://flutter-shop-app-214.firebaseio.com/product.json?auth=$authToken';
  }

  static String updateOrDeleteProduct(String id, String authToken) {
    return 'https://flutter-shop-app-214.firebaseio.com/product/$id.json?auth=$authToken';
  }

  static String orders(String authToken) {
    return 'https://flutter-shop-app-214.firebaseio.com/order.json?auth=$authToken';
  }
}
