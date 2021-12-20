class EventView {
  const EventView(
    this.timestamp,
    this.data,
    this.label,
  );

  static EventView fromJson(Map<String, dynamic> json) {
    int ts = json['timestamp'] ?? 0;
    String data = json['data'] ?? '{}';
    String label = json['label'] ?? 'N/A';
    return EventView(ts, data, label);
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'data': data,
      'label': label,
    };
  }

  final int timestamp;
  final String data;
  final String label;
}
