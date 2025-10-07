import { useState } from "react";
import { RefreshCw, Filter, Download, RotateCcw, Radio, Repeat, Signal, Clock, ChevronDown, ChevronUp, Wifi, Database, Layers } from "lucide-react";
import { BentoMetricCard } from "./BentoMetricCard";
import { DeviceHistorialCard } from "./DeviceHistorialCard";
import { DeviceDetailDialog } from "./DeviceDetailDialog";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Slider } from "./ui/slider";
import { Switch } from "./ui/switch";
import { Label } from "./ui/label";
import { Badge } from "./ui/badge";
import { ToggleGroup, ToggleGroupItem } from "./ui/toggle-group";
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "./ui/collapsible";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./ui/tabs";
import { motion, AnimatePresence } from "motion/react";

// Historial de Advertising (escaneo BLE en tiempo real)
const mockAdvertisingDevices = [
  { mac: "AA:BB:CC:DD:EE:01", name: "Emisor-01", type: "Emisor" as const, rssi: -45, packets: 234, lastSeen: "10:23:15" },
  { mac: "AA:BB:CC:DD:EE:02", name: "Repetidor-01", type: "Repetidor" as const, rssi: -62, packets: 189, lastSeen: "10:23:12" },
  { mac: "AA:BB:CC:DD:EE:03", name: "Emisor-02", type: "Emisor" as const, rssi: -51, packets: 156, lastSeen: "10:23:10" },
  { mac: "AA:BB:CC:DD:EE:04", name: "Repetidor-02", type: "Repetidor" as const, rssi: -78, packets: 98, lastSeen: "10:23:08" },
  { mac: "AA:BB:CC:DD:EE:05", name: "Emisor-03", type: "Emisor" as const, rssi: -54, packets: 178, lastSeen: "10:23:05" },
  { mac: "AA:BB:CC:DD:EE:06", name: "Repetidor-03", type: "Repetidor" as const, rssi: -68, packets: 142, lastSeen: "10:23:02" },
];

// Historial de Descargados (datos descargados de dispositivos)
const mockDescargadosDevices = [
  { mac: "BB:CC:DD:EE:FF:01", name: "Emisor-DL-01", type: "Emisor" as const, rssi: -52, packets: 1420, lastSeen: "09:45:30" },
  { mac: "BB:CC:DD:EE:FF:02", name: "Repetidor-DL-01", type: "Repetidor" as const, rssi: -65, packets: 890, lastSeen: "09:45:25" },
  { mac: "BB:CC:DD:EE:FF:03", name: "Emisor-DL-02", type: "Emisor" as const, rssi: -48, packets: 2103, lastSeen: "09:45:20" },
  { mac: "BB:CC:DD:EE:FF:04", name: "Repetidor-DL-02", type: "Repetidor" as const, rssi: -72, packets: 654, lastSeen: "09:45:15" },
];

interface PrincipalProps {
  deviceFilter: "ambos" | "emisor" | "repetidor";
  onDeviceFilterChange: (value: "ambos" | "emisor" | "repetidor") => void;
}

export function Principal({ deviceFilter, onDeviceFilterChange }: PrincipalProps) {
  const [rssiFilter, setRssiFilter] = useState([-100]);
  const [macFilter, setMacFilter] = useState("");
  const [selectedDevice, setSelectedDevice] = useState<typeof mockAdvertisingDevices[0] | null>(null);
  const [filterExpanded, setFilterExpanded] = useState(false);
  const [macFilterEnabled, setMacFilterEnabled] = useState(false);
  const [rssiFilterEnabled, setRssiFilterEnabled] = useState(false);
  const [historialType, setHistorialType] = useState<"advertising" | "descargados" | "ambos">("advertising");

  // Seleccionar el conjunto de datos según el tipo de historial
  const currentDevices = historialType === "advertising" 
    ? mockAdvertisingDevices 
    : historialType === "descargados"
    ? mockDescargadosDevices
    : [...mockAdvertisingDevices, ...mockDescargadosDevices];

  const emisorCount = currentDevices.filter(d => d.type === "Emisor").length;
  const repetidorCount = currentDevices.filter(d => d.type === "Repetidor").length;
  const totalHistoriales = currentDevices.reduce((sum, d) => sum + d.packets, 0);
  const avgRssi = currentDevices.length > 0 
    ? Math.round(currentDevices.reduce((sum, d) => sum + d.rssi, 0) / currentDevices.length)
    : 0;

  const filteredDevices = currentDevices.filter(device => {
    const matchesMAC = !macFilterEnabled || macFilter === "" || device.mac.toLowerCase().includes(macFilter.toLowerCase());
    const matchesRSSI = !rssiFilterEnabled || device.rssi >= rssiFilter[0];
    const matchesType = deviceFilter === "ambos" || 
      (deviceFilter === "emisor" && device.type === "Emisor") ||
      (deviceFilter === "repetidor" && device.type === "Repetidor");
    return matchesMAC && matchesRSSI && matchesType;
  });

  return (
    <>
      <div className="flex-1 overflow-auto pb-20">
        {/* App Bar */}
        <div className="sticky top-0 z-10 bg-card border-b border-border shadow-sm">
          <div className="px-4 py-3">
            <h1 className="text-lg mb-3">Historial</h1>
            
            {/* Historial Type Tabs */}
            <Tabs value={historialType} onValueChange={(value) => setHistorialType(value as "advertising" | "descargados" | "ambos")}>
              <TabsList className="grid w-full grid-cols-3">
                <TabsTrigger value="advertising" className="text-xs flex items-center gap-1.5">
                  <Wifi className="w-3.5 h-3.5" />
                  Advertising
                </TabsTrigger>
                <TabsTrigger value="descargados" className="text-xs flex items-center gap-1.5">
                  <Database className="w-3.5 h-3.5" />
                  Descargados
                </TabsTrigger>
                <TabsTrigger value="ambos" className="text-xs flex items-center gap-1.5">
                  <Layers className="w-3.5 h-3.5" />
                  Ambos
                </TabsTrigger>
              </TabsList>
            </Tabs>
          </div>
        </div>

        <div className="p-4 space-y-4">
          {/* Bento Box Metrics */}
          <div className="grid grid-cols-2 gap-3">
            <BentoMetricCard
              icon={Radio}
              label="Emisores"
              value={emisorCount}
              color="cyan"
            />
            <BentoMetricCard
              icon={Repeat}
              label="Repetidores"
              value={repetidorCount}
              color="purple"
            />
            <BentoMetricCard
              icon={Signal}
              label="RSSI promedio"
              value={avgRssi}
              unit="dBm"
              color="green"
            />
            <BentoMetricCard
              icon={Clock}
              label="Total historiales"
              value={totalHistoriales}
              color="orange"
            />
          </div>

          {/* Device Type Filter */}
          <div className="bg-card rounded-xl p-4 shadow-sm border border-border">
            <Label className="text-xs mb-3 block">Tipo de dispositivo</Label>
            <ToggleGroup 
              type="single" 
              value={deviceFilter} 
              onValueChange={(value) => {
                if (value) onDeviceFilterChange(value as "ambos" | "emisor" | "repetidor");
              }}
              className="grid grid-cols-3 gap-2"
            >
              <ToggleGroupItem 
                value="ambos" 
                className="text-xs data-[state=on]:bg-accent data-[state=on]:text-white data-[state=on]:shadow-lg data-[state=on]:scale-105 transition-all duration-200"
              >
                Ambos
              </ToggleGroupItem>
              <ToggleGroupItem 
                value="emisor" 
                className="text-xs flex items-center gap-1 data-[state=on]:bg-accent data-[state=on]:text-white data-[state=on]:shadow-lg data-[state=on]:scale-105 transition-all duration-200"
              >
                <Radio className="w-3.5 h-3.5" />
                Emisores
              </ToggleGroupItem>
              <ToggleGroupItem 
                value="repetidor" 
                className="text-xs flex items-center gap-1 data-[state=on]:bg-accent data-[state=on]:text-white data-[state=on]:shadow-lg data-[state=on]:scale-105 transition-all duration-200"
              >
                <Repeat className="w-3.5 h-3.5" />
                Repetidores
              </ToggleGroupItem>
            </ToggleGroup>
          </div>

          {/* Filter Bar - Collapsible */}
          <Collapsible open={filterExpanded} onOpenChange={setFilterExpanded}>
            <div className="bg-card rounded-xl shadow-sm border border-border overflow-hidden">
              <CollapsibleTrigger asChild>
                <button 
                  type="button"
                  className="w-full px-4 py-3 flex items-center justify-between hover:bg-muted/50 transition-colors"
                  onClick={(e) => {
                    e.preventDefault();
                    setFilterExpanded(!filterExpanded);
                  }}
                >
                  <div className="flex items-center gap-2 pointer-events-none">
                    <Filter className="w-4 h-4 text-accent" />
                    <h3 className="text-sm">Filtros avanzados</h3>
                    {(macFilterEnabled || rssiFilterEnabled) && (
                      <Badge variant="secondary" className="text-xs">
                        {[macFilterEnabled && "MAC", rssiFilterEnabled && "RSSI"].filter(Boolean).join(", ")}
                      </Badge>
                    )}
                  </div>
                  <div className="pointer-events-none">
                    {filterExpanded ? (
                      <ChevronUp className="w-4 h-4 text-muted-foreground" />
                    ) : (
                      <ChevronDown className="w-4 h-4 text-muted-foreground" />
                    )}
                  </div>
                </button>
              </CollapsibleTrigger>
              
              <CollapsibleContent>
                <div className="px-4 pb-4 pt-2 space-y-4 border-t border-border">
                  {/* MAC Filter */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <Label className="text-xs">Filtrar por MAC</Label>
                      <Switch 
                        checked={macFilterEnabled}
                        onCheckedChange={(checked) => {
                          setMacFilterEnabled(checked);
                          if (!checked) setMacFilter("");
                        }}
                      />
                    </div>
                    <Input 
                      placeholder="Ej: AA:BB:CC" 
                      value={macFilter}
                      onChange={(e) => setMacFilter(e.target.value)}
                      className="font-mono"
                      disabled={!macFilterEnabled}
                    />
                  </div>

                  {/* RSSI Filter */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <Label className="text-xs">Filtrar por RSSI</Label>
                      <Switch 
                        checked={rssiFilterEnabled}
                        onCheckedChange={(checked) => {
                          setRssiFilterEnabled(checked);
                          if (!checked) setRssiFilter([-100]);
                        }}
                      />
                    </div>
                    <Label className="text-xs text-muted-foreground">
                      RSSI mínimo: {rssiFilter[0]} dBm
                    </Label>
                    <Slider
                      value={rssiFilter}
                      onValueChange={setRssiFilter}
                      min={-100}
                      max={-30}
                      step={5}
                      disabled={!rssiFilterEnabled}
                    />
                  </div>

                  <Button 
                    variant="outline" 
                    size="sm"
                    className="w-full"
                    onClick={() => {
                      setMacFilter("");
                      setRssiFilter([-100]);
                      setMacFilterEnabled(false);
                      setRssiFilterEnabled(false);
                    }}
                  >
                    <RotateCcw className="w-3.5 h-3.5 mr-2" />
                    Limpiar todos los filtros
                  </Button>
                </div>
              </CollapsibleContent>
            </div>
          </Collapsible>

          {/* Device Count Header */}
          <div className="flex items-center justify-between px-1">
            <h3 className="text-sm">Dispositivos ({filteredDevices.length})</h3>
            <div className="flex items-center gap-2">
              <Badge variant="outline" className="text-xs">
                <Radio className="w-3 h-3 mr-1" />
                {filteredDevices.filter(d => d.type === "Emisor").length}
              </Badge>
              <Badge variant="outline" className="text-xs">
                <Repeat className="w-3 h-3 mr-1" />
                {filteredDevices.filter(d => d.type === "Repetidor").length}
              </Badge>
            </div>
          </div>

          {/* Device Cards Grid */}
          <div className="grid grid-cols-1 gap-3">
            {filteredDevices.map((device, index) => (
              <motion.div
                key={device.mac}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.05 }}
              >
                <DeviceHistorialCard
                  {...device}
                  onClick={() => setSelectedDevice(device)}
                />
              </motion.div>
            ))}
          </div>

          {filteredDevices.length === 0 && (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="bg-muted/30 rounded-xl p-8 text-center"
            >
              <Filter className="w-12 h-12 text-muted-foreground mx-auto mb-3 opacity-50" />
              <p className="text-sm text-muted-foreground">No se encontraron dispositivos</p>
              <p className="text-xs text-muted-foreground mt-1">Ajusta los filtros para ver más resultados</p>
            </motion.div>
          )}

          {/* Footer Actions */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.3 }}
            className="grid grid-cols-2 gap-3"
          >
            <Button variant="outline" size="sm" className="gap-2">
              <Download className="w-4 h-4" />
              Exportar
            </Button>
            <Button variant="outline" size="sm" className="gap-2">
              <RotateCcw className="w-4 h-4" />
              Resetear
            </Button>
          </motion.div>
        </div>
      </div>

      {/* Device Detail Dialog */}
      <AnimatePresence>
        {selectedDevice && (
          <DeviceDetailDialog
            device={selectedDevice}
            onClose={() => setSelectedDevice(null)}
          />
        )}
      </AnimatePresence>
    </>
  );
}
