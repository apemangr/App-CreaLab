class HistorialEntry {
  final DateTime timestamp;
  final int rssi;
  final int? adc1;
  final int? adc2;
  final double? desgaste;
  final double? bateria;

  const HistorialEntry({
    required this.timestamp,
    required this.rssi,
    this.adc1,
    this.adc2,
    this.desgaste,
    this.bateria,
  });
}

class DeviceHistorialData {
  final String macAddress;
  final String deviceName;
  final String deviceType;
  final List<HistorialEntry> entries;
  final int totalPackets;
  final DateTime? lastUpdate;

  const DeviceHistorialData({
    required this.macAddress,
    required this.deviceName,
    required this.deviceType,
    required this.entries,
    required this.totalPackets,
    this.lastUpdate,
  });

  // Estadísticas calculadas
  double get averageRssi => entries.isNotEmpty
      ? entries.map((e) => e.rssi).reduce((a, b) => a + b) / entries.length
      : 0;

  int get maxRssi => entries.isNotEmpty
      ? entries.map((e) => e.rssi).reduce((a, b) => a > b ? a : b)
      : 0;

  int get minRssi => entries.isNotEmpty
      ? entries.map((e) => e.rssi).reduce((a, b) => a < b ? a : b)
      : 0;

  double? get averageAdc1 {
    final validEntries = entries.where((e) => e.adc1 != null).toList();
    if (validEntries.isEmpty) return null;
    return validEntries.map((e) => e.adc1!).reduce((a, b) => a + b) / validEntries.length;
  }

  double? get averageAdc2 {
    final validEntries = entries.where((e) => e.adc2 != null).toList();
    if (validEntries.isEmpty) return null;
    return validEntries.map((e) => e.adc2!).reduce((a, b) => a + b) / validEntries.length;
  }

  double? get averageDesgaste {
    final validEntries = entries.where((e) => e.desgaste != null).toList();
    if (validEntries.isEmpty) return null;
    return validEntries.map((e) => e.desgaste!).reduce((a, b) => a + b) / validEntries.length;
  }

  double? get averageBateria {
    final validEntries = entries.where((e) => e.bateria != null).toList();
    if (validEntries.isEmpty) return null;
    return validEntries.map((e) => e.bateria!).reduce((a, b) => a + b) / validEntries.length;
  }
}
