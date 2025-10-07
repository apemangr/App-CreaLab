import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app/providers.dart';

class ConfiguracionPage extends ConsumerStatefulWidget {
  const ConfiguracionPage({super.key});

  @override
  ConsumerState<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends ConsumerState<ConfiguracionPage> {
  bool _scanSettingsExpanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final scanTime = ref.watch(scanTimeProvider);
    final historialType = ref.watch(historialDownloadTypeProvider);

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
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Configuración',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
                // Ajustes de escaneo
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outline),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
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
                              _scanSettingsExpanded = !_scanSettingsExpanded;
                            });
                          },
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.settings,
                                  size: 20,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Ajustes de escaneo',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                Icon(
                                  _scanSettingsExpanded ? Icons.expand_less : Icons.expand_more,
                                  size: 16,
                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (_scanSettingsExpanded) ...[
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
                              // Tiempo de escaneo
                              Text(
                                'Tiempo de escaneo: $scanTime segundos',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                ),
                              ),
                              Slider(
                                value: scanTime.toDouble(),
                                min: 5,
                                max: 300,
                                divisions: 59,
                                onChanged: (value) {
                                  ref.read(scanTimeProvider.notifier).state = value.round();
                                },
                              ),
                              Text(
                                'Define la duración de cada ciclo de escaneo BLE',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Divider(color: theme.colorScheme.outline),
                              const SizedBox(height: 16),
                              // Bajar historiales al escanear
                              Row(
                                children: [
                                  Icon(
                                    Icons.download,
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Bajar historiales al escanear',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildRadioOption(
                                context,
                                'Solo Repetidor',
                                historialType == HistorialDownloadType.repetidor,
                                () => ref.read(historialDownloadTypeProvider.notifier).state =
                                    HistorialDownloadType.repetidor,
                              ),
                              const SizedBox(height: 8),
                              _buildRadioOption(
                                context,
                                'Solo Emisor',
                                historialType == HistorialDownloadType.emisor,
                                () => ref.read(historialDownloadTypeProvider.notifier).state =
                                    HistorialDownloadType.emisor,
                              ),
                              const SizedBox(height: 8),
                              _buildRadioOption(
                                context,
                                'Emisor + Repetidor',
                                historialType == HistorialDownloadType.ambos,
                                () => ref.read(historialDownloadTypeProvider.notifier).state =
                                    HistorialDownloadType.ambos,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Selecciona qué tipo de dispositivos descargarán historiales durante el escaneo',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
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
                // Apariencia
                Container(
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
                      Row(
                        children: [
                          Icon(
                            isDarkMode ? Icons.dark_mode : Icons.light_mode,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Apariencia',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: theme.colorScheme.outline),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Modo oscuro',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Cambia entre tema claro y oscuro',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isDarkMode,
                            onChanged: (value) {
                              ref.read(isDarkModeProvider.notifier).state = value;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Información de la aplicación
                Container(
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
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Información de la aplicación',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: theme.colorScheme.outline),
                      const SizedBox(height: 12),
                      _buildInfoRow(context, 'Versión', '1.0.0'),
                      const SizedBox(height: 12),
                      _buildInfoRow(context, 'Tipo', 'Monitor BLE'),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        context,
                        'Estado',
                        'Activo',
                        valueColor: const Color(0xFF22C55E),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Acerca de
                Container(
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
                    children: [
                      Text(
                        'Monitor de paquetes de advertising BLE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Diseñado para emisores y repetidores',
                        textAlign: TextAlign.center,
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
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.textTheme.bodySmall?.color?.withOpacity(0.4) ?? Colors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: valueColor ?? theme.textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}
