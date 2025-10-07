import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/historial_data.dart';

class DeviceHistorialDialog extends StatefulWidget {
  final DeviceHistorialData historialData;

  const DeviceHistorialDialog({
    super.key,
    required this.historialData,
  });

  @override
  State<DeviceHistorialDialog> createState() => _DeviceHistorialDialogState();
}

class _DeviceHistorialDialogState extends State<DeviceHistorialDialog> {
  DateTimeRange? _selectedDateRange;
  String _selectedTab = 'graficos'; // graficos, tabla
  
  List<HistorialEntry> get _filteredEntries {
    if (_selectedDateRange == null) {
      return widget.historialData.entries;
    }
    return widget.historialData.entries.where((entry) {
      return entry.timestamp.isAfter(_selectedDateRange!.start) &&
          entry.timestamp.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEmisor = widget.historialData.deviceType == 'Emisor';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 750),
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
                          widget.historialData.deviceName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.historialData.macAddress,
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
                  ),
                ],
              ),
            ),
            // Tabs y filtro de fecha
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                border: Border(
                  bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
                ),
              ),
              child: Row(
                children: [
                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Row(
                      children: [
                        _buildTabButton(
                          theme,
                          'graficos',
                          'Gráficos',
                          Icons.show_chart,
                        ),
                        _buildTabButton(
                          theme,
                          'tabla',
                          'Tabla',
                          Icons.table_chart,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Filtro de fecha
                  OutlinedButton.icon(
                    onPressed: () async {
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: widget.historialData.entries.first.timestamp,
                        lastDate: DateTime.now(),
                        initialDateRange: _selectedDateRange,
                      );
                      if (range != null) {
                        setState(() {
                          _selectedDateRange = range;
                        });
                      }
                    },
                    icon: const Icon(Icons.date_range, size: 16),
                    label: Text(
                      _selectedDateRange == null
                          ? 'Filtrar por fecha'
                          : '${DateFormat('dd/MM').format(_selectedDateRange!.start)} - ${DateFormat('dd/MM').format(_selectedDateRange!.end)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  if (_selectedDateRange != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      tooltip: 'Limpiar filtro',
                      onPressed: () {
                        setState(() {
                          _selectedDateRange = null;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ],
              ),
            ),
            // Content
            Expanded(
              child: _selectedTab == 'graficos'
                  ? _buildGraficosView(theme, isEmisor)
                  : _buildTablaView(theme, isEmisor),
            ),
            // Footer con estadísticas
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outline),
                ),
              ),
              child: Row(
                children: [
                  _buildFooterStat(theme, Icons.storage, 'Total', '${widget.historialData.totalPackets}', Colors.cyan),
                  const SizedBox(width: 16),
                  _buildFooterStat(theme, Icons.filter_list, 'Filtrados', '${_filteredEntries.length}', Colors.orange),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Exportar datos
                    },
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Exportar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(ThemeData theme, String value, String label, IconData icon) {
    final isSelected = _selectedTab == value;
    return Material(
      color: isSelected ? theme.colorScheme.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: () => setState(() => _selectedTab = value),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? theme.colorScheme.onPrimary : theme.textTheme.bodyMedium?.color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? theme.colorScheme.onPrimary : theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterStat(ThemeData theme, IconData icon, String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildGraficosView(ThemeData theme, bool isEmisor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gráfico de RSSI (Historial de señal)
          _buildChartSection(
            theme,
            'Historial de señal (RSSI)',
            Icons.signal_cellular_alt,
            Colors.cyan,
            'rssi',
            'dBm',
          ),
          const SizedBox(height: 20),
          // Gráfico de Paquetes recibidos
          _buildChartSection(
            theme,
            'Paquetes recibidos',
            Icons.analytics,
            Colors.green,
            'packets',
            'paquetes',
          ),
          if (isEmisor) ...[
            const SizedBox(height: 20),
            // Gráfico de ADC1
            _buildChartSection(
              theme,
              'ADC1',
              Icons.analytics_outlined,
              Colors.purple,
              'adc1',
              '',
            ),
            const SizedBox(height: 20),
            // Gráfico de ADC2
            _buildChartSection(
              theme,
              'ADC2',
              Icons.analytics_outlined,
              Colors.blue,
              'adc2',
              '',
            ),
            const SizedBox(height: 20),
            // Gráfico de Desgaste
            _buildChartSection(
              theme,
              'Desgaste',
              Icons.warning_amber,
              Colors.orange,
              'desgaste',
              '',
            ),
          ],
          const SizedBox(height: 20),
          // Gráfico de Batería
          _buildChartSection(
            theme,
            'Batería',
            Icons.battery_full,
            Colors.teal,
            'bateria',
            '%',
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(
    ThemeData theme,
    String title,
    IconData icon,
    Color color,
    String metric,
    String unit,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const Spacer(),
                if (metric == 'rssi')
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 3,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Señal',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 12,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Umbral',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Chart
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 16, bottom: 16),
              child: _buildChart(theme, metric, color, unit),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(ThemeData theme, String metric, Color color, String unit) {
    final entries = _filteredEntries;
    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No hay datos disponibles',
          style: TextStyle(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
          ),
        ),
      );
    }

    // Obtener datos según la métrica
    final spots = <FlSpot>[];
    for (int i = 0; i < entries.length; i++) {
      double? yValue;
      switch (metric) {
        case 'rssi':
          yValue = entries[i].rssi.toDouble();
          break;
        case 'packets':
          // Simular paquetes acumulados
          yValue = (i * 2.5);
          break;
        case 'adc1':
          yValue = entries[i].adc1?.toDouble();
          break;
        case 'adc2':
          yValue = entries[i].adc2?.toDouble();
          break;
        case 'desgaste':
          yValue = entries[i].desgaste;
          break;
        case 'bateria':
          yValue = entries[i].bateria;
          break;
      }
      if (yValue != null) {
        spots.add(FlSpot(i.toDouble(), yValue));
      }
    }

    if (spots.isEmpty) {
      return Center(
        child: Text(
          'No hay datos para esta métrica',
          style: TextStyle(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
          ),
        ),
      );
    }

    // Calcular min/max para el eje Y
    final yValues = spots.map((s) => s.y).toList();
    final minY = yValues.reduce((a, b) => a < b ? a : b);
    final maxY = yValues.reduce((a, b) => a > b ? a : b);
    final yRange = maxY - minY;
    final yMargin = yRange * 0.1;

    // Líneas extra para RSSI
    final extraLines = <HorizontalLine>[];
    if (metric == 'rssi') {
      extraLines.add(
        HorizontalLine(
          y: -70,
          color: Colors.red.withOpacity(0.5),
          strokeWidth: 2,
          dashArray: [5, 5],
          label: HorizontalLineLabel(
            show: true,
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(right: 5, bottom: 5),
            style: TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return LineChart(
      LineChartData(
        extraLinesData: ExtraLinesData(horizontalLines: extraLines),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: theme.colorScheme.outline.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: spots.length > 8 ? spots.length / 6 : spots.length / 4,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= entries.length) return const Text('');
                final time = DateFormat('HH:mm').format(entries[index].timestamp);
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 9,
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (maxY - minY) / 4,
              reservedSize: 42,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toStringAsFixed(0)}$unit',
                  style: TextStyle(
                    fontSize: 9,
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (entries.length - 1).toDouble(),
        minY: minY - yMargin,
        maxY: maxY + yMargin,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTablaView(ThemeData theme, bool isEmisor) {
    final entries = _filteredEntries;
    
    return Column(
      children: [
        // Header de la tabla
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            border: Border(
              bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
            ),
          ),
          child: Row(
            children: [
              _buildTableHeader(theme, 'Fecha/Hora', flex: 2),
              _buildTableHeader(theme, 'RSSI', flex: 1),
              if (isEmisor) ...[
                _buildTableHeader(theme, 'ADC1', flex: 1),
                _buildTableHeader(theme, 'ADC2', flex: 1),
                _buildTableHeader(theme, 'Desgaste', flex: 1),
              ],
              _buildTableHeader(theme, 'Batería', flex: 1),
            ],
          ),
        ),
        // Contenido de la tabla
        Expanded(
          child: entries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 48,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay registros en el rango seleccionado',
                        style: TextStyle(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final isEven = index % 2 == 0;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isEven
                            ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.2)
                            : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.1),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildTableCell(
                            theme,
                            DateFormat('dd/MM/yyyy HH:mm:ss').format(entry.timestamp),
                            flex: 2,
                            isMonospace: true,
                          ),
                          _buildTableCell(
                            theme,
                            '${entry.rssi} dBm',
                            flex: 1,
                            color: _getRssiColor(entry.rssi),
                          ),
                          if (isEmisor) ...[
                            _buildTableCell(
                              theme,
                              entry.adc1?.toString() ?? '-',
                              flex: 1,
                            ),
                            _buildTableCell(
                              theme,
                              entry.adc2?.toString() ?? '-',
                              flex: 1,
                            ),
                            _buildTableCell(
                              theme,
                              entry.desgaste?.toStringAsFixed(1) ?? '-',
                              flex: 1,
                            ),
                          ],
                          _buildTableCell(
                            theme,
                            entry.bateria != null ? '${entry.bateria!.toStringAsFixed(0)}%' : '-',
                            flex: 1,
                            color: _getBateriaColor(entry.bateria),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(ThemeData theme, String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildTableCell(
    ThemeData theme,
    String text, {
    required int flex,
    Color? color,
    bool isMonospace = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontFamily: isMonospace ? 'monospace' : null,
          color: color ?? theme.textTheme.bodyMedium?.color,
        ),
      ),
    );
  }

  Color _getRssiColor(int rssi) {
    if (rssi >= -50) return Colors.green;
    if (rssi >= -70) return Colors.orange;
    return Colors.red;
  }

  Color? _getBateriaColor(double? bateria) {
    if (bateria == null) return null;
    if (bateria >= 70) return Colors.green;
    if (bateria >= 30) return Colors.orange;
    return Colors.red;
  }
}
