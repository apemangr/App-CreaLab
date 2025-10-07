import { useState } from "react";
import { Play, Pause, BluetoothSearching, Filter, ChevronDown, Plus, X } from "lucide-react";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { Slider } from "./ui/slider";
import { Switch } from "./ui/switch";
import { Badge } from "./ui/badge";
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "./ui/accordion";
import { DeviceListItem } from "./DeviceListItem";
import { DeviceConfigDialog } from "./DeviceConfigDialog";
import { DeviceSelectionDialog } from "./DeviceSelectionDialog";
import { motion, AnimatePresence } from "motion/react";

const mockDevices = [
  {
    macAddress: "AA:BB:CC:DD:EE:01",
    deviceType: "Emisor" as const,
    rssi: -45,
    historiales: 234,
    connected: false,
    adc1: 1024,
    adc2: 896,
    desgaste: 2.5,
  },
  {
    macAddress: "AA:BB:CC:DD:EE:02",
    deviceType: "Repetidor" as const,
    rssi: -62,
    historiales: 156,
    connected: true,
    linkedEmitter: {
      macAddress: "AA:BB:CC:DD:EE:01",
      rssi: -45,
      historiales: 234,
      adc1: 1024,
      adc2: 896,
      desgaste: 2.5,
    },
  },
  {
    macAddress: "AA:BB:CC:DD:EE:03",
    deviceType: "Repetidor" as const,
    rssi: -51,
    historiales: 123,
    connected: false,
  },
  {
    macAddress: "AA:BB:CC:DD:EE:04",
    deviceType: "Repetidor" as const,
    rssi: -58,
    historiales: 189,
    connected: true,
    linkedEmitter: {
      macAddress: "AA:BB:CC:DD:EE:05",
      rssi: -52,
      historiales: 298,
      adc1: 1200,
      adc2: 850,
      desgaste: 0.9,
    },
  },
];

interface EscanearProps {
  scanTime: number[];
}

export function Escanear({ scanTime }: EscanearProps) {
  const [isScanning, setIsScanning] = useState(false);
  const [filtersEnabled, setFiltersEnabled] = useState(false);
  const [macSearch, setMacSearch] = useState("");
  const [rssiThreshold, setRssiThreshold] = useState([-80]);
  const [identifier, setIdentifier] = useState("");
  const [identifiers, setIdentifiers] = useState<string[]>([]);
  const [selectedDevice, setSelectedDevice] = useState<typeof mockDevices[0] | null>(null);
  const [isConfigDialogOpen, setIsConfigDialogOpen] = useState(false);
  const [isSelectionDialogOpen, setIsSelectionDialogOpen] = useState(false);
  const [clickedRepetidor, setClickedRepetidor] = useState<typeof mockDevices[0] | null>(null);

  const handleAddIdentifier = () => {
    if (identifier && identifier.length === 4 && !identifiers.includes(identifier.toUpperCase())) {
      setIdentifiers([...identifiers, identifier.toUpperCase()]);
      setIdentifier("");
    }
  };

  const handleRemoveIdentifier = (idToRemove: string) => {
    setIdentifiers(identifiers.filter(id => id !== idToRemove));
  };

  const handleIdentifierKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      e.preventDefault();
      handleAddIdentifier();
    }
  };

  const handleDeviceClick = (device: typeof mockDevices[0]) => {
    // Si es un repetidor conectado con emisor enlazado, mostrar diálogo de selección
    if (device.deviceType === "Repetidor" && device.connected && device.linkedEmitter) {
      setClickedRepetidor(device);
      setIsSelectionDialogOpen(true);
    } else {
      // Para emisores o repetidores sin enlace, ir directamente a configuración
      setSelectedDevice(device);
      setIsConfigDialogOpen(true);
    }
  };

  const handleSelectRepetidor = () => {
    if (clickedRepetidor) {
      setSelectedDevice(clickedRepetidor);
      setIsConfigDialogOpen(true);
    }
  };

  const handleSelectEmisor = () => {
    if (clickedRepetidor && clickedRepetidor.linkedEmitter) {
      // Crear un objeto de dispositivo para el emisor enlazado
      const emisorDevice = {
        macAddress: clickedRepetidor.linkedEmitter.macAddress,
        deviceType: "Emisor" as const,
        rssi: clickedRepetidor.linkedEmitter.rssi,
        historiales: clickedRepetidor.linkedEmitter.historiales,
        connected: false,
        adc1: clickedRepetidor.linkedEmitter.adc1,
        adc2: clickedRepetidor.linkedEmitter.adc2,
        desgaste: clickedRepetidor.linkedEmitter.desgaste,
      };
      setSelectedDevice(emisorDevice);
      setIsConfigDialogOpen(true);
    }
  };

  return (
    <div className="flex-1 overflow-auto pb-20">
      {/* App Bar */}
      <div className="sticky top-0 z-10 bg-card border-b border-border shadow-sm">
        <div className="px-4 py-3 flex items-center justify-between gap-3">
          <h1 className="text-lg">Escaneo BLE</h1>
          <div className="flex items-center gap-3">
            <div className="flex items-center gap-2">
              <Filter className="w-4 h-4 text-accent" />
              <span className="text-xs">Filtros</span>
            </div>
            <Switch
              checked={filtersEnabled}
              onCheckedChange={setFiltersEnabled}
            />
            <Button
              size="icon"
              variant={isScanning ? "destructive" : "default"}
              onClick={() => setIsScanning(!isScanning)}
            >
              {isScanning ? <Pause className="w-5 h-5" /> : <Play className="w-5 h-5" />}
            </Button>
          </div>
        </div>
      </div>

      <div className="p-4 space-y-4">
        {/* Filters Accordion - Can be enabled/disabled */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-card rounded-xl shadow-md border border-border overflow-hidden"
        >
          <Accordion type="single" collapsible className="w-full">
            <AccordionItem value="filters" className="border-0">
              <AccordionTrigger className="px-4 py-3 hover:no-underline">
                <div className={`flex items-center gap-2 ${!filtersEnabled ? 'opacity-50' : ''}`}>
                  <Filter className="w-4 h-4 text-accent" />
                  <span className="text-sm">Configurar filtros</span>
                </div>
              </AccordionTrigger>
              <AccordionContent className="px-4 pb-4 space-y-4">
                {/* MAC Filter */}
                <div className="space-y-2">
                  <Label className="text-xs">Buscar por dirección MAC</Label>
                  <Input
                    type="text"
                    value={macSearch}
                    onChange={(e) => setMacSearch(e.target.value)}
                    placeholder="AA:BB:CC:DD:EE:FF"
                    className="font-mono"
                    disabled={!filtersEnabled}
                  />
                </div>

                {/* Identifier Filter */}
                <div className="space-y-2">
                  <Label className="text-xs">Identificadores (4 caracteres hex)</Label>
                  <div className="flex gap-2">
                    <Input
                      type="text"
                      value={identifier}
                      onChange={(e) => {
                        const value = e.target.value.replace(/[^0-9A-Fa-f]/g, '').slice(0, 4).toUpperCase();
                        setIdentifier(value);
                      }}
                      onKeyDown={handleIdentifierKeyDown}
                      placeholder="0A3F"
                      className="font-mono uppercase"
                      disabled={!filtersEnabled}
                      maxLength={4}
                    />
                    <Button
                      size="icon"
                      onClick={handleAddIdentifier}
                      disabled={!filtersEnabled || !identifier || identifier.length !== 4}
                      className="shrink-0"
                    >
                      <Plus className="w-5 h-5" />
                    </Button>
                  </div>
                  {identifiers.length > 0 && (
                    <div className="flex flex-wrap gap-2 pt-1">
                      {identifiers.map((id) => (
                        <Badge
                          key={id}
                          variant="secondary"
                          className="font-mono px-3 py-1.5 flex items-center gap-2"
                        >
                          {id}
                          <button
                            onClick={() => handleRemoveIdentifier(id)}
                            disabled={!filtersEnabled}
                            className="ml-0.5 hover:bg-destructive hover:text-destructive-foreground rounded-full p-0.5 transition-all disabled:opacity-50 disabled:hover:bg-transparent"
                          >
                            <X className="w-3.5 h-3.5" />
                          </button>
                        </Badge>
                      ))}
                    </div>
                  )}
                </div>

                {/* RSSI Filter */}
                <div className="space-y-2">
                  <Label className="text-xs">
                    Umbral RSSI mínimo: {rssiThreshold[0]} dBm
                  </Label>
                  <Slider
                    value={rssiThreshold}
                    onValueChange={setRssiThreshold}
                    min={-100}
                    max={-30}
                    step={5}
                    className="py-2"
                    disabled={!filtersEnabled}
                  />
                </div>

                <Button className="w-full" size="sm" disabled={!filtersEnabled}>
                  Aplicar filtros
                </Button>
              </AccordionContent>
            </AccordionItem>
          </Accordion>
        </motion.div>

        {/* Real-time Devices List */}
        <div className="space-y-3">
          <h3 className="text-sm px-1">Dispositivos detectados ({mockDevices.length})</h3>
          <AnimatePresence>
            {mockDevices.map((device, index) => (
              <motion.div
                key={device.macAddress}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: 20 }}
                transition={{ delay: index * 0.1 }}
              >
                <DeviceListItem 
                  {...device} 
                  onDeviceClick={() => handleDeviceClick(device)}
                />
              </motion.div>
            ))}
          </AnimatePresence>
        </div>

      </div>

      {/* Device Selection Dialog (for linked repeaters) */}
      {clickedRepetidor && clickedRepetidor.linkedEmitter && (
        <DeviceSelectionDialog
          open={isSelectionDialogOpen}
          onOpenChange={setIsSelectionDialogOpen}
          repetidor={{
            macAddress: clickedRepetidor.macAddress,
            rssi: clickedRepetidor.rssi,
            historiales: clickedRepetidor.historiales,
          }}
          emisor={clickedRepetidor.linkedEmitter}
          onSelectRepetidor={handleSelectRepetidor}
          onSelectEmisor={handleSelectEmisor}
        />
      )}

      {/* Device Configuration Dialog */}
      <DeviceConfigDialog 
        open={isConfigDialogOpen}
        onOpenChange={setIsConfigDialogOpen}
        device={selectedDevice}
      />

      {/* Bottom Status Bar */}
      <div className="fixed bottom-16 left-0 right-0 bg-card border-t border-border px-4 py-2 z-10">
        <div className="flex items-center justify-center gap-2">
          {isScanning && (
            <motion.div
              animate={{ scale: [1, 1.2, 1] }}
              transition={{ repeat: Infinity, duration: 1.5 }}
            >
              <BluetoothSearching className="w-4 h-4 text-accent" />
            </motion.div>
          )}
          <span className="text-xs text-muted-foreground">
            {isScanning ? "Escaneando..." : "Detenido"}
          </span>
        </div>
      </div>
    </div>
  );
}
