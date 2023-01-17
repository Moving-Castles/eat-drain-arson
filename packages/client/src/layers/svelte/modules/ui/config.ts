// Components
import UITextLog from "../../lib/components/UITextLog.svelte";
import UIAvatar from "../../lib/components/UIAvatar/UIAvatar.svelte";
import UIView from "../../lib/components/UIView.svelte";
import UIDebugLog from "../../lib/components/UIDebugLog.svelte";
import UILeaderBoard from "../../lib/components/UILeaderBoards/UILeaderBoard.svelte";
import UISurvivalLeaderBoard from "../../lib/components/UILeaderBoards/UISurvivalLeaderBoard.svelte";
import UIFires from "../../lib/components/UIFires/UIFires.svelte";
import UIPlanner from "../../lib/components/UIOperationsEditor/UIPlanner.svelte";
import UIExecutor from "../../lib/components/UIOperationsEditor/UIExecutor.svelte";
import UIGridMap from "../../lib/components/UIGridMap/UIGridMap.svelte";

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
  // AVATAR
  avatar: initialise({
    id: "avatar",
    title: "Avatar",
    component: UIAvatar,
    active: false,
    grid: {
      col: [3, 4],
      row: [1, 6],
    },
    hidden: true,
    options: {
      bare: true,
      persistent: true,
      layer: 1,
      fluid: true,
      noscroll: true,
      span: true,
    },
    hidden: false,
  }),
  // OPS PLANNER
  compulsions: initialise({
    id: "compulsions",
    title: "Compulsions",
    component: UIPlanner,
    active: false,
    options: {
      fluid: true,
      layer: 10,
    },
    hidden: true,
    grid: {
      col: [1, 4],
      row: [1, 10],
    },
    hidden: false,
  }),
  // TEXT LOG
  memory: initialise({
    id: "memory",
    title: "Memory",
    component: UITextLog,
    active: false,
    options: {
      fluid: true,
      delay: makeDelay(),
      muted: false,
    },
    hidden: true,
    grid: {
      row: [1, 10],
      col: [1, 2],
    },
  }),
  // FIRES
  fires: initialise({
    id: "fires",
    title: "Fires",
    component: UIFires,
    active: false,
    options: {
      fluid: true,
      layer: 5,
    },
    hidden: true,
    grid: {
      col: [2, 3],
      row: [6, 10],
    },
  }),
  "debug-log": initialise({
    id: "debug-log",
    title: "Debug Log",
    component: UIDebugLog,
    active: true,
    options: {
      fluid: true,
      layer: 2,
      delay: 0,
    },
    hidden: false,
    grid: {
      col: [3, 4],
      row: [5, 10],
    },
  }),
  // LEADERBOARD
  leaderboard: initialise({
    id: "leaderboard",
    title: "Leaderboard",
    component: UILeaderBoard,
    active: false,
    options: {
      fluid: true,
      delay: makeDelay(),
      layer: 2,
    },
    grid: {
      col: [1, 2],
      row: [6, 10],
    },
    hidden: true,
  }),
  // SURVIVAL
  survival: initialise({
    id: "survival",
    title: "Survival",
    component: UISurvivalLeaderBoard,
    active: false,
    options: {
      fluid: true,
      delay: makeDelay(),
      layer: 2,
    },
    grid: {
      col: [1, 2],
      row: [6, 10],
    },
    hidden: true,
  }),
  //
  executor: initialise({
    id: "executor",
    title: "Compulsions",
    component: UIExecutor,
    active: false,
    options: {
      muted: false,
      persistent: true,
      fluid: true,
      delay: makeDelay(),
    },
    grid: {
      col: [3, 4],
      row: [6, 10],
    },
    hidden: true,
  }),
  //
  miniMap: initialise({
    id: "minimap",
    title: "Map",
    component: UIGridMap,
    active: false,
    options: {
      muted: false,
      persistent: false,
      fluid: true,
      delay: makeDelay(),
      background: "#000",
    },
    grid: {
      col: [3, 4],
      row: [6, 10],
    },
    hidden: true,
  }),
  //
  view: initialise({
    id: "view",
    title: "View",
    component: UIView,
    active: false,
    options: {
      fluid: true,
      delay: makeDelay(),
    },
    grid: {
      col: [3, 4],
      row: [1, 5],
    },
    hidden: true,
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
