import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wheel_configuration.dart';
import '../models/wheel_option.dart';

class ConfigurationService {
  static const String _configsKey = 'wheel_configurations';
  static const String _currentIndexKey = 'current_config_index';

  static Future<List<WheelConfiguration>> loadConfigurations() async {
    final prefs = await SharedPreferences.getInstance();
    final configsJson = prefs.getString(_configsKey);
    
    if (configsJson == null) {
      return _getDefaultConfigurations();
    }
    
    try {
      final configsList = jsonDecode(configsJson) as List;
      return configsList
          .map((config) => WheelConfiguration.fromJson(config))
          .toList();
    } catch (e) {
      return _getDefaultConfigurations();
    }
  }

  static Future<void> saveConfigurations(List<WheelConfiguration> configurations) async {
    final prefs = await SharedPreferences.getInstance();
    final configsJson = jsonEncode(
      configurations.map((config) => config.toJson()).toList()
    );
    await prefs.setString(_configsKey, configsJson);
  }

  static Future<int> getCurrentConfigIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentIndexKey) ?? 0;
  }

  static Future<void> setCurrentConfigIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentIndexKey, index);
  }

  static List<WheelConfiguration> _getDefaultConfigurations() {
    return [
      WheelConfiguration(
        id: '1',
        name: 'Food Choices',
        options: [
          WheelOption(id: '1', label: 'Pizza', color: 'FF5722'),
          WheelOption(id: '2', label: 'Burger', color: '8BC34A'),
          WheelOption(id: '3', label: 'Sushi', color: '2196F3'),
          WheelOption(id: '4', label: 'Tacos', color: 'FFC107'),
          WheelOption(id: '5', label: 'Pasta', color: '9C27B0'),
          WheelOption(id: '6', label: 'Salad', color: '4CAF50'),
        ],
        nextIndex: 1,
      ),
      WheelConfiguration(
        id: '2',
        name: 'Activities',
        options: [
          WheelOption(id: '1', label: 'Movies', color: 'E91E63'),
          WheelOption(id: '2', label: 'Sports', color: '3F51B5'),
          WheelOption(id: '3', label: 'Reading', color: '795548'),
          WheelOption(id: '4', label: 'Gaming', color: 'FF9800'),
          WheelOption(id: '5', label: 'Walking', color: '009688'),
        ],
        nextIndex: 2,
      ),
      WheelConfiguration(
        id: '3',
        name: 'Rewards',
        options: [
          WheelOption(id: '1', label: 'Ice Cream', color: 'FFEB3B'),
          WheelOption(id: '2', label: 'New Book', color: '607D8B'),
          WheelOption(id: '3', label: 'Movie Night', color: 'F44336'),
          WheelOption(id: '4', label: 'Day Off', color: '673AB7'),
        ],
      ),
    ];
  }
}