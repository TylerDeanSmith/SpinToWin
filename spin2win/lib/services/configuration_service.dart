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
        name: 'Number of Colours',
        options: [
          WheelOption(id: '1', label: '1', color: 'FF5722'),
          WheelOption(id: '2', label: '2', color: '8BC34A'),
          WheelOption(id: '3', label: '3', color: '2196F3'),
          WheelOption(id: '4', label: '4', color: 'FFC107'),
          WheelOption(id: '5', label: '5', color: '9C27B0'),
        ],
        nextIndex: 1,
      ),
      WheelConfiguration(
        id: '2',
        name: 'Choose Your Colours',
        options: [
          WheelOption(id: '1', label: 'Brown/Neutrals', color: '827146'),
          WheelOption(id: '2', label: 'Yellow', color: 'FFF400'),
          WheelOption(id: '3', label: 'Pink', color: 'FF85FF'),
          WheelOption(id: '4', label: 'Green', color: '149E03'),
          WheelOption(id: '5', label: 'Purple', color: 'A200FF'),
          WheelOption(id: '6', label: 'Orange', color: 'FF7100'),
          WheelOption(id: '7', label: 'Grey', color: '7D7C7C'),
          WheelOption(id: '8', label: 'Red', color: 'F52727'),
          WheelOption(id: '9', label: 'Turquoise', color: '27F5E7'),
          WheelOption(id: '10', label: 'Blue', color: '273FF5'),
        ],
        nextIndex: 2,
      ),
      WheelConfiguration(
        id: '3',
        name: 'Nail Art',
        options: [
          WheelOption(id: '1', label: 'Yes', color: 'FFEB3B'),
          WheelOption(id: '2', label: 'No', color: '607D8B'),
          WheelOption(id: '3', label: 'Yes', color: 'F44336'),
          WheelOption(id: '4', label: 'No', color: '673AB7'),
          WheelOption(id: '5', label: 'Yes', color: 'FFEB3B'),
          WheelOption(id: '6', label: 'No', color: '607D8B'),
          WheelOption(id: '7', label: 'Yes', color: 'F44336'),
          WheelOption(id: '8', label: 'No', color: '673AB7'),
          WheelOption(id: '9', label: 'Yes', color: 'FFEB3B'),
          WheelOption(id: '10', label: 'No', color: '607D8B'),
          WheelOption(id: '11', label: 'Yes', color: 'F44336'),
          WheelOption(id: '12', label: 'No', color: '673AB7'),
        ],
        nextIndex: 3,
      ),
      WheelConfiguration(
        id: '4',
        name: 'Nail Art',
        options: [
          WheelOption(id: '1', label: 'Ripple Gel', color: 'FFEB3B'),
          WheelOption(id: '2', label: 'Glitter / Glitter Gel', color: '607D8B'),
          WheelOption(id: '3', label: 'Chrome', color: 'F44336'),
          WheelOption(id: '4', label: 'Stickers', color: 'df3477'),
          WheelOption(id: '5', label: 'Stamps', color: '19d0dd'),
          WheelOption(id: '6', label: 'French', color: '673AB7'),
          WheelOption(id: '7', label: 'Ombre', color: '9a25a3'),
          WheelOption(id: '8', label: 'Colour Block', color: '743033'),
          WheelOption(id: '9', label: 'Cats Eye', color: '0b062b'),
          WheelOption(id: '10', label: 'Nail Gems', color: 'be7283'),
          WheelOption(id: '11', label: 'Blooming Gel', color: 'a31657'),
        ],
        nextIndex: 4,
      ),
      WheelConfiguration(
        id: '5',
        name: 'Top Coat',
        options: [
          WheelOption(id: '1', label: 'Flake', color: 'FFEB3B'),
          WheelOption(id: '2', label: 'Gloss', color: '607D8B'),
          WheelOption(id: '3', label: 'Matt', color: 'F44336'),
          WheelOption(id: '4', label: 'Flake', color: '673AB7'),
        ],
      ),
    ];
  }
}