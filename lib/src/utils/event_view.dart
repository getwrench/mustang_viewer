class EventView {
  const EventView({
    required this.timestamp,
    required this.modelName,
    required this.modelData,
  });

  static const String _timestamp = 'timestamp';
  static const String _modelName = 'modelName';
  static const String _modelData = 'modelData';

  static EventView fromJson(Map<String, dynamic> json) {
    return EventView(
      timestamp: json[_timestamp] ?? 0,
      modelName: json[_modelName] ?? '{}',
      modelData: json[_modelData] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _timestamp: timestamp,
      _modelName: modelName,
      _modelData: modelData,
    };
  }

  final int timestamp;
  final String modelName;
  final String modelData;
}
