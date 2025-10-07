import { Sun, Moon, Info, Settings, Download } from "lucide-react";
import { motion } from "motion/react";
import { Switch } from "./ui/switch";
import { Label } from "./ui/label";
import { Separator } from "./ui/separator";
import { Slider } from "./ui/slider";
import { RadioGroup, RadioGroupItem } from "./ui/radio-group";
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "./ui/accordion";

interface ConfiguracionProps {
  isDarkMode: boolean;
  onToggleDarkMode: (value: boolean) => void;
  scanTime: number[];
  onScanTimeChange: (value: number[]) => void;
  historialType: "repetidor" | "emisor" | "ambos";
  onHistorialTypeChange: (value: "repetidor" | "emisor" | "ambos") => void;
}

export function Configuracion({ isDarkMode, onToggleDarkMode, scanTime, onScanTimeChange, historialType, onHistorialTypeChange }: ConfiguracionProps) {
  return (
    <div className="flex-1 overflow-auto pb-20">
      {/* App Bar */}
      <div className="sticky top-0 z-10 bg-card border-b border-border shadow-sm">
        <div className="px-4 py-3 flex items-center justify-between">
          <h1 className="text-lg">Configuración</h1>
        </div>
      </div>

      <div className="p-4 space-y-4">
        {/* Scan Settings Section */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-card rounded-xl shadow-md border border-border overflow-hidden"
        >
          <Accordion type="single" collapsible className="w-full" defaultValue="scan-settings">
            <AccordionItem value="scan-settings" className="border-0">
              <AccordionTrigger className="px-4 py-3 hover:no-underline">
                <div className="flex items-center gap-2">
                  <Settings className="w-5 h-5 text-accent" />
                  <span className="text-sm">Ajustes de escaneo</span>
                </div>
              </AccordionTrigger>
              <AccordionContent className="px-4 pb-4 space-y-4">
                {/* Scan Time */}
                <div className="space-y-2">
                  <Label className="text-xs">
                    Tiempo de escaneo: {scanTime[0]} segundos
                  </Label>
                  <Slider
                    value={scanTime}
                    onValueChange={onScanTimeChange}
                    min={5}
                    max={300}
                    step={5}
                    className="py-2"
                  />
                  <p className="text-xs text-muted-foreground">
                    Define la duración de cada ciclo de escaneo BLE
                  </p>
                </div>

                <Separator />

                {/* Download Historiales Type */}
                <div className="space-y-3">
                  <div className="flex items-center gap-2">
                    <Download className="w-4 h-4 text-accent" />
                    <Label className="text-xs">
                      Bajar historiales al escanear
                    </Label>
                  </div>
                  <RadioGroup 
                    value={historialType} 
                    onValueChange={(value) => onHistorialTypeChange(value as "repetidor" | "emisor" | "ambos")}
                    className="space-y-2"
                  >
                    <div className="flex items-center space-x-3 bg-muted/50 rounded-lg px-3 py-2.5 border border-border/50 hover:border-accent/50 transition-colors">
                      <RadioGroupItem value="repetidor" id="repetidor" />
                      <Label htmlFor="repetidor" className="text-sm cursor-pointer flex-1">
                        Solo Repetidor
                      </Label>
                    </div>
                    <div className="flex items-center space-x-3 bg-muted/50 rounded-lg px-3 py-2.5 border border-border/50 hover:border-accent/50 transition-colors">
                      <RadioGroupItem value="emisor" id="emisor" />
                      <Label htmlFor="emisor" className="text-sm cursor-pointer flex-1">
                        Solo Emisor
                      </Label>
                    </div>
                    <div className="flex items-center space-x-3 bg-muted/50 rounded-lg px-3 py-2.5 border border-border/50 hover:border-accent/50 transition-colors">
                      <RadioGroupItem value="ambos" id="ambos" />
                      <Label htmlFor="ambos" className="text-sm cursor-pointer flex-1">
                        Emisor + Repetidor
                      </Label>
                    </div>
                  </RadioGroup>
                  <p className="text-xs text-muted-foreground">
                    Selecciona qué tipo de dispositivos descargarán historiales durante el escaneo
                  </p>
                </div>
              </AccordionContent>
            </AccordionItem>
          </Accordion>
        </motion.div>

        {/* Theme Section */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="bg-card rounded-xl p-4 shadow-sm border border-border space-y-4"
        >
          <div className="flex items-center gap-2">
            {isDarkMode ? (
              <Moon className="w-5 h-5 text-accent" />
            ) : (
              <Sun className="w-5 h-5 text-accent" />
            )}
            <h3 className="text-sm">Apariencia</h3>
          </div>
          
          <Separator />

          <div className="flex items-center justify-between">
            <div className="space-y-1">
              <Label className="text-sm">Modo oscuro</Label>
              <p className="text-xs text-muted-foreground">
                Cambia entre tema claro y oscuro
              </p>
            </div>
            <Switch
              checked={isDarkMode}
              onCheckedChange={onToggleDarkMode}
            />
          </div>
        </motion.div>

        {/* App Info Section */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="bg-card rounded-xl p-4 shadow-sm border border-border space-y-4"
        >
          <div className="flex items-center gap-2">
            <Info className="w-5 h-5 text-accent" />
            <h3 className="text-sm">Información de la aplicación</h3>
          </div>
          
          <Separator />

          <div className="space-y-3 text-xs">
            <div className="flex justify-between">
              <span className="text-muted-foreground">Versión</span>
              <span className="font-medium">1.0.0</span>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Tipo</span>
              <span className="font-medium">Monitor BLE</span>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Estado</span>
              <span className="font-medium text-green-500">Activo</span>
            </div>
          </div>
        </motion.div>

        {/* About Section */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="bg-card rounded-xl p-4 shadow-sm border border-border"
        >
          <div className="text-center space-y-2">
            <p className="text-xs text-muted-foreground">
              Monitor de paquetes de advertising BLE
            </p>
            <p className="text-xs text-muted-foreground">
              Diseñado para emisores y repetidores
            </p>
          </div>
        </motion.div>
      </div>
    </div>
  );
}
