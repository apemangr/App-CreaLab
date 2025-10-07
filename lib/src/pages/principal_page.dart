import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app/providers.dart';
import '../models/device.dart';
import '../models/mock_data.dart';
import '../widgets/bento_metric_card.dart';
import '../widgets/device_historial_card.dart';
import '../widgets/custom_badge.dart';
import '../dialogs/device_historial_dialog.dart';

class PrincipalPage extends ConsumerStatefulWidget {
  const PrincipalPage({super.key});

  @override
  ConsumerState<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends ConsumerState<PrincipalPage> {
  bool _filterExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final historialType = ref.watch(historialViewTypeProvider);
    final deviceFilter = ref.watch(deviceFilterProvider);
    final macFilter = ref.watch(macFilterProvider);
    final macFilterEnabled = ref.watch(macFilterEnabledProvider);
    final rssiFilter = ref.watch(rssiFilterProvider);
    final rssiFilterEnabled = ref.watch(rssiFilterEnabledProvider);

    // Obtener dispositivos según el tipo de historial
    final currentDevices = _getCurrentDevices(historialType);
    
    // Calcular métricas
    final emisorCount = currentDevices.where((d) => d.type == DeviceType.emisor).length;
    final repetidorCount = currentDevices.where((d) => d.type == DeviceType.repetidor).length;
    final totalHistoriales = currentDevices.fold(0, (sum, d) => sum + d.packets);
    final avgRssi = currentDevices.isNotEmpty
        ? (currentDevices.fold(0, (sum, d) => sum + d.rssi) / currentDevices.length).round()
        : 0;

    // Filtrar dispositivos
    final filteredDevices = currentDevices.where((device) {
      final matchesMAC = !macFilterEnabled ||
          macFilter.isEmpty ||
          device.mac.toLowerCase().contains(macFilter.toLowerCase());
      final matchesRSSI = !rssiFilterEnabled || device.rssi >= rssiFilter;
      final matchesType = deviceFilter == DeviceFilterType.ambos ||
          (deviceFilter == DeviceFilterType.emisor && device.type == DeviceType.emisor) ||
          (deviceFilter == DeviceFilterType.repetidor && device.type == DeviceType.repetidor);
      return matchesMAC && matchesRSSI && matchesType;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // App Bar
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outline, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Historial',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Tabs
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTab(
                              context,
                              'Advertising',
                              Icons.wifi,
                              historialType == HistorialViewType.advertising,
                              () => ref.read(historialViewTypeProvider.notifier).state =
                                  HistorialViewType.advertising,
                            ),
                          ),
                          Expanded(
                            child: _buildTab(
                              context,
                              'Descargados',
                              Icons.storage,
                              historialType == HistorialViewType.descargados,
                              () => ref.read(historialViewTypeProvider.notifier).state =
                                  HistorialViewType.descargados,
                            ),
                          ),
                          Expanded(
                            child: _buildTab(
                              context,
                              'Ambos',
                              Icons.layers,
                              historialType == HistorialViewType.ambos,
                              () => ref.read(historialViewTypeProvider.notifier).state =
                                  HistorialViewType.ambos,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Contenido scrolleable
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
              children: [
                // Métricas Bento
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    BentoMetricCard(
                      icon: Icons.radio,
                      label: 'Emisores',
                      value: emisorCount,
                      color: MetricColor.cyan,
                    ),
                    BentoMetricCard(
                      icon: Icons.repeat,
                      label: 'Repetidores',
                      value: repetidorCount,
                      color: MetricColor.purple,
                    ),
                    BentoMetricCard(
                      icon: Icons.signal_cellular_alt,
                      label: 'RSSI promedio',
                      value: avgRssi,
                      unit: 'dBm',
                      color: MetricColor.green,
                    ),
                    BentoMetricCard(
                      icon: Icons.access_time,
                      label: 'Total historiales',
                      value: totalHistoriales,
                      color: MetricColor.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Filtro de tipo de dispositivo
                _buildDeviceTypeFilter(context, ref, deviceFilter),
                const SizedBox(height: 16),
                // Filtros avanzados
                _buildAdvancedFilters(context, ref, theme),
                const SizedBox(height: 16),
                // Contador de dispositivos
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dispositivos (${filteredDevices.length})',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          CustomBadge(
                            label: '${filteredDevices.where((d) => d.type == DeviceType.emisor).length}',
                            isOutline: true,
                          ),
                          const SizedBox(width: 8),
                          CustomBadge(
                            label: '${filteredDevices.where((d) => d.type == DeviceType.repetidor).length}',
                            isOutline: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Lista de dispositivos
                if (filteredDevices.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.filter_alt_off,
                          size: 48,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No se encontraron dispositivos',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ajusta los filtros para ver más resultados',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...filteredDevices.map((device) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DeviceHistorialCard(
                          mac: device.mac,
                          name: device.name,
                          type: device.type == DeviceType.emisor ? 'Emisor' : 'Repetidor',
                          rssi: device.rssi,
                          packets: device.packets,
                          lastSeen: device.lastSeen,
                          onTap: () {
                            // Generar datos de historial y abrir diálogo
                            final historialData = MockData.generateHistorialData(device);
                            showDialog(
                              context: context,
                              builder: (context) => DeviceHistorialDialog(
                                historialData: historialData,
                              ),
                            );
                          },
                        ),
                      )),
                const SizedBox(height: 16),
                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('Exportar', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ref.read(macFilterProvider.notifier).state = '';
                          ref.read(macFilterEnabledProvider.notifier).state = false;
                          ref.read(rssiFilterProvider.notifier).state = -100;
                          ref.read(rssiFilterEnabledProvider.notifier).state = false;
                        },
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Resetear', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<HistorialDevice> _getCurrentDevices(HistorialViewType type) {
    switch (type) {
      case HistorialViewType.advertising:
        return MockData.advertisingDevices;
      case HistorialViewType.descargados:
        return MockData.descargadosDevices;
      case HistorialViewType.ambos:
        return [...MockData.advertisingDevices, ...MockData.descargadosDevices];
    }
  }

  Widget _buildTab(
    BuildContext context,
    String label,
    IconData icon,
    bool isActive,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isActive ? Colors.white : theme.textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceTypeFilter(
    BuildContext context,
    WidgetRef ref,
    DeviceFilterType currentFilter,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tipo de dispositivo',
            style: TextStyle(
              fontSize: 11,
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFilterPill(
                  context,
                  'Ambos',
                  null,
                  currentFilter == DeviceFilterType.ambos,
                  () => ref.read(deviceFilterProvider.notifier).state =
                      DeviceFilterType.ambos,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterPill(
                  context,
                  'Emisores',
                  Icons.radio,
                  currentFilter == DeviceFilterType.emisor,
                  () => ref.read(deviceFilterProvider.notifier).state =
                      DeviceFilterType.emisor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterPill(
                  context,
                  'Repetidores',
                  Icons.repeat,
                  currentFilter == DeviceFilterType.repetidor,
                  () => ref.read(deviceFilterProvider.notifier).state =
                      DeviceFilterType.repetidor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(
    BuildContext context,
    String label,
    IconData? icon,
    bool isActive,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = isDark ? const Color(0xFF0891B2) : const Color(0xFF06B6D4);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? accentColor : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: accentColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: isActive ? Colors.white : theme.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedFilters(BuildContext context, WidgetRef ref, ThemeData theme) {
    final macFilter = ref.watch(macFilterProvider);
    final macFilterEnabled = ref.watch(macFilterEnabledProvider);
    final rssiFilter = ref.watch(rssiFilterProvider);
    final rssiFilterEnabled = ref.watch(rssiFilterEnabledProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _filterExpanded = !_filterExpanded;
                });
              },
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_alt,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Filtros avanzados',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    if (macFilterEnabled || rssiFilterEnabled) ...[
                      const SizedBox(width: 8),
                      CustomBadge(
                        label: [
                          if (macFilterEnabled) 'MAC',
                          if (rssiFilterEnabled) 'RSSI',
                        ].join(', '),
                      ),
                    ],
                    const Spacer(),
                    Icon(
                      _filterExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 16,
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_filterExpanded) ...[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outline),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MAC Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filtrar por MAC',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                        ),
                      ),
                      Switch(
                        value: macFilterEnabled,
                        onChanged: (value) {
                          ref.read(macFilterEnabledProvider.notifier).state = value;
                          if (!value) {
                            ref.read(macFilterProvider.notifier).state = '';
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    enabled: macFilterEnabled,
                    onChanged: (value) {
                      ref.read(macFilterProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Ej: AA:BB:CC',
                      hintStyle: TextStyle(fontFamily: 'monospace'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 16),
                  // RSSI Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filtrar por RSSI',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                        ),
                      ),
                      Switch(
                        value: rssiFilterEnabled,
                        onChanged: (value) {
                          ref.read(rssiFilterEnabledProvider.notifier).state = value;
                          if (!value) {
                            ref.read(rssiFilterProvider.notifier).state = -100;
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RSSI mínimo: $rssiFilter dBm',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                  Slider(
                    value: rssiFilter.toDouble(),
                    min: -100,
                    max: -30,
                    divisions: 14,
                    onChanged: rssiFilterEnabled
                        ? (value) {
                            ref.read(rssiFilterProvider.notifier).state = value.round();
                          }
                        : null,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref.read(macFilterProvider.notifier).state = '';
                        ref.read(macFilterEnabledProvider.notifier).state = false;
                        ref.read(rssiFilterProvider.notifier).state = -100;
                        ref.read(rssiFilterEnabledProvider.notifier).state = false;
                      },
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Limpiar todos los filtros', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
