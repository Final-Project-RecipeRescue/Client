import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotenvConstants {
  static String apiKey = dotenv.env['FIREBASE_API_KEY'] ?? 'noKey';
  static String appId = dotenv.env['FIREBASE_APP_ID'] ?? 'noAppId';
  static String messagingSenderId =
      dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? 'noMessagingSenderId';
  static String projectId = dotenv.env['FIREBASE_PROJECT_ID'] ?? 'noProjectId';
  static String databaseUrl =
      dotenv.env['FIREBASE_DATABASE_URL'] ?? 'noDatabaseUrl';
  static String baseUrl = dotenv.env['BASE_URL'] ?? 'noBaseUrl';
}
