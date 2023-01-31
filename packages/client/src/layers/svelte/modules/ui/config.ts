// Components
import UIDebugLog from "../../lib/components/UIDebug/UIDebugLog.svelte";
import UIDebugMap from "../../lib/components/UIDebug/UIDebugMap.svelte";
import UI3DMap from "../../lib/components/UI3D/UI3DMap.svelte";

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
  "debug-log": initialise({
    id: "debug-log",
    title: "Debug Log",
    component: UIDebugLog,
    active: true,
    options: {
      persistent: true,
      fluid: true,
      layer: 2,
      delay: 0,
    },
    hidden: false,
    grid: {
      col: [3, 4],
      row: [1, 10],
    },
  }),
  "debug-map": initialise({
    id: "debug-map",
    title: "Debug Map",
    component: UIDebugMap,
    active: true,
    options: {
      persistent: true,
      fluid: true,
      layer: 2,
      delay: 0,
    },
    hidden: false,
    grid: {
      col: [1, 3],
      row: [1, 10],
    },
  }),
  "3d-map": initialise({
    id: "3d-map",
    title: "Ortho Map",
    component: UI3DMap,
    active: true,
    options: {
      persistent: false,
      fluid: true,
      layer: 3,
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

const makeDelay = () => Math.floor(Math.random() * 200);

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
