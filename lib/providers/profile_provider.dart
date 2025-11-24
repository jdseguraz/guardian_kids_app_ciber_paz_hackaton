import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileProvider with ChangeNotifier {
  UserProfile _profile = UserProfile(
    name: 'Usuario',
    points: 0,
    gamesWon: 0,
    gamesLost: 0,
  );

  UserProfile get profile => _profile;

  ProfileProvider() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('userProfile');
    
    if (profileJson != null) {
      final profileData = jsonDecode(profileJson);
      _profile = UserProfile.fromJson(profileData);
      notifyListeners();
    }
  }

  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = jsonEncode(_profile.toJson());
    await prefs.setString('userProfile', profileJson);
  }

  Future<void> updateName(String name) async {
    _profile = _profile.copyWith(name: name);
    await saveProfile();
    notifyListeners();
  }

  Future<void> addWin(int points) async {
    _profile = _profile.copyWith(
      points: _profile.points + points,
      gamesWon: _profile.gamesWon + 1,
    );
    await saveProfile();
    notifyListeners();
  }

  Future<void> addLoss() async {
    _profile = _profile.copyWith(
      gamesLost: _profile.gamesLost + 1,
    );
    await saveProfile();
    notifyListeners();
  }
}
