import 'package:flutter/material.dart';
import '../models/device.dart';
import 'device_config_dialog.dart';

class DeviceSelectionDialog extends StatefulWidget {
  final Device repetidor;
  final void Function(Device)? onSave;
  final VoidCallback? onDownload;
  final VoidCallback? onRestart;
  final VoidCallback? onDelete;

  const DeviceSelectionDialog({
    super.key,
    required this.repetidor,
    this.onSave,
    this.onDownload,
    this.onRestart,
    this.onDelete,
  });

  @override
  State<DeviceSelectionDialog> createState() => _DeviceSelectionDialogState();
}

class _DeviceSelectionDialogState extends State<DeviceSelectionDialog> {
  Device? _selectedDevice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Si ya se seleccionó un dispositivo, mostrar el diálogo de configuración
    if (_selectedDevice != null) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: DeviceConfigDialog(
          device: _selectedDevice!,
          onSave: widget.onSave,
          onDownload: widget.onDownload,
          onRestart: widget.onRestart,
          onDelete: widget.onDelete,
          asContent: true, // Usar como contenido sin Dialog wrapper
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Seleccionar dispositivo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Este repetidor está enlazado a un emisor. ¿Qué dispositivo deseas configurar?',
              style: TextStyle(
                fontSize: 13,
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            // Opción: Repetidor
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedDevice = widget.repetidor;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          Icons.repeat,
                          color: theme.colorScheme.secondary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Repetidor',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.repetidor.macAddress,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.signal_cellular_alt,
                                  size: 12,
                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.repetidor.rssi} dBm',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    '${widget.repetidor.historiales} hist.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Opción: Emisor enlazado
            if (widget.repetidor.linkedEmitter != null)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Crear un Device del emisor enlazado
                    final emisorDevice = Device(
                      macAddress: widget.repetidor.linkedEmitter!.macAddress,
                      deviceType: DeviceType.emisor,
                      rssi: widget.repetidor.linkedEmitter!.rssi,
                      historiales: widget.repetidor.linkedEmitter!.historiales,
                      connected: false,
                      adc1: widget.repetidor.linkedEmitter!.adc1,
                      adc2: widget.repetidor.linkedEmitter!.adc2,
                      desgaste: widget.repetidor.linkedEmitter!.desgaste,
                    );
                    setState(() {
                      _selectedDevice = emisorDevice;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            Icons.radio,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Emisor enlazado',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.repetidor.linkedEmitter!.macAddress,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.signal_cellular_alt,
                                    size: 12,
                                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.repetidor.linkedEmitter!.rssi} dBm',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      '${widget.repetidor.linkedEmitter!.historiales} hist.',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
