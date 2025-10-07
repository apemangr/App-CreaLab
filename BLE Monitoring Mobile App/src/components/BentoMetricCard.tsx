import { motion } from "motion/react";
import { LucideIcon } from "lucide-react";

interface BentoMetricCardProps {
  icon: LucideIcon;
  label: string;
  value: string | number;
  unit?: string;
  color?: "cyan" | "purple" | "green" | "orange";
}

const colorStyles = {
  cyan: {
    gradient: "bg-gradient-to-br from-cyan-500/10 to-blue-500/5 dark:from-cyan-500/20 dark:to-blue-500/10",
    iconBg: "bg-cyan-500/10 dark:bg-cyan-500/20",
    iconColor: "text-cyan-600 dark:text-cyan-400",
    border: "border-cyan-500/20 dark:border-cyan-500/30",
  },
  purple: {
    gradient: "bg-gradient-to-br from-purple-500/10 to-pink-500/5 dark:from-purple-500/20 dark:to-pink-500/10",
    iconBg: "bg-purple-500/10 dark:bg-purple-500/20",
    iconColor: "text-purple-600 dark:text-purple-400",
    border: "border-purple-500/20 dark:border-purple-500/30",
  },
  green: {
    gradient: "bg-gradient-to-br from-green-500/10 to-emerald-500/5 dark:from-green-500/20 dark:to-emerald-500/10",
    iconBg: "bg-green-500/10 dark:bg-green-500/20",
    iconColor: "text-green-600 dark:text-green-400",
    border: "border-green-500/20 dark:border-green-500/30",
  },
  orange: {
    gradient: "bg-gradient-to-br from-orange-500/10 to-amber-500/5 dark:from-orange-500/20 dark:to-amber-500/10",
    iconBg: "bg-orange-500/10 dark:bg-orange-500/20",
    iconColor: "text-orange-600 dark:text-orange-400",
    border: "border-orange-500/20 dark:border-orange-500/30",
  },
};

export function BentoMetricCard({ icon: Icon, label, value, unit, color = "cyan" }: BentoMetricCardProps) {
  const styles = colorStyles[color];
  
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      className={`${styles.gradient} rounded-xl p-4 shadow-md border ${styles.border} hover:shadow-lg transition-all hover:scale-[1.02]`}
    >
      <div className="flex items-start justify-between mb-2">
        <div className={`${styles.iconBg} rounded-lg p-2`}>
          <Icon className={`w-5 h-5 ${styles.iconColor}`} />
        </div>
      </div>
      <div className="space-y-1">
        <p className="text-muted-foreground text-xs">{label}</p>
        <div className="flex items-baseline gap-1">
          <span className="text-2xl font-semibold text-foreground">{value}</span>
          {unit && <span className="text-sm text-muted-foreground">{unit}</span>}
        </div>
      </div>
    </motion.div>
  );
}
