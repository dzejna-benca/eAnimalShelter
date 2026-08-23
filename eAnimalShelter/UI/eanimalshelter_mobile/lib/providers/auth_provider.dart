import 'dart:convert';
import '../utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/register_request.dart';

class AuthProvider extends ChangeNotifier {
  static AuthProvider? instance;
  static String? accessToken;
  static String? refreshToken;
  static Future<bool>? _refreshFuture;
  static bool _isRefreshing = false;

  String? role;

  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;

  AuthProvider() {
    instance = this;
  }

  bool isAuthenticated = false;

  final String _baseUrl =
    "${AppConfig.apiUrl}Access";

  

  Future<String> login(
  String username,
  String password,
) async {
  var url = "$_baseUrl/Login";


  try {
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      final data = jsonDecode(response.body);

      accessToken = data["accessToken"];
      refreshToken = data["refreshToken"];

      role = data["role"];

      firstName = data["firstName"];
      lastName = data["lastName"];
      email = data["email"];
      phoneNumber = data["phoneNumber"];

      await saveAuthData();

      isAuthenticated = true;

      notifyListeners();

      return role!;
    }

    throw Exception(
      "Status ${response.statusCode}: ${response.body}",
    );
  } catch (e) {
    rethrow;
  }
}

  Future<void> logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();

    accessToken = null;
    refreshToken = null;

    role = null;
    firstName = null;
    lastName = null;
    email = null;
    phoneNumber = null;

    isAuthenticated = false;

    notifyListeners();
  }



  Future<void> forceLogout() async {
    await logout();
  }
  Future<void> saveAuthData() async 
  { 
    final prefs = await SharedPreferences.getInstance(); 
    
    await prefs.setString( "accessToken", accessToken ?? "", );
    
    await prefs.setString( "refreshToken", refreshToken ?? "", ); 
    
    await prefs.setString( "role", role ?? "", ); 
    
    await prefs.setString( "firstName", firstName ?? "", ); 
    
    await prefs.setString( "lastName", lastName ?? "", ); 
    
    await prefs.setString( "email", email ?? "", ); 
    
    await prefs.setString( "phoneNumber", phoneNumber ?? "", ); 
    
    }
  
 
  Future<void> register(
    RegisterRequest request,
  ) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/Register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        request.toJson(),
      ),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return;
    }

    throw Exception(
      "Registration failed",
    );
  }
  Future<bool> _doRefresh() async {

  if (refreshToken == null ||
      refreshToken!.isEmpty) {
    return false;
  }

  final response = await http.post(
      Uri.parse("$_baseUrl/LoginWithRefreshToken"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "refreshToken": refreshToken,
      }),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {

      final data = jsonDecode(response.body);

      accessToken = data["accessToken"];
      refreshToken = data["refreshToken"];

      role = data["role"];
      firstName = data["firstName"];
      lastName = data["lastName"];
      email = data["email"];
      phoneNumber = data["phoneNumber"];

      await saveAuthData();

      notifyListeners();

      return true;
    }

    await logout();

    return false;
  }
 Future<bool> refreshAccessToken() async {
  if (_isRefreshing) {
    return await _refreshFuture!;
  }

  _isRefreshing = true;

  _refreshFuture = _doRefresh();

  final result = await _refreshFuture!;

  _isRefreshing = false;
  _refreshFuture = null;

  return result;
}
  Future<bool> tryAutoLogin() async { 
    final prefs = await SharedPreferences.getInstance();
     accessToken = prefs.getString("accessToken"); 
     refreshToken = prefs.getString("refreshToken"); 
     role = prefs.getString("role"); 
     firstName = prefs.getString("firstName"); 
     lastName = prefs.getString("lastName"); 
     email = prefs.getString("email"); 
     phoneNumber = prefs.getString("phoneNumber"); 
     if (accessToken == null || accessToken!.isEmpty)
      { 
        return false; 
      } 
      isAuthenticated = true; 
      return true; 
      }
}