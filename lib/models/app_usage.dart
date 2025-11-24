class AppUsageInfo {
  final String appName;
  final String packageName;
  final int usageTimeInMinutes;
  final DateTime lastTimeUsed;

  AppUsageInfo({
    required this.appName,
    required this.packageName,
    required this.usageTimeInMinutes,
    required this.lastTimeUsed,
  });

  String get formattedUsageTime {
    if (usageTimeInMinutes < 60) {
      return '$usageTimeInMinutes min';
    } else {
      final hours = (usageTimeInMinutes / 60).floor();
      final minutes = usageTimeInMinutes % 60;
      return '${hours}h ${minutes}min';
    }
  }
}
