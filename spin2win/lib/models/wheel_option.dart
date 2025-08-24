class WheelOption {
  final String id;
  final String label;
  final String color;

  WheelOption({
    required this.id,
    required this.label,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'color': color,
    };
  }

  factory WheelOption.fromJson(Map<String, dynamic> json) {
    return WheelOption(
      id: json['id'],
      label: json['label'],
      color: json['color'],
    );
  }

  WheelOption copyWith({
    String? id,
    String? label,
    String? color,
  }) {
    return WheelOption(
      id: id ?? this.id,
      label: label ?? this.label,
      color: color ?? this.color,
    );
  }
}