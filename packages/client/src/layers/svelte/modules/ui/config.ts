// Components
import UIDebugLog from "../../lib/components/UIDebug/UIDebugLog.svelte";
import UIDebugStats from "../../lib/components/UIDebug/UIDebugStats.svelte";
import UIDebugInspector from "../../lib/components/UIDebug/UIDebugInspector.svelte";
import UIDebugMap from "../../lib/components/UIDebug/UIDebugMap.svelte";
import UI3DMap from "../../lib/components/UI3D/UI3DMap.svelte";
import UI3DAvatar from "../../lib/components/UI3D/UI3DAvatar.svelte";

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
  "debug-stats": initialise({
    id: "debug-stats",
    title: "Debug Stats",
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
  "debug-inspector": initialise({
    id: "debug-inspector",
    title: "Debug Inspector",
    component: UIDebugInspector,
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
  "debug-map": initialise({
    id: "debug-map",
    title: "Debug Map",
    component: UIDebugMap,
    active: true,
    options: {
      persistent: true,
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
  // "3d-map": initialise({
  //   id: "3d-map",
  //   title: "Ortho Map",
  //   component: UI3DMap,
  //   active: true,
  //   options: {
  //     persistent: false,
  //     fluid: true,
  //     layer: 3,
  //     delay: 0,
  //   },
  //   hidden: false,
  //   grid: {
  //     col: [1, 3],
  //     row: [1, 10],
  //   },
  // }),
  // you: initialise({
  //   id: "you",
  //   title: "You",
  //   component: UI3DAvatar,
  //   active: false,
  //   options: {
  //     persistent: false,
  //     fluid: true,
  //     layer: 4,
  //     delay: 0,
  //   },
  //   hidden: false,
  //   grid: {
  //     col: [1, 3],
  //     row: [1, 10],
  //   },
  // }),
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
