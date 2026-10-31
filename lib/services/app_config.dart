class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();
   static String baseUrl = "https://bevco.besterpsolution.in/public/api/";
  // static String baseUrl = "http://kadampuzhakioskapp.templesoftware.in/public/api/";
  static String? accessToken;
  static String? counterID;
  static int? customerId;
  static String? customerName;
  static String? customerNumber;
  static String? settings;
  static int? version = 1;
}
