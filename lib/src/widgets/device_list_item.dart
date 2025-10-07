import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceListItem extends StatelessWidget {
  final Device device;
  final VoidCallback onTap;

  const DeviceListItem({
    super.key,
    required this.device,
    required this.onTap,
  });

  Color _getSignalColor(int rssi) {
    if (rssi > -50) return const Color(0xFF22C55E); // green-500
    if (rssi > -70) return const Color(0xFFEAB308); // yellow-500
    if (rssi > -85) return const Color(0xFFFB923C); // orange-400
    return const Color(0xFFEF4444); // red-500
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device Header
              Row(
                children: [
                  Icon(
                    Icons.radio,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      device.macAddress,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: device.deviceType == DeviceType.emisor
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      device.deviceType.displayName,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: device.deviceType == DeviceType.emisor
                            ? theme.colorScheme.primary
                            : theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: device.connected
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Device Stats
              Row(
                children: [
                  Icon(
                    Icons.signal_cellular_alt,
                    size: 14,
                    color: _getSignalColor(device.rssi),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'RSSI:',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${device.rssi} dBm',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Historiales:',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    device.historiales.toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // ADC and Desgaste for Emisor
              if (device.deviceType == DeviceType.emisor &&
                  (device.adc1 != null || device.adc2 != null || device.desgaste != null)) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      if (device.adc1 != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.speed,
                              size: 12,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'ADC1:',
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              device.adc1.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      if (device.adc2 != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.speed,
                              size: 12,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'ADC2:',
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              device.adc2.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      if (device.desgaste != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.show_chart,
                              size: 12,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Desgaste:',
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${device.desgaste} mm',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
              // Linked Emitter Info
              if (device.connected && device.linkedEmitter != null) ...[
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.link,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Emisor enlazado:',
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        device.linkedEmitter!.macAddress,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'RSSI:',
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${device.linkedEmitter!.rssi} dBm',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Historiales:',
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            device.linkedEmitter!.historiales.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      // Linked Emitter ADC and Desgaste
                      if (device.linkedEmitter!.adc1 != null ||
                          device.linkedEmitter!.adc2 != null ||
                          device.linkedEmitter!.desgaste != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            children: [
                              if (device.linkedEmitter!.adc1 != null)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.speed,
                                      size: 12,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'ADC1:',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      device.linkedEmitter!.adc1.toString(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              if (device.linkedEmitter!.adc2 != null)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.speed,
                                      size: 12,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'ADC2:',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      device.linkedEmitter!.adc2.toString(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              if (device.linkedEmitter!.desgaste != null)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.show_chart,
                                      size: 12,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Desgaste:',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${device.linkedEmitter!.desgaste} mm',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
