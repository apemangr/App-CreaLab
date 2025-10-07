enum DeviceType {
  emisor('Emisor'),
  repetidor('Repetidor');

  final String displayName;
  const DeviceType(this.displayName);
}

class LinkedEmitter {
  final String macAddress;
  final int rssi;
  final int historiales;
  final int? adc1;
  final int? adc2;
  final double? desgaste;

  const LinkedEmitter({
    required this.macAddress,
    required this.rssi,
    required this.historiales,
    this.adc1,
    this.adc2,
    this.desgaste,
  });

  LinkedEmitter copyWith({
    String? macAddress,
    int? rssi,
    int? historiales,
    int? adc1,
    int? adc2,
    double? desgaste,
  }) {
    return LinkedEmitter(
      macAddress: macAddress ?? this.macAddress,
      rssi: rssi ?? this.rssi,
      historiales: historiales ?? this.historiales,
      adc1: adc1 ?? this.adc1,
      adc2: adc2 ?? this.adc2,
      desgaste: desgaste ?? this.desgaste,
    );
  }
}

class Device {
  final String macAddress;
  final DeviceType deviceType;
  final int rssi;
  final int historiales;
  final bool connected;
  final int? adc1;
  final int? adc2;
  final double? desgaste;
  final LinkedEmitter? linkedEmitter;

  const Device({
    required this.macAddress,
    required this.deviceType,
    required this.rssi,
    required this.historiales,
    this.connected = false,
    this.adc1,
    this.adc2,
    this.desgaste,
    this.linkedEmitter,
  });

  Device copyWith({
    String? macAddress,
    DeviceType? deviceType,
    int? rssi,
    int? historiales,
    bool? connected,
    int? adc1,
    int? adc2,
    double? desgaste,
    LinkedEmitter? linkedEmitter,
  }) {
    return Device(
      macAddress: macAddress ?? this.macAddress,
      deviceType: deviceType ?? this.deviceType,
      rssi: rssi ?? this.rssi,
      historiales: historiales ?? this.historiales,
      connected: connected ?? this.connected,
      adc1: adc1 ?? this.adc1,
      adc2: adc2 ?? this.adc2,
      desgaste: desgaste ?? this.desgaste,
      linkedEmitter: linkedEmitter ?? this.linkedEmitter,
    );
  }
}

class HistorialDevice {
  final String mac;
  final String name;
  final DeviceType type;
  final int rssi;
  final int packets;
  final String lastSeen;

  const HistorialDevice({
    required this.mac,
    required this.name,
    required this.type,
    required this.rssi,
    required this.packets,
    required this.lastSeen,
  });

  HistorialDevice copyWith({
    String? mac,
    String? name,
    DeviceType? type,
    int? rssi,
    int? packets,
    String? lastSeen,
  }) {
    return HistorialDevice(
      mac: mac ?? this.mac,
      name: name ?? this.name,
      type: type ?? this.type,
      rssi: rssi ?? this.rssi,
      packets: packets ?? this.packets,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
