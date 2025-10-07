import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceConfigDialog extends StatefulWidget {
  final Device device;
  final void Function(Device)? onSave;
  final VoidCallback? onDownload;
  final VoidCallback? onRestart;
  final VoidCallback? onDelete;
  final bool asContent; // Si es true, no usa Dialog wrapper

  const DeviceConfigDialog({
    super.key,
    required this.device,
    this.onSave,
    this.onDownload,
    this.onRestart,
    this.onDelete,
    this.asContent = false,
  });

  @override
  State<DeviceConfigDialog> createState() => _DeviceConfigDialogState();
}

class _DeviceConfigDialogState extends State<DeviceConfigDialog> {
  late TextEditingController _nameController;
  late TextEditingController _intervalController;
  bool _enableNotifications = true;
  bool _autoDownload = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Dispositivo ${widget.device.macAddress.substring(15)}');
    _intervalController = TextEditingController(text: '60');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEmisor = widget.device.deviceType == DeviceType.emisor;
    final content = _buildContent(context, theme, isEmisor);

    // Si asContent es true, retornar solo el contenido
    if (widget.asContent) {
      return content;
    }

    // Si no, envolver en Dialog
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: content,
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, bool isEmisor) {
    return Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(color: theme.colorScheme.outline),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isEmisor
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : theme.colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      isEmisor ? Icons.radio : Icons.repeat,
                      color: isEmisor ? theme.colorScheme.primary : theme.colorScheme.secondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Configurar ${widget.device.deviceType.displayName}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.device.macAddress,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    iconSize: 20,
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Estado del dispositivo
                    _buildSection(
                      context,
                      'Estado del dispositivo',
                      Icons.info_outline,
                      Column(
                        children: [
                          _buildInfoRow(
                            context,
                            'RSSI',
                            '${widget.device.rssi} dBm',
                            Icons.signal_cellular_alt,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            context,
                            'Historiales',
                            widget.device.historiales.toString(),
                            Icons.article_outlined,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            context,
                            'Estado',
                            widget.device.connected ? 'Conectado' : 'Desconectado',
                            Icons.circle,
                            valueColor: widget.device.connected
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFEF4444),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Datos del emisor (solo para emisores)
                    if (isEmisor && (widget.device.adc1 != null || widget.device.adc2 != null || widget.device.desgaste != null))
                      _buildSection(
                        context,
                        'Mediciones del emisor',
                        Icons.sensors,
                        Column(
                          children: [
                            if (widget.device.adc1 != null)
                              _buildInfoRow(
                                context,
                                'ADC1',
                                widget.device.adc1.toString(),
                                Icons.speed,
                              ),
                            if (widget.device.adc2 != null) ...[
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                context,
                                'ADC2',
                                widget.device.adc2.toString(),
                                Icons.speed,
                              ),
                            ],
                            if (widget.device.desgaste != null) ...[
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                context,
                                'Desgaste',
                                '${widget.device.desgaste} mm',
                                Icons.show_chart,
                              ),
                            ],
                          ],
                        ),
                      ),
                    if (isEmisor && (widget.device.adc1 != null || widget.device.adc2 != null || widget.device.desgaste != null))
                      const SizedBox(height: 20),
                    // Configuración general
                    _buildSection(
                      context,
                      'Configuración general',
                      Icons.settings,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nombre del dispositivo',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Intervalo de actualización (segundos)',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _intervalController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              suffixText: 's',
                            ),
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: const Text(
                              'Habilitar notificaciones',
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              'Recibe alertas sobre este dispositivo',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                              ),
                            ),
                            value: _enableNotifications,
                            onChanged: (value) {
                              setState(() {
                                _enableNotifications = value;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                          SwitchListTile(
                            title: const Text(
                              'Descarga automática',
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              'Descargar historiales automáticamente',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                              ),
                            ),
                            value: _autoDownload,
                            onChanged: (value) {
                              setState(() {
                                _autoDownload = value;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Acciones rápidas
                    _buildSection(
                      context,
                      'Acciones rápidas',
                      Icons.flash_on,
                      Column(
                        children: [
                          _buildActionButton(
                            context,
                            'Descargar historiales',
                            Icons.download,
                            () {
                              widget.onDownload?.call();
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildActionButton(
                            context,
                            'Reiniciar dispositivo',
                            Icons.refresh,
                            () {
                              _showConfirmDialog(
                                context,
                                '¿Reiniciar dispositivo?',
                                'Esta acción reiniciará el dispositivo.',
                                widget.onRestart,
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildActionButton(
                            context,
                            'Borrar historiales',
                            Icons.delete_outline,
                            () {
                              _showConfirmDialog(
                                context,
                                '¿Borrar historiales?',
                                'Esta acción eliminará todos los historiales del dispositivo.',
                                widget.onDelete,
                              );
                            },
                            isDestructive: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Footer con botones
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outline),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () {
                      // Crear un dispositivo actualizado con los nuevos valores
                      final updatedDevice = widget.device.copyWith(
                        // Aquí podrías actualizar propiedades basadas en los controllers
                      );
                      widget.onSave?.call(updatedDevice);
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon, Widget content) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: valueColor ?? theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDestructive
                  ? theme.colorScheme.error.withOpacity(0.5)
                  : theme.colorScheme.outline,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isDestructive ? theme.colorScheme.error : theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDestructive ? theme.colorScheme.error : null,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback? onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
