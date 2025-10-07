import { X, Radio, Repeat, Signal, Clock, TrendingUp, Activity, AlertCircle } from "lucide-react";
import { motion } from "motion/react";
import {
  LineChart,
  Line,
  AreaChart,
  Area,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Legend,
} from "recharts";
import { Badge } from "./ui/badge";
import { Separator } from "./ui/separator";

interface DeviceDetailDialogProps {
  device: {
    mac: string;
    name: string;
    type: "Emisor" | "Repetidor";
    rssi: number;
    packets: number;
    lastSeen: string;
  } | null;
  onClose: () => void;
}

// Mock data para las gráficas
const rssiHistoryData = [
  { time: "10:15", rssi: -45, threshold: -70 },
  { time: "10:16", rssi: -48, threshold: -70 },
  { time: "10:17", rssi: -44, threshold: -70 },
  { time: "10:18", rssi: -50, threshold: -70 },
  { time: "10:19", rssi: -46, threshold: -70 },
  { time: "10:20", rssi: -52, threshold: -70 },
  { time: "10:21", rssi: -47, threshold: -70 },
  { time: "10:22", rssi: -45, threshold: -70 },
  { time: "10:23", rssi: -43, threshold: -70 },
];

const packetsData = [
  { time: "10:15", packets: 120 },
  { time: "10:16", packets: 145 },
  { time: "10:17", packets: 132 },
  { time: "10:18", packets: 168 },
  { time: "10:19", packets: 154 },
  { time: "10:20", packets: 178 },
  { time: "10:21", packets: 165 },
  { time: "10:22", packets: 189 },
  { time: "10:23", packets: 195 },
];

const intervalDistribution = [
  { interval: "0-100ms", count: 45 },
  { interval: "100-200ms", count: 128 },
  { interval: "200-300ms", count: 256 },
  { interval: "300-400ms", count: 89 },
  { interval: "400-500ms", count: 34 },
];

export function DeviceDetailDialog({ device, onClose }: DeviceDetailDialogProps) {
  if (!device) return null;

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="fixed inset-0 bg-black/60 z-50 flex items-end"
      onClick={onClose}
    >
      <motion.div
        initial={{ y: "100%" }}
        animate={{ y: 0 }}
        exit={{ y: "100%" }}
        transition={{ type: "spring", damping: 30, stiffness: 300 }}
        className="bg-background w-full max-w-md mx-auto rounded-t-3xl shadow-2xl max-h-[90vh] overflow-auto"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="sticky top-0 z-10 bg-card border-b border-border px-4 py-4 rounded-t-3xl">
          <div className="flex items-start justify-between mb-3">
            <div className="flex-1">
              <div className="flex items-center gap-2 mb-1">
                <h2 className="text-lg">{device.name}</h2>
                <Badge variant={device.type === "Emisor" ? "default" : "secondary"}>
                  {device.type}
                </Badge>
              </div>
              <p className="text-xs text-muted-foreground font-mono">{device.mac}</p>
            </div>
            <button
              onClick={onClose}
              className="shrink-0 w-8 h-8 rounded-full bg-muted hover:bg-muted/80 flex items-center justify-center transition-colors"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Quick Stats Grid */}
          <div className="grid grid-cols-3 gap-2">
            <div className="bg-muted/50 rounded-lg px-3 py-2">
              <div className="flex items-center gap-1.5 mb-0.5">
                <Signal className="w-3.5 h-3.5 text-accent" />
                <span className="text-xs text-muted-foreground">RSSI</span>
              </div>
              <p className="text-sm">{device.rssi} dBm</p>
            </div>
            <div className="bg-muted/50 rounded-lg px-3 py-2">
              <div className="flex items-center gap-1.5 mb-0.5">
                <Repeat className="w-3.5 h-3.5 text-accent" />
                <span className="text-xs text-muted-foreground">Paquetes</span>
              </div>
              <p className="text-sm">{device.packets}</p>
            </div>
            <div className="bg-muted/50 rounded-lg px-3 py-2">
              <div className="flex items-center gap-1.5 mb-0.5">
                <Clock className="w-3.5 h-3.5 text-accent" />
                <span className="text-xs text-muted-foreground">Última</span>
              </div>
              <p className="text-sm">{device.lastSeen}</p>
            </div>
          </div>
        </div>

        {/* Content */}
        <div className="p-4 space-y-4">
          {/* RSSI History Chart */}
          <div className="bg-card rounded-xl p-4 shadow-sm border border-border space-y-3">
            <div className="flex items-center gap-2">
              <TrendingUp className="w-4 h-4 text-accent" />
              <h3 className="text-sm">Historial de señal (RSSI)</h3>
            </div>
            <ResponsiveContainer width="100%" height={180}>
              <AreaChart data={rssiHistoryData}>
                <defs>
                  <linearGradient id="rssiGradient" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="var(--accent)" stopOpacity={0.3} />
                    <stop offset="95%" stopColor="var(--accent)" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" />
                <XAxis dataKey="time" tick={{ fontSize: 10 }} stroke="var(--muted-foreground)" />
                <YAxis tick={{ fontSize: 10 }} stroke="var(--muted-foreground)" domain={[-100, -30]} />
                <Tooltip
                  contentStyle={{
                    backgroundColor: "var(--card)",
                    border: "1px solid var(--border)",
                    borderRadius: "8px",
                    fontSize: "12px",
                  }}
                />
                <Area
                  type="monotone"
                  dataKey="rssi"
                  stroke="var(--accent)"
                  strokeWidth={2}
                  fill="url(#rssiGradient)"
                />
                <Line
                  type="monotone"
                  dataKey="threshold"
                  stroke="var(--destructive)"
                  strokeWidth={1}
                  strokeDasharray="5 5"
                  dot={false}
                />
              </AreaChart>
            </ResponsiveContainer>
            <div className="flex items-center gap-2 text-xs text-muted-foreground">
              <div className="flex items-center gap-1">
                <div className="w-3 h-0.5 bg-accent"></div>
                <span>Señal</span>
              </div>
              <div className="flex items-center gap-1">
                <div className="w-3 h-0.5 bg-destructive border-dashed"></div>
                <span>Umbral</span>
              </div>
            </div>
          </div>

          {/* Packets Chart */}
          <div className="bg-card rounded-xl p-4 shadow-sm border border-border space-y-3">
            <div className="flex items-center gap-2">
              <Activity className="w-4 h-4 text-accent" />
              <h3 className="text-sm">Paquetes recibidos</h3>
            </div>
            <ResponsiveContainer width="100%" height={180}>
              <LineChart data={packetsData}>
                <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" />
                <XAxis dataKey="time" tick={{ fontSize: 10 }} stroke="var(--muted-foreground)" />
                <YAxis tick={{ fontSize: 10 }} stroke="var(--muted-foreground)" />
                <Tooltip
                  contentStyle={{
                    backgroundColor: "var(--card)",
                    border: "1px solid var(--border)",
                    borderRadius: "8px",
                    fontSize: "12px",
                  }}
                />
                <Line
                  type="monotone"
                  dataKey="packets"
                  stroke="var(--chart-3)"
                  strokeWidth={2}
                  dot={{ fill: "var(--chart-3)", r: 3 }}
                />
              </LineChart>
            </ResponsiveContainer>
          </div>

          {/* Interval Distribution */}
          <div className="bg-card rounded-xl p-4 shadow-sm border border-border space-y-3">
            <div className="flex items-center gap-2">
              <AlertCircle className="w-4 h-4 text-accent" />
              <h3 className="text-sm">Distribución de intervalos</h3>
            </div>
            <ResponsiveContainer width="100%" height={180}>
              <BarChart data={intervalDistribution}>
                <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" />
                <XAxis dataKey="interval" tick={{ fontSize: 9 }} stroke="var(--muted-foreground)" />
                <YAxis tick={{ fontSize: 10 }} stroke="var(--muted-foreground)" />
                <Tooltip
                  contentStyle={{
                    backgroundColor: "var(--card)",
                    border: "1px solid var(--border)",
                    borderRadius: "8px",
                    fontSize: "12px",
                  }}
                />
                <Bar dataKey="count" fill="var(--accent)" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>

          {/* Statistics Summary */}
          <div className="bg-card rounded-xl p-4 shadow-sm border border-border space-y-3">
            <h3 className="text-sm">Estadísticas</h3>
            <Separator />
            <div className="space-y-2.5">
              <div className="flex justify-between items-center">
                <span className="text-xs text-muted-foreground">RSSI mínimo</span>
                <span className="text-sm">-52 dBm</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-xs text-muted-foreground">RSSI máximo</span>
                <span className="text-sm">-43 dBm</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-xs text-muted-foreground">RSSI promedio</span>
                <span className="text-sm">-46.8 dBm</span>
              </div>
              <Separator />
              <div className="flex justify-between items-center">
                <span className="text-xs text-muted-foreground">Total paquetes</span>
                <span className="text-sm">{device.packets}</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-xs text-muted-foreground">Tasa promedio</span>
                <span className="text-sm">21.6 pkt/min</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-xs text-muted-foreground">Última actividad</span>
                <span className="text-sm">{device.lastSeen}</span>
              </div>
            </div>
          </div>

          {/* Bottom padding for safe area */}
          <div className="h-4"></div>
        </div>
      </motion.div>
    </motion.div>
  );
}
