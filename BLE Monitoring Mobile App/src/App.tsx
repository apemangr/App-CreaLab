import { useState, useEffect } from "react";
import { Home, BluetoothSearching, Settings } from "lucide-react";
import { Principal } from "./components/Principal";
import { Escanear } from "./components/Escanear";
import { Configuracion } from "./components/Configuracion";
import { motion, AnimatePresence } from "motion/react";

export default function App() {
  const [activeTab, setActiveTab] = useState<"principal" | "escanear" | "configuracion">("principal");
  const [isDarkMode, setIsDarkMode] = useState(true);
  const [scanTime, setScanTime] = useState([30]);
  const [historialType, setHistorialType] = useState<"repetidor" | "emisor" | "ambos">("ambos");
  const [deviceFilter, setDeviceFilter] = useState<"ambos" | "emisor" | "repetidor">("ambos");

  useEffect(() => {
    if (isDarkMode) {
      document.documentElement.classList.add("dark");
    } else {
      document.documentElement.classList.remove("dark");
    }
  }, [isDarkMode]);

  return (
    <div className="h-screen flex flex-col bg-background max-w-md mx-auto shadow-2xl">
      {/* Main Content */}
      <AnimatePresence mode="wait">
        {activeTab === "principal" ? (
          <motion.div
            key="principal"
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: 20 }}
            transition={{ duration: 0.2 }}
            className="flex-1 flex flex-col"
          >
            <Principal 
              deviceFilter={deviceFilter}
              onDeviceFilterChange={setDeviceFilter}
            />
          </motion.div>
        ) : activeTab === "escanear" ? (
          <motion.div
            key="escanear"
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -20 }}
            transition={{ duration: 0.2 }}
            className="flex-1 flex flex-col"
          >
            <Escanear scanTime={scanTime} />
          </motion.div>
        ) : (
          <motion.div
            key="configuracion"
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -20 }}
            transition={{ duration: 0.2 }}
            className="flex-1 flex flex-col"
          >
            <Configuracion 
              isDarkMode={isDarkMode}
              onToggleDarkMode={setIsDarkMode}
              scanTime={scanTime}
              onScanTimeChange={setScanTime}
              historialType={historialType}
              onHistorialTypeChange={setHistorialType}
            />
          </motion.div>
        )}
      </AnimatePresence>

      {/* Bottom Navigation Bar */}
      <nav className="fixed bottom-0 left-0 right-0 bg-accent border-t border-accent shadow-lg z-30">
        <div className="max-w-md mx-auto flex">
          <button
            onClick={() => setActiveTab("principal")}
            className={`flex-1 flex flex-col items-center justify-center py-3 transition-colors ${
              activeTab === "principal"
                ? "text-white"
                : "text-white/60"
            }`}
          >
            <motion.div
              animate={{
                scale: activeTab === "principal" ? 1.1 : 1,
              }}
              transition={{ type: "spring", stiffness: 300 }}
            >
              <Home className="w-6 h-6 mb-1" />
            </motion.div>
            <span className="text-xs">Principal</span>
          </button>

          <button
            onClick={() => setActiveTab("escanear")}
            className={`flex-1 flex flex-col items-center justify-center py-3 transition-colors ${
              activeTab === "escanear"
                ? "text-white"
                : "text-white/60"
            }`}
          >
            <motion.div
              animate={{
                scale: activeTab === "escanear" ? 1.1 : 1,
              }}
              transition={{ type: "spring", stiffness: 300 }}
            >
              <BluetoothSearching className="w-6 h-6 mb-1" />
            </motion.div>
            <span className="text-xs">Escanear</span>
          </button>

          <button
            onClick={() => setActiveTab("configuracion")}
            className={`flex-1 flex flex-col items-center justify-center py-3 transition-colors ${
              activeTab === "configuracion"
                ? "text-white"
                : "text-white/60"
            }`}
          >
            <motion.div
              animate={{
                scale: activeTab === "configuracion" ? 1.1 : 1,
              }}
              transition={{ type: "spring", stiffness: 300 }}
            >
              <Settings className="w-6 h-6 mb-1" />
            </motion.div>
            <span className="text-xs">Configuración</span>
          </button>
        </div>
      </nav>
    </div>
  );
}
