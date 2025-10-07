import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogClose,
} from "./ui/dialog";
import { Button } from "./ui/button";
import { Radio, Link, Signal, Gauge, Activity, X } from "lucide-react";
import { Badge } from "./ui/badge";

interface LinkedEmitter {
  macAddress: string;
  rssi: number;
  historiales: number;
  adc1?: number;
  adc2?: number;
  desgaste?: number;
}

interface DeviceSelectionDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  repetidor: {
    macAddress: string;
    rssi: number;
    historiales: number;
  };
  emisor: LinkedEmitter;
  onSelectRepetidor: () => void;
  onSelectEmisor: () => void;
}

export function DeviceSelectionDialog({
  open,
  onOpenChange,
  repetidor,
  emisor,
  onSelectRepetidor,
  onSelectEmisor,
}: DeviceSelectionDialogProps) {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-md [&>button:not([data-custom-close])]:hidden">
        {/* Botón de cerrar personalizado - solo X */}
        <DialogClose 
          data-custom-close
          className="absolute top-4 right-4 z-10 rounded-md bg-red-500 text-white p-2 transition-all hover:bg-red-600 focus:ring-2 focus:ring-offset-2 focus:outline-hidden disabled:pointer-events-none shadow-lg"
        >
          <X className="w-4 h-4" />
        </DialogClose>

        <DialogHeader className="text-center">
          <DialogTitle className="flex items-center justify-center gap-2">
            <Link className="w-5 h-5 text-accent" />
            Seleccionar dispositivo
          </DialogTitle>
          <DialogDescription className="pt-2">
            Este repetidor está enlazado a un emisor.
            <br />
            ¿Cuál dispositivo deseas configurar?
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-3 py-4">
          {/* Repetidor Option */}
          <Button
            variant="outline"
            className="w-full h-auto p-4 flex items-center justify-between hover:bg-accent/10 hover:border-accent transition-all"
            onClick={() => {
              onSelectRepetidor();
              onOpenChange(false);
            }}
          >
            <div className="flex items-center gap-2">
              <Radio className="w-4 h-4 text-accent" />
              <span className="font-mono text-sm">{repetidor.macAddress}</span>
            </div>
            <Badge variant="secondary">Repetidor</Badge>
          </Button>

          {/* Emisor Enlazado Option */}
          <Button
            variant="outline"
            className="w-full h-auto p-4 flex items-center justify-between hover:bg-accent/10 hover:border-accent transition-all"
            onClick={() => {
              onSelectEmisor();
              onOpenChange(false);
            }}
          >
            <div className="flex items-center gap-2">
              <Radio className="w-4 h-4 text-accent" />
              <span className="font-mono text-sm">{emisor.macAddress}</span>
            </div>
            <Badge variant="default">Emisor</Badge>
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}
