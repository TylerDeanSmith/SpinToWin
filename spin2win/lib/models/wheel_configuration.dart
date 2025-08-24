import 'wheel_option.dart';

class WheelConfiguration {
  final String id;
  final String name;
  final List<WheelOption> options;
  final int nextIndex;

  WheelConfiguration({
    required this.id,
    required this.name,
    required this.options,
    this.nextIndex = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'options': options.map((option) => option.toJson()).toList(),
      'nextIndex': nextIndex,
    };
  }

  factory WheelConfiguration.fromJson(Map<String, dynamic> json) {
    return WheelConfiguration(
      id: json['id'],
      name: json['name'],
      options: (json['options'] as List)
          .map((option) => WheelOption.fromJson(option))
          .toList(),
      nextIndex: json['nextIndex'] ?? 0,
    );
  }

  WheelConfiguration copyWith({
    String? id,
    String? name,
    List<WheelOption>? options,
    int? nextIndex,
  }) {
    return WheelConfiguration(
      id: id ?? this.id,
      name: name ?? this.name,
      options: options ?? this.options,
      nextIndex: nextIndex ?? this.nextIndex,
    );
  }
}