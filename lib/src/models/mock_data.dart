import '../models/device.dart';
import '../models/historial_data.dart';

class MockData {
  // Dispositivos para escaneo
  static final List<Device> scanDevices = [
    const Device(
      macAddress: "AA:BB:CC:DD:EE:01",
      deviceType: DeviceType.emisor,
      rssi: -45,
      historiales: 234,
      connected: false,
      adc1: 1024,
      adc2: 896,
      desgaste: 2.5,
    ),
    Device(
      macAddress: "AA:BB:CC:DD:EE:02",
      deviceType: DeviceType.repetidor,
      rssi: -62,
      historiales: 156,
      connected: true,
      linkedEmitter: const LinkedEmitter(
        macAddress: "AA:BB:CC:DD:EE:01",
        rssi: -45,
        historiales: 234,
        adc1: 1024,
        adc2: 896,
        desgaste: 2.5,
      ),
    ),
    const Device(
      macAddress: "AA:BB:CC:DD:EE:03",
      deviceType: DeviceType.repetidor,
      rssi: -51,
      historiales: 123,
      connected: false,
    ),
    Device(
      macAddress: "AA:BB:CC:DD:EE:04",
      deviceType: DeviceType.repetidor,
      rssi: -58,
      historiales: 189,
      connected: true,
      linkedEmitter: const LinkedEmitter(
        macAddress: "AA:BB:CC:DD:EE:05",
        rssi: -52,
        historiales: 298,
        adc1: 1200,
        adc2: 850,
        desgaste: 0.9,
      ),
    ),
  ];

  // Dispositivos de historial de Advertising
  static final List<HistorialDevice> advertisingDevices = [
    const HistorialDevice(
      mac: "AA:BB:CC:DD:EE:01",
      name: "Emisor-01",
      type: DeviceType.emisor,
      rssi: -45,
      packets: 234,
      lastSeen: "10:23:15",
    ),
    const HistorialDevice(
      mac: "AA:BB:CC:DD:EE:02",
      name: "Repetidor-01",
      type: DeviceType.repetidor,
      rssi: -62,
      packets: 189,
      lastSeen: "10:23:12",
    ),
    const HistorialDevice(
      mac: "AA:BB:CC:DD:EE:03",
      name: "Emisor-02",
      type: DeviceType.emisor,
      rssi: -51,
      packets: 156,
      lastSeen: "10:23:10",
    ),
    const HistorialDevice(
      mac: "AA:BB:CC:DD:EE:04",
      name: "Repetidor-02",
      type: DeviceType.repetidor,
      rssi: -78,
      packets: 98,
      lastSeen: "10:23:08",
    ),
    const HistorialDevice(
      mac: "AA:BB:CC:DD:EE:05",
      name: "Emisor-03",
      type: DeviceType.emisor,
      rssi: -54,
      packets: 178,
      lastSeen: "10:23:05",
    ),
    const HistorialDevice(
      mac: "AA:BB:CC:DD:EE:06",
      name: "Repetidor-03",
      type: DeviceType.repetidor,
      rssi: -68,
      packets: 142,
      lastSeen: "10:23:02",
    ),
  ];

  // Dispositivos de historial de Descargados
  static final List<HistorialDevice> descargadosDevices = [
    const HistorialDevice(
      mac: "BB:CC:DD:EE:FF:01",
      name: "Emisor-DL-01",
      type: DeviceType.emisor,
      rssi: -52,
      packets: 1420,
      lastSeen: "09:45:30",
    ),
    const HistorialDevice(
      mac: "BB:CC:DD:EE:FF:02",
      name: "Repetidor-DL-01",
      type: DeviceType.repetidor,
      rssi: -65,
      packets: 890,
      lastSeen: "09:45:25",
    ),
    const HistorialDevice(
      mac: "BB:CC:DD:EE:FF:03",
      name: "Emisor-DL-02",
      type: DeviceType.emisor,
      rssi: -48,
      packets: 2103,
      lastSeen: "09:45:20",
    ),
    const HistorialDevice(
      mac: "BB:CC:DD:EE:FF:04",
      name: "Repetidor-DL-02",
      type: DeviceType.repetidor,
      rssi: -72,
      packets: 654,
      lastSeen: "09:45:15",
    ),
  ];

  // Generar datos de historial temporal para un dispositivo
  static DeviceHistorialData generateHistorialData(HistorialDevice device) {
    final now = DateTime.now();
    final entries = <HistorialEntry>[];
    
    // Generar entradas para las últimas 24 horas (1 entrada cada 15 minutos)
    for (int i = 96; i >= 0; i--) {
      final timestamp = now.subtract(Duration(minutes: i * 15));
      final isEmisor = device.type == DeviceType.emisor;
      
      // Simular variaciones en RSSI
      final rssiBase = device.rssi;
      final rssiVariation = (i % 8) - 4; // Variación de ±4 dBm
      
      entries.add(HistorialEntry(
        timestamp: timestamp,
        rssi: rssiBase + rssiVariation,
        adc1: isEmisor ? 950 + (i % 150) : null,
        adc2: isEmisor ? 800 + (i % 100) : null,
        desgaste: isEmisor ? 1.0 + (i % 10) * 0.2 : null,
        bateria: 85.0 + (i % 15),
      ));
    }
    
    return DeviceHistorialData(
      macAddress: device.mac,
      deviceName: device.name,
      deviceType: device.type == DeviceType.emisor ? 'Emisor' : 'Repetidor',
      entries: entries,
      totalPackets: device.packets,
      lastUpdate: now,
    );
  }
}
