class EventView {
  const EventView(
    this.timestamp,
    this.data,
  );

  static EventView fromJson(Map<String, dynamic> json) {
    int ts = json['timestamp'] ?? 0;
    String data = json['data'] ?? '';
    return EventView(ts, data);
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'data': data,
    };
  }

  final int timestamp;
  final String data;
}
