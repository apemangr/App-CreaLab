import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app/providers.dart';
import '../models/device.dart';
import '../models/mock_data.dart';
import '../widgets/device_list_item.dart';
import '../dialogs/device_selection_dialog.dart';
import '../dialogs/device_config_dialog.dart';

class EscanearPage extends ConsumerStatefulWidget {
  const EscanearPage({super.key});

  @override
  ConsumerState<EscanearPage> createState() => _EscanearPageState();
}

class _EscanearPageState extends ConsumerState<EscanearPage> {
  bool _filtersExpanded = false;
  final TextEditingController _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _handleDeviceTap(BuildContext context, Device device) {
    // Si es un repetidor con emisor enlazado, mostrar el diálogo de selección
    if (device.deviceType == DeviceType.repetidor && device.linkedEmitter != null) {
      showDialog(
        context: context,
        builder: (dialogContext) => DeviceSelectionDialog(
          repetidor: device,
          onSave: (updatedDevice) {
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Configuración guardada para ${updatedDevice.macAddress}'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          onDownload: () {
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Descargando historiales...'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          onRestart: () {
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reiniciando dispositivo...'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          onDelete: () {
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Dispositivo eliminado'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      );
    } else {
      // Abrir directamente el diálogo de configuración
      _showConfigDialog(context, device);
    }
  }

  void _showConfigDialog(BuildContext context, Device device) {
    showDialog(
      context: context,
      builder: (context) => DeviceConfigDialog(
        device: device,
        onSave: (updatedDevice) {
          Navigator.of(context).pop();
          // TODO: Aquí se actualizaría el dispositivo en el estado real
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Configuración guardada para ${updatedDevice.macAddress}'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        onDownload: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Descargando historiales...'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        onRestart: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reiniciando dispositivo...'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        onDelete: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dispositivo eliminado'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isScanning = ref.watch(isScanningProvider);
    final filtersEnabled = ref.watch(filtersEnabledProvider);
    final rssiThreshold = ref.watch(rssiThresholdProvider);
    final identifiers = ref.watch(identifiersProvider);

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Escaneo BLE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.filter_alt,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Filtros',
                          style: TextStyle(fontSize: 11),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: filtersEnabled,
                          onChanged: (value) {
                            ref.read(filtersEnabledProvider.notifier).state = value;
                          },
                        ),
                        const SizedBox(width: 8),
                        FloatingActionButton(
                          mini: true,
                          onPressed: () {
                            ref.read(isScanningProvider.notifier).state = !isScanning;
                          },
                          backgroundColor: isScanning
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                          child: Icon(
                            isScanning ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
                // Filtros Accordion
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outline),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
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
                              _filtersExpanded = !_filtersExpanded;
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
                                  color: filtersEnabled
                                      ? theme.colorScheme.primary
                                      : theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Configurar filtros',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: filtersEnabled
                                          ? null
                                          : theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Icon(
                                  _filtersExpanded ? Icons.expand_less : Icons.expand_more,
                                  size: 16,
                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (_filtersExpanded) ...[
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
                              // MAC Search
                              Text(
                                'Buscar por dirección MAC',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                enabled: filtersEnabled,
                                onChanged: (value) {
                                  ref.read(macSearchProvider.notifier).state = value;
                                },
                                decoration: InputDecoration(
                                  hintText: 'AA:BB:CC:DD:EE:FF',
                                  hintStyle: const TextStyle(fontFamily: 'monospace'),
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
                              // Identificadores
                              Text(
                                'Identificadores (4 caracteres hex)',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      enabled: filtersEnabled,
                                      controller: _identifierController,
                                      maxLength: 4,
                                      decoration: InputDecoration(
                                        hintText: '0A3F',
                                        hintStyle: const TextStyle(fontFamily: 'monospace'),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                        counterText: '',
                                      ),
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                      ),
                                      onChanged: (value) {
                                        final filtered = value.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
                                        if (filtered != value) {
                                          _identifierController.text = filtered.toUpperCase();
                                          _identifierController.selection = TextSelection.fromPosition(
                                            TextPosition(offset: filtered.length),
                                          );
                                        }
                                      },
                                      onSubmitted: (value) => _addIdentifier(ref, value),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  FloatingActionButton(
                                    mini: true,
                                    onPressed: filtersEnabled
                                        ? () => _addIdentifier(ref, _identifierController.text)
                                        : null,
                                    child: const Icon(Icons.add, size: 20),
                                  ),
                                ],
                              ),
                              if (identifiers.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: identifiers.map((id) {
                                    return Chip(
                                      label: Text(
                                        id,
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 12,
                                        ),
                                      ),
                                      deleteIcon: const Icon(Icons.close, size: 16),
                                      onDeleted: filtersEnabled
                                          ? () {
                                              final current = ref.read(identifiersProvider);
                                              ref.read(identifiersProvider.notifier).state =
                                                  current.where((i) => i != id).toList();
                                            }
                                          : null,
                                    );
                                  }).toList(),
                                ),
                              ],
                              const SizedBox(height: 16),
                              // RSSI Threshold
                              Text(
                                'Umbral RSSI mínimo: $rssiThreshold dBm',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                ),
                              ),
                              Slider(
                                value: rssiThreshold.toDouble(),
                                min: -100,
                                max: -30,
                                divisions: 14,
                                onChanged: filtersEnabled
                                    ? (value) {
                                        ref.read(rssiThresholdProvider.notifier).state =
                                            value.round();
                                      }
                                    : null,
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: filtersEnabled ? () {} : null,
                                  child: const Text('Aplicar filtros', style: TextStyle(fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Dispositivos detectados
                Row(
                  children: [
                    Text(
                      'Dispositivos detectados (${MockData.scanDevices.length})',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Lista de dispositivos
                ...MockData.scanDevices.map((device) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DeviceListItem(
                        device: device,
                        onTap: () => _handleDeviceTap(context, device),
                      ),
                    )),
              ],
            ),
          ),
          // Bottom Status Bar
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(color: theme.colorScheme.outline, width: 1),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isScanning)
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 1500),
                    tween: Tween<double>(begin: 1.0, end: 1.2),
                    builder: (context, double scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Icon(
                          Icons.bluetooth_searching,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                      );
                    },
                    onEnd: () {
                      if (mounted) setState(() {});
                    },
                  )
                else
                  Icon(
                    Icons.bluetooth,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                const SizedBox(width: 8),
                Text(
                  isScanning ? 'Escaneando...' : 'Detenido',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addIdentifier(WidgetRef ref, String value) {
    if (value.length == 4 && !ref.read(identifiersProvider).contains(value.toUpperCase())) {
      final current = ref.read(identifiersProvider);
      ref.read(identifiersProvider.notifier).state = [...current, value.toUpperCase()];
      _identifierController.clear();
    }
  }
}
