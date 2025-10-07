import { useState, useEffect } from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "./ui/dialog";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "./ui/alert-dialog";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { Switch } from "./ui/switch";
import { Slider } from "./ui/slider";
import { Badge } from "./ui/badge";
import { 
  Radio, 
  Signal, 
  Save,
  RotateCcw,
  Gauge,
  Activity,
  Search,
  Moon,
  Sun,
  Download,
  Trash2,
  RefreshCw,
  Hash,
  Scissors,
  CircuitBoard
} from "lucide-react";
import { Separator } from "./ui/separator";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "./ui/select";
import { Checkbox } from "./ui/checkbox";

interface LinkedEmitter {
  macAddress: string;
  rssi: number;
  historiales: number;
  adc1?: number;
  adc2?: number;
  desgaste?: number;
}

interface DeviceConfigDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  device: {
    macAddress: string;
    deviceType: "Emisor" | "Repetidor";
    rssi: number;
    historiales: number;
    connected: boolean;
    adc1?: number;
    adc2?: number;
    desgaste?: number;
    linkedEmitter?: LinkedEmitter;
  } | null;
}

export function DeviceConfigDialog({ open, onOpenChange, device }: DeviceConfigDialogProps) {
  // Estados para configuración de Emisor
  const [vecesReiniciado, setVecesReiniciado] = useState(0);
  const [tiempoDormidoEmisor, setTiempoDormidoEmisor] = useState([300]); // segundos
  const [tiempoEncendidoEmisor, setTiempoEncendidoEmisor] = useState([60]); // segundos
  const [cantidadADV, setCantidadADV] = useState(100);
  const [macCustom, setMacCustom] = useState("");
  const [habilitarMacCustom, setHabilitarMacCustom] = useState(false);
  const [tipoSensor, setTipoSensor] = useState("tipo1");
  const [offset, setOffset] = useState(0);
  const [cortesSensor, setCortesSensor] = useState(0);
  
  // Estados para configuración de Repetidor
  const [macRepetidor, setMacRepetidor] = useState("");
  const [macEmisor, setMacEmisor] = useState("");
  const [tiempoEncendido, setTiempoEncendido] = useState([60]); // segundos
  const [tiempoDormido, setTiempoDormido] = useState([300]); // segundos
  const [tiempoBusqueda, setTiempoBusqueda] = useState([30]); // segundos

  // Estado para el diálogo de confirmación de borrar historiales
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);

  // Cargar valores del repetidor cuando se conecta
  useEffect(() => {
    if (device && device.deviceType === "Repetidor") {
      // Cargar la MAC del repetidor desde el dispositivo conectado
      setMacRepetidor(device.macAddress);
      // Cargar la MAC del emisor enlazado si existe
      if (device.linkedEmitter) {
        setMacEmisor(device.linkedEmitter.macAddress);
      }
    }
  }, [device]);

  if (!device) return null;

  const handleSaveConfig = () => {
    // Aquí iría la lógica para guardar la configuración al dispositivo
    if (device.deviceType === "Emisor") {
      console.log("Guardando configuración Emisor...", {
        macAddress: device.macAddress,
        vecesReiniciado,
        tiempoDormido: tiempoDormidoEmisor[0],
        tiempoEncendido: tiempoEncendidoEmisor[0],
        cantidadADV,
        macCustom: habilitarMacCustom ? macCustom : null,
        tipoSensor,
        offset,
        cortesSensor,
      });
    } else {
      console.log("Guardando configuración Repetidor...", {
        macRepetidor,
        macEmisor,
        tiempoEncendido: tiempoEncendido[0],
        tiempoDormido: tiempoDormido[0],
        tiempoBusqueda: tiempoBusqueda[0],
      });
    }
    onOpenChange(false);
  };

  const handleBorrarHistoriales = () => {
    console.log("Borrando historiales del dispositivo...", device.macAddress);
    // Aquí iría la lógica para borrar historiales
    setShowDeleteConfirm(false);
  };

  const handleBajarHistoriales = () => {
    console.log("Bajando historiales del dispositivo...", device.macAddress);
    // Aquí iría la lógica para descargar historiales
  };

  const handleReset = () => {
    // Reset para Emisor
    setVecesReiniciado(0);
    setTiempoDormidoEmisor([300]);
    setTiempoEncendidoEmisor([60]);
    setCantidadADV(100);
    setMacCustom("");
    setHabilitarMacCustom(false);
    setTipoSensor("tipo1");
    setOffset(0);
    setCortesSensor(0);
    
    // Reset para Repetidor
    setMacRepetidor("");
    setMacEmisor("");
    setTiempoEncendido([60]);
    setTiempoDormido([300]);
    setTiempoBusqueda([30]);
  };

  return (
    <>
      <Dialog open={open} onOpenChange={onOpenChange}>
        <DialogContent className="max-w-3xl max-h-[90vh] overflow-y-auto w-[95vw]">
        <DialogHeader className="text-left">
          <DialogTitle className="flex items-center gap-2">
            <Radio className="w-5 h-5 text-accent" />
            <div className="flex flex-col">
              <span>{device.deviceType}</span>
              <span className="font-mono text-sm text-muted-foreground font-normal">{device.macAddress}</span>
            </div>
          </DialogTitle>
          <DialogDescription className="sr-only">
            Configuración del dispositivo {device.deviceType}
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-4 py-4">
          {/* Device Info */}
          <div className="flex items-center justify-between p-3 bg-muted/50 rounded-lg border border-border">
            <div className="flex items-center gap-2">
              <Badge variant={device.deviceType === "Emisor" ? "default" : "secondary"}>
                {device.deviceType}
              </Badge>
              <div className="flex items-center gap-1 text-xs text-muted-foreground">
                <Signal className="w-3.5 h-3.5" />
                <span>{device.rssi} dBm</span>
              </div>
            </div>
            <div className={`w-2 h-2 rounded-full ${device.connected ? "bg-green-500" : "bg-red-500"}`} />
          </div>

          {/* Emisor Measurements */}
          {device.deviceType === "Emisor" && (device.adc1 !== undefined || device.adc2 !== undefined || device.desgaste !== undefined) && (
            <div className="space-y-2">
              <Label className="text-xs text-muted-foreground">Mediciones actuales</Label>
              <div className="bg-muted/40 rounded-lg px-3 py-2 border border-border">
                <div className="grid grid-cols-[auto_auto_1fr] gap-2 text-xs">
                  {device.adc1 !== undefined && (
                    <div className="flex items-center gap-1">
                      <Gauge className="w-3.5 h-3.5 text-accent" />
                      <span className="text-muted-foreground">ADC1:</span>
                      <span className="font-medium">{device.adc1}</span>
                    </div>
                  )}
                  {device.adc2 !== undefined && (
                    <div className="flex items-center gap-1">
                      <Gauge className="w-3.5 h-3.5 text-accent" />
                      <span className="text-muted-foreground">ADC2:</span>
                      <span className="font-medium">{device.adc2}</span>
                    </div>
                  )}
                  {device.desgaste !== undefined && (
                    <div className="flex items-center gap-1">
                      <Activity className="w-3.5 h-3.5 text-accent" />
                      <span className="text-muted-foreground">Desgaste:</span>
                      <span className="font-medium">{device.desgaste} mm</span>
                    </div>
                  )}
                </div>
              </div>
            </div>
          )}

          {/* Repetidor Measurements and Info */}
          {device.deviceType === "Repetidor" && (
            <div className="space-y-2">
              <Label className="text-xs text-muted-foreground">Métricas del repetidor</Label>
              <div className="bg-muted/40 rounded-lg px-3 py-2 border border-border space-y-2">
                <div className="flex items-center gap-3 text-xs">
                  <div className="flex items-center gap-1">
                    <Signal className="w-3.5 h-3.5 text-accent" />
                    <span className="text-muted-foreground">RSSI:</span>
                    <span className="font-medium">{device.rssi} dBm</span>
                  </div>
                  <div className="flex items-center gap-1">
                    <span className="text-muted-foreground">Historiales:</span>
                    <span className="font-medium">{device.historiales}</span>
                  </div>
                </div>
                {(device.adc1 !== undefined || device.adc2 !== undefined || device.desgaste !== undefined) && (
                  <div className="grid grid-cols-[auto_auto_1fr] gap-2 text-xs pt-1 border-t border-border">
                    {device.adc1 !== undefined && (
                      <div className="flex items-center gap-1">
                        <Gauge className="w-3.5 h-3.5 text-accent" />
                        <span className="text-muted-foreground">ADC1:</span>
                        <span className="font-medium">{device.adc1}</span>
                      </div>
                    )}
                    {device.adc2 !== undefined && (
                      <div className="flex items-center gap-1">
                        <Gauge className="w-3.5 h-3.5 text-accent" />
                        <span className="text-muted-foreground">ADC2:</span>
                        <span className="font-medium">{device.adc2}</span>
                      </div>
                    )}
                    {device.desgaste !== undefined && (
                      <div className="flex items-center gap-1">
                        <Activity className="w-3.5 h-3.5 text-accent" />
                        <span className="text-muted-foreground">Desgaste:</span>
                        <span className="font-medium">{device.desgaste} mm</span>
                      </div>
                    )}
                  </div>
                )}
              </div>
            </div>
          )}

          {/* Linked Emitter Info */}
          {device.deviceType === "Repetidor" && device.connected && device.linkedEmitter && (
            <div className="space-y-2">
              <Label className="text-xs text-muted-foreground">Emisor enlazado</Label>
              <div className="bg-muted/40 rounded-lg px-3 py-2 space-y-2 border border-border">
                <div className="font-mono text-xs">{device.linkedEmitter.macAddress}</div>
                <div className="flex items-center gap-3 text-xs">
                  <div className="flex items-center gap-1">
                    <span className="text-muted-foreground">RSSI:</span>
                    <span className="font-medium">{device.linkedEmitter.rssi} dBm</span>
                  </div>
                  <div className="flex items-center gap-1">
                    <span className="text-muted-foreground">Historiales:</span>
                    <span className="font-medium">{device.linkedEmitter.historiales}</span>
                  </div>
                </div>
                {(device.linkedEmitter.adc1 !== undefined || device.linkedEmitter.adc2 !== undefined || device.linkedEmitter.desgaste !== undefined) && (
                  <div className="grid grid-cols-[auto_auto_1fr] gap-2 text-xs pt-1">
                    {device.linkedEmitter.adc1 !== undefined && (
                      <div className="flex items-center gap-1">
                        <Gauge className="w-3.5 h-3.5 text-accent" />
                        <span className="text-muted-foreground">ADC1:</span>
                        <span className="font-medium">{device.linkedEmitter.adc1}</span>
                      </div>
                    )}
                    {device.linkedEmitter.adc2 !== undefined && (
                      <div className="flex items-center gap-1">
                        <Gauge className="w-3.5 h-3.5 text-accent" />
                        <span className="text-muted-foreground">ADC2:</span>
                        <span className="font-medium">{device.linkedEmitter.adc2}</span>
                      </div>
                    )}
                    {device.linkedEmitter.desgaste !== undefined && (
                      <div className="flex items-center gap-1">
                        <Activity className="w-3.5 h-3.5 text-accent" />
                        <span className="text-muted-foreground">Desgaste:</span>
                        <span className="font-medium">{device.linkedEmitter.desgaste} mm</span>
                      </div>
                    )}
                  </div>
                )}
              </div>
            </div>
          )}

          <Separator />

          {/* Configuración específica para EMISOR */}
          {device.deviceType === "Emisor" && (
            <>
              {/* Veces Reiniciado */}
              <div className="space-y-2">
                <Label htmlFor="veces-reiniciado" className="text-xs flex items-center gap-2">
                  <RefreshCw className="w-3.5 h-3.5 text-accent" />
                  Veces reiniciado
                </Label>
                <Input
                  id="veces-reiniciado"
                  type="number"
                  value={vecesReiniciado}
                  onChange={(e) => setVecesReiniciado(Number(e.target.value))}
                  min={0}
                />
              </div>

              {/* Tiempo Dormido */}
              <div className="space-y-2">
                <Label className="text-xs flex items-center gap-2">
                  <Moon className="w-3.5 h-3.5 text-accent" />
                  Tiempo dormido: {tiempoDormidoEmisor[0]} segundos
                </Label>
                <Slider
                  value={tiempoDormidoEmisor}
                  onValueChange={setTiempoDormidoEmisor}
                  min={30}
                  max={600}
                  step={30}
                  className="py-2"
                />
                <p className="text-xs text-muted-foreground">
                  Duración del periodo de bajo consumo
                </p>
              </div>

              {/* Tiempo Encendido */}
              <div className="space-y-2">
                <Label className="text-xs flex items-center gap-2">
                  <Sun className="w-3.5 h-3.5 text-accent" />
                  Tiempo encendido: {tiempoEncendidoEmisor[0]} segundos
                </Label>
                <Slider
                  value={tiempoEncendidoEmisor}
                  onValueChange={setTiempoEncendidoEmisor}
                  min={10}
                  max={300}
                  step={10}
                  className="py-2"
                />
                <p className="text-xs text-muted-foreground">
                  Duración del periodo activo del emisor
                </p>
              </div>

              {/* Cantidad ADV */}
              <div className="space-y-2">
                <Label htmlFor="cantidad-adv" className="text-xs flex items-center gap-2">
                  <Hash className="w-3.5 h-3.5 text-accent" />
                  Cantidad ADV
                </Label>
                <Input
                  id="cantidad-adv"
                  type="number"
                  value={cantidadADV}
                  onChange={(e) => setCantidadADV(Number(e.target.value))}
                  min={1}
                />
              </div>

              <Separator />

              {/* Habilitar MAC Custom */}
              <div className="flex items-center space-x-2 p-3 bg-muted/40 rounded-lg border border-border">
                <Checkbox
                  id="habilitar-mac-custom"
                  checked={habilitarMacCustom}
                  onCheckedChange={(checked) => setHabilitarMacCustom(checked as boolean)}
                />
                <Label htmlFor="habilitar-mac-custom" className="text-xs flex-1 cursor-pointer">
                  Habilitar MAC Custom
                </Label>
              </div>

              {/* MAC Custom */}
              {habilitarMacCustom && (
                <div className="space-y-2">
                  <Label htmlFor="mac-custom" className="text-xs">
                    MAC Custom
                  </Label>
                  <Input
                    id="mac-custom"
                    value={macCustom}
                    onChange={(e) => setMacCustom(e.target.value)}
                    placeholder="XX:XX:XX:XX:XX:XX"
                    className="font-mono"
                  />
                </div>
              )}

              {/* Tipo de Sensor */}
              <div className="space-y-2">
                <Label htmlFor="tipo-sensor" className="text-xs flex items-center gap-2">
                  <CircuitBoard className="w-3.5 h-3.5 text-accent" />
                  Tipo de sensor
                </Label>
                <Select value={tipoSensor} onValueChange={setTipoSensor}>
                  <SelectTrigger id="tipo-sensor">
                    <SelectValue placeholder="Seleccionar tipo" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="tipo1">Tipo 1 - Analógico</SelectItem>
                    <SelectItem value="tipo2">Tipo 2 - Digital</SelectItem>
                    <SelectItem value="tipo3">Tipo 3 - I2C</SelectItem>
                    <SelectItem value="tipo4">Tipo 4 - SPI</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              {/* Offset */}
              <div className="space-y-2">
                <Label htmlFor="offset" className="text-xs flex items-center gap-2">
                  <Gauge className="w-3.5 h-3.5 text-accent" />
                  Offset
                </Label>
                <Input
                  id="offset"
                  type="number"
                  value={offset}
                  onChange={(e) => setOffset(Number(e.target.value))}
                />
              </div>

              {/* Cortes Sensor */}
              <div className="space-y-2">
                <Label htmlFor="cortes-sensor" className="text-xs flex items-center gap-2">
                  <Scissors className="w-3.5 h-3.5 text-accent" />
                  Cortes sensor
                </Label>
                <Input
                  id="cortes-sensor"
                  type="number"
                  value={cortesSensor}
                  onChange={(e) => setCortesSensor(Number(e.target.value))}
                  min={0}
                />
              </div>

              <Separator />

              {/* Botones de Historiales */}
              <div className="grid grid-cols-2 gap-2">
                <Button
                  variant="outline"
                  onClick={handleBajarHistoriales}
                  className="w-full"
                >
                  <Download className="w-4 h-4 mr-2" />
                  Bajar Historiales
                </Button>
                <Button
                  variant="destructive"
                  onClick={() => setShowDeleteConfirm(true)}
                  className="w-full"
                >
                  <Trash2 className="w-4 h-4 mr-2" />
                  Borrar Historiales
                </Button>
              </div>
            </>
          )}

          {/* Configuración específica para REPETIDOR */}
          {device.deviceType === "Repetidor" && (
            <>
              {/* MAC Repetidor */}
              <div className="space-y-2">
                <Label htmlFor="mac-repetidor" className="text-xs">
                  MAC Repetidor
                </Label>
                <Input
                  id="mac-repetidor"
                  value={macRepetidor}
                  onChange={(e) => setMacRepetidor(e.target.value)}
                  placeholder="XX:XX:XX:XX:XX:XX"
                  className="font-mono"
                />
              </div>

              {/* MAC Emisor */}
              <div className="space-y-2">
                <Label htmlFor="mac-emisor" className="text-xs">
                  MAC Emisor
                </Label>
                <Input
                  id="mac-emisor"
                  value={macEmisor}
                  onChange={(e) => setMacEmisor(e.target.value)}
                  placeholder="XX:XX:XX:XX:XX:XX"
                  className="font-mono"
                />
              </div>

              <Separator />

              {/* Tiempo Encendido */}
              <div className="space-y-2">
                <Label className="text-xs flex items-center gap-2">
                  <Sun className="w-3.5 h-3.5 text-accent" />
                  Tiempo encendido: {tiempoEncendido[0]} segundos
                </Label>
                <Slider
                  value={tiempoEncendido}
                  onValueChange={setTiempoEncendido}
                  min={10}
                  max={300}
                  step={10}
                  className="py-2"
                />
                <p className="text-xs text-muted-foreground">
                  Duración del periodo activo del repetidor
                </p>
              </div>

              {/* Tiempo Dormido */}
              <div className="space-y-2">
                <Label className="text-xs flex items-center gap-2">
                  <Moon className="w-3.5 h-3.5 text-accent" />
                  Tiempo dormido: {tiempoDormido[0]} segundos
                </Label>
                <Slider
                  value={tiempoDormido}
                  onValueChange={setTiempoDormido}
                  min={30}
                  max={600}
                  step={30}
                  className="py-2"
                />
                <p className="text-xs text-muted-foreground">
                  Duración del periodo de bajo consumo
                </p>
              </div>

              {/* Tiempo Búsqueda */}
              <div className="space-y-2">
                <Label className="text-xs flex items-center gap-2">
                  <Search className="w-3.5 h-3.5 text-accent" />
                  Tiempo búsqueda: {tiempoBusqueda[0]} segundos
                </Label>
                <Slider
                  value={tiempoBusqueda}
                  onValueChange={setTiempoBusqueda}
                  min={5}
                  max={120}
                  step={5}
                  className="py-2"
                />
                <p className="text-xs text-muted-foreground">
                  Tiempo dedicado a buscar emisores cercanos
                </p>
              </div>

              <Separator />

              {/* Botones de Historiales */}
              <div className="grid grid-cols-2 gap-2">
                <Button
                  variant="outline"
                  onClick={handleBajarHistoriales}
                  className="w-full"
                >
                  <Download className="w-4 h-4 mr-2" />
                  Bajar Historiales
                </Button>
                <Button
                  variant="destructive"
                  onClick={() => setShowDeleteConfirm(true)}
                  className="w-full"
                >
                  <Trash2 className="w-4 h-4 mr-2" />
                  Borrar Historiales
                </Button>
              </div>
            </>
          )}
        </div>

        <DialogFooter>
          <Button
            onClick={handleSaveConfig}
            className="w-full"
          >
            <Save className="w-4 h-4 mr-2" />
            Guardar configuración
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>

    {/* Diálogo de confirmación para borrar historiales */}
    <AlertDialog open={showDeleteConfirm} onOpenChange={setShowDeleteConfirm}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>¿Estás seguro?</AlertDialogTitle>
          <AlertDialogDescription>
            Esta acción eliminará permanentemente todos los historiales del dispositivo{" "}
            <span className="font-mono text-foreground">{device?.macAddress}</span>.
            Esta acción no se puede deshacer.
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel>Cancelar</AlertDialogCancel>
          <AlertDialogAction
            onClick={handleBorrarHistoriales}
            className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
          >
            Borrar Historiales
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
    </>
  );
}
