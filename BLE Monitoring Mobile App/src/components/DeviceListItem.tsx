import { motion } from "motion/react";
import { Signal, Radio, Link, Gauge, Activity } from "lucide-react";
import { Badge } from "./ui/badge";

interface LinkedEmitter {
  macAddress: string;
  rssi: number;
  historiales: number;
  adc1?: number;
  adc2?: number;
  desgaste?: number;
}

interface DeviceListItemProps {
  macAddress: string;
  deviceType: "Emisor" | "Repetidor";
  rssi: number;
  historiales: number;
  connected: boolean;
  adc1?: number;
  adc2?: number;
  desgaste?: number;
  linkedEmitter?: LinkedEmitter;
  onDeviceClick?: () => void;
}

export function DeviceListItem({
  macAddress,
  deviceType,
  rssi,
  historiales,
  connected,
  adc1,
  adc2,
  desgaste,
  linkedEmitter,
  onDeviceClick,
}: DeviceListItemProps) {
  const getSignalStrength = (rssi: number) => {
    if (rssi > -50) return { bars: 4, color: "text-green-500" };
    if (rssi > -70) return { bars: 3, color: "text-yellow-500" };
    if (rssi > -85) return { bars: 2, color: "text-orange-500" };
    return { bars: 1, color: "text-red-500" };
  };

  const signal = getSignalStrength(rssi);

  return (
    <motion.div
      initial={{ opacity: 0, x: -20 }}
      animate={{ opacity: 1, x: 0 }}
      onClick={onDeviceClick}
      className="bg-card rounded-xl p-3 shadow-sm border border-border cursor-pointer hover:shadow-md hover:border-accent/50 transition-all"
    >
      {/* Device Header */}
      <div className="flex items-center justify-between mb-2">
        <div className="flex items-center gap-2">
          <Radio className="w-4 h-4 text-accent" />
          <span className="font-mono text-sm">{macAddress}</span>
          <Badge variant={deviceType === "Emisor" ? "default" : "secondary"} className="text-xs px-1.5 py-0">
            {deviceType}
          </Badge>
        </div>
        <div className={`w-1.5 h-1.5 rounded-full ${connected ? "bg-green-500" : "bg-red-500"}`} />
      </div>

      {/* Device Stats */}
      <div className="flex items-center gap-4 text-xs mb-2">
        <div className="flex items-center gap-1">
          <Signal className={`w-3.5 h-3.5 ${signal.color}`} />
          <span className="text-muted-foreground">RSSI:</span>
          <span className="font-medium">{rssi} dBm</span>
        </div>
        <div className="flex items-center gap-1">
          <span className="text-muted-foreground">Historiales:</span>
          <span className="font-medium">{historiales}</span>
        </div>
      </div>

      {/* ADC and Desgaste Measurements - Only for Emisor */}
      {deviceType === "Emisor" && (adc1 !== undefined || adc2 !== undefined || desgaste !== undefined) && (
        <div className="bg-muted/30 rounded-lg px-2 py-1.5 mb-2">
          <div className="grid grid-cols-[auto_auto_1fr] gap-2 text-xs">
            {adc1 !== undefined && (
              <div className="flex items-center gap-0.5">
                <Gauge className="w-3 h-3 text-accent" />
                <span className="text-muted-foreground">ADC1:</span>
                <span className="font-medium">{adc1}</span>
              </div>
            )}
            {adc2 !== undefined && (
              <div className="flex items-center gap-0.5">
                <Gauge className="w-3 h-3 text-accent" />
                <span className="text-muted-foreground">ADC2:</span>
                <span className="font-medium">{adc2}</span>
              </div>
            )}
            {desgaste !== undefined && (
              <div className="flex items-center gap-1">
                <Activity className="w-3 h-3 text-accent" />
                <span className="text-muted-foreground">Desgaste:</span>
                <span className="font-medium">{desgaste} mm</span>
              </div>
            )}
          </div>
        </div>
      )}

      {/* Linked Emitter Info (if connected) */}
      {connected && linkedEmitter && (
        <div className="mt-2 pt-2 border-t border-border">
          <div className="flex items-center gap-1.5 mb-1.5">
            <Link className="w-3.5 h-3.5 text-accent" />
            <span className="text-xs text-muted-foreground">Emisor enlazado:</span>
          </div>
          <div className="space-y-2 p-[0px]">
            <div className="flex items-center gap-2">
              <span className="font-mono text-sm text-foreground">{linkedEmitter.macAddress}</span>
            </div>
            <div className="flex items-center gap-4 text-xs">
              <div className="flex items-center gap-1">
                <span className="text-muted-foreground">RSSI:</span>
                <span className="font-medium">{linkedEmitter.rssi} dBm</span>
              </div>
              <div className="flex items-center gap-1">
                <span className="text-muted-foreground">Historiales:</span>
                <span className="font-medium">{linkedEmitter.historiales}</span>
              </div>
            </div>
            
            {/* Linked Emitter ADC and Desgaste */}
            {(linkedEmitter.adc1 !== undefined || linkedEmitter.adc2 !== undefined || linkedEmitter.desgaste !== undefined) && (
              <div className="bg-muted/20 rounded-lg px-2 py-1.5 px-[0px] py-[6px]">
                <div className="grid grid-cols-[auto_auto_1fr] gap-2 text-xs">
                  {linkedEmitter.adc1 !== undefined && (
                    <div className="flex items-center gap-0.5">
                      <Gauge className="w-3 h-3 text-accent" />
                      <span className="text-muted-foreground">ADC1:</span>
                      <span className="font-medium">{linkedEmitter.adc1}</span>
                    </div>
                  )}
                  {linkedEmitter.adc2 !== undefined && (
                    <div className="flex items-center gap-0.5 px-[10px] py-[0px]">
                      <Gauge className="w-3 h-3 text-accent" />
                      <span className="text-muted-foreground">ADC2:</span>
                      <span className="font-medium">{linkedEmitter.adc2}</span>
                    </div>
                  )}
                  {linkedEmitter.desgaste !== undefined && (
                    <div className="flex items-center gap-1">
                      <Activity className="w-3 h-3 text-accent" />
                      <span className="text-muted-foreground">Desgaste:</span>
                      <span className="font-medium">{linkedEmitter.desgaste} mm</span>
                    </div>
                  )}
                </div>
              </div>
            )}
          </div>
        </div>
      )}
    </motion.div>
  );
}
