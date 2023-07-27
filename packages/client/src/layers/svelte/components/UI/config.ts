// Components
import UIDebugLog from "../DebugLog/DebugLog.svelte";
import UIDebugStats from "../Stats/Stats.svelte";
import UIDebugMap from "../Map/Map.svelte";
import UIGameConfig from "../GameConfig/GameConfig.svelte";
import UITransactions from "../ActionSequencer/ActionSequencer.svelte";

// --- TYPES -----------------------------------------------------------------

export type UIComponentOptions = {
  delay?: number;
  fluid?: boolean;
  bare?: boolean;
  hidden?: boolean;
  persistent?: boolean;
  muted?: boolean;
  layer?: number;
  noscroll?: boolean;
  span?: boolean;
  center?: boolean;
  background?: string;
};

export type UIComponentPlacement = {
  row?: [number, number]; // row start
  col?: [number, number]; // row end
};

export type UIComponentDefinition = {
  active: boolean;
  id: string;
  title: string;
  component: any;
  options?: UIComponentOptions;
  grid?: UIComponentPlacement;
  hidden: boolean;
};

// --- CONSTANTS -----------------------------------------------------------------

export const initialState = () => ({
  stats: initialise({
    id: "stats",
    title: "Stats",
    component: UIDebugStats,
    active: true,
    options: {
      fluid: true,
      layer: 2,
      delay: 0,
    },
    hidden: false,
    grid: {
      col: [3, 4],
      row: [1, 6],
    },
  }),
  "game-config": initialise({
    id: "game-config",
    title: "Game Config",
    component: UIGameConfig,
    active: false,
    options: {
      fluid: true,
      layer: 2,
      delay: 0,
    },
    hidden: false,
    grid: {
      col: [3, 4],
      row: [6, 10],
    },
  }),
  transactions: initialise({
    id: "transactions",
    title: "Transactions",
    component: UITransactions,
    active: true,
    options: {
      fluid: true,
      layer: 2,
      delay: 0,
    },
    hidden: false,
    grid: {
      col: [3, 4],
      row: [6, 10],
    },
  }),
  "debug-log": initialise({
    id: "debug-log",
    title: "Debug Log",
    component: UIDebugLog,
    active: false,
    options: {
      fluid: true,
      layer: 2,
      delay: 0,
    },
    hidden: false,
    grid: {
      col: [4, 5],
      row: [1, 10],
    },
  }),
  map: initialise({
    id: "map",
    title: "Map",
    component: UIDebugMap,
    active: true,
    options: {
      persistent: true,
      fluid: true,
      layer: 0,
      delay: 0,
    },
    hidden: false,
    grid: {
      col: [1, 3],
      row: [1, 10],
    },
  }),
});

// --- FUNCTIONS -----------------------------------------------------------------

// Start
export const initialise = (def: UIComponentDefinition) => {
  return {
    id: def.id,
    active: def.active,
    title: def.title,
    component: def.component,
    options: def?.options,
    grid: def?.grid,
    hidden: def.hidden,
  };
};
