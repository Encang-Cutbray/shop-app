class EndpointDev {
  static final signup =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA8E5_UK_j-IyICfeeL5zYnlSsms16eoZI';

  static final signin =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA8E5_UK_j-IyICfeeL5zYnlSsms16eoZI';

  static String urlDev() {
    return 'https://flutter-shop-app-214.firebaseio.com';
  }

  static String allProducts(String authToken) {
    return 'https://flutter-shop-app-214.firebaseio.com/product.json?auth=$authToken';
  }
  
  static String productsPerUser(String authToken, String userId) {
    return 'https://flutter-shop-app-214.firebaseio.com/product.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
  }

  static String updateOrDeleteProduct(String id, String authToken) {
    return 'https://flutter-shop-app-214.firebaseio.com/product/$id.json?auth=$authToken';
  }

  static String orders(String authToken, String userId) {
    return 'https://flutter-shop-app-214.firebaseio.com/orders/$userId.json?auth=$authToken';
  }

  static String userFavoriteProduct(
      String userId, String productid, String authToken) {
    return 'https://flutter-shop-app-214.firebaseio.com/userFavorites/$userId/$productid.json?auth=$authToken';
  }

  static String userFavorite(
      String userId, String authToken) {
    return 'https://flutter-shop-app-214.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
  }
}
