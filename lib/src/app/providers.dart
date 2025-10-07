import 'package:flutter_riverpod/flutter_riverpod.dart';

// Tab actual en la navegación bottom
final activeTabProvider = StateProvider<String>((ref) => 'principal');

// Modo oscuro
final isDarkModeProvider = StateProvider<bool>((ref) => true);

// Tiempo de escaneo (en segundos)
final scanTimeProvider = StateProvider<int>((ref) => 30);

// Tipo de historial para descargar al escanear
enum HistorialDownloadType { repetidor, emisor, ambos }

final historialDownloadTypeProvider = StateProvider<HistorialDownloadType>(
  (ref) => HistorialDownloadType.ambos,
);

// Filtro de dispositivo en Principal
enum DeviceFilterType { ambos, emisor, repetidor }

final deviceFilterProvider = StateProvider<DeviceFilterType>(
  (ref) => DeviceFilterType.ambos,
);

// Estado de escaneo
final isScanningProvider = StateProvider<bool>((ref) => false);

// Filtros avanzados en Principal
final macFilterProvider = StateProvider<String>((ref) => '');
final macFilterEnabledProvider = StateProvider<bool>((ref) => false);
final rssiFilterProvider = StateProvider<int>((ref) => -100);
final rssiFilterEnabledProvider = StateProvider<bool>((ref) => false);

// Filtros en Escanear
final filtersEnabledProvider = StateProvider<bool>((ref) => false);
final macSearchProvider = StateProvider<String>((ref) => '');
final rssiThresholdProvider = StateProvider<int>((ref) => -80);
final identifiersProvider = StateProvider<List<String>>((ref) => []);

// Tipo de historial en Principal
enum HistorialViewType { advertising, descargados, ambos }

final historialViewTypeProvider = StateProvider<HistorialViewType>(
  (ref) => HistorialViewType.advertising,
);
