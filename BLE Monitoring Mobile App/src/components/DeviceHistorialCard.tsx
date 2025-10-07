import { motion } from "motion/react";
import { Radio, Repeat, Signal, ChevronRight, ScrollText } from "lucide-react";
import { Badge } from "./ui/badge";

interface DeviceHistorialCardProps {
  mac: string;
  name: string;
  type: "Emisor" | "Repetidor";
  rssi: number;
  packets: number;
  lastSeen: string;
  onClick: () => void;
}

export function DeviceHistorialCard({
  mac,
  name,
  type,
  rssi,
  packets,
  lastSeen,
  onClick,
}: DeviceHistorialCardProps) {
  const getSignalColor = (rssi: number) => {
    if (rssi >= -50) return "text-green-500";
    if (rssi >= -70) return "text-yellow-500";
    return "text-red-500";
  };

  return (
    <motion.button
      initial={{ opacity: 0, scale: 0.95 }}
      animate={{ opacity: 1, scale: 1 }}
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
      onClick={onClick}
      className="w-full bg-gradient-to-br from-card to-card/80 rounded-xl p-4 shadow-md border border-border hover:border-accent/50 hover:shadow-lg transition-all text-left"
    >
      {/* Header */}
      <div className="flex items-start justify-between mb-3">
        <div className="flex items-center gap-2">
          <div className="w-10 h-10 rounded-full bg-accent/10 flex items-center justify-center">
            {type === "Emisor" ? (
              <Radio className="w-5 h-5 text-accent" />
            ) : (
              <Repeat className="w-5 h-5 text-accent" />
            )}
          </div>
          <div>
            <h3 className="text-sm">{name}</h3>
            <p className="text-xs text-muted-foreground font-mono">{mac}</p>
          </div>
        </div>
        <Badge variant={type === "Emisor" ? "default" : "secondary"} className="text-xs">
          {type}
        </Badge>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-3 gap-2 mb-3">
        <div className="bg-muted/30 rounded-lg px-2 py-1.5">
          <div className="flex items-center gap-1 mb-0.5">
            <Signal className={`w-3 h-3 ${getSignalColor(rssi)}`} />
            <span className="text-xs text-muted-foreground">RSSI</span>
          </div>
          <p className="text-xs">{rssi} dBm</p>
        </div>
        <div className="bg-muted/30 rounded-lg px-2 py-1.5">
          <div className="flex items-center gap-1 mb-0.5">
            <ScrollText className="w-3 h-3 text-accent" />
            <span className="text-xs text-muted-foreground">Historiales</span>
          </div>
          <p className="text-xs">{packets}</p>
        </div>
        <div className="bg-muted/30 rounded-lg px-2 py-1.5">
          <span className="text-xs text-muted-foreground block mb-0.5">Última</span>
          <p className="text-xs">{lastSeen}</p>
        </div>
      </div>

      {/* Footer */}
      <div className="flex items-center justify-between pt-2 border-t border-border/50">
        <span className="text-xs text-muted-foreground">Ver estadísticas</span>
        <ChevronRight className="w-4 h-4 text-accent" />
      </div>
    </motion.button>
  );
}
