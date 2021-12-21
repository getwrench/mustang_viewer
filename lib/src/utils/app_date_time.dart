/// [AppDateTime] contains method for all DateTime manipulation
class AppDateTime {
  /// [timeForDateTime]:
  /// Input: DateTime object
  /// Output: Time (as a string)
  static String timeForDateTime(DateTime dateTime) {
    String hrs = dateTime.hour.toString().padLeft(2, '0');
    String min = dateTime.minute.toString().padLeft(2, '0');
    String sec = dateTime.second.toString().padLeft(2, '0');
    String milliSec = dateTime.millisecond.toString().padLeft(3, '0');

    return '$hrs:$min:$sec.$milliSec';
  }
}
