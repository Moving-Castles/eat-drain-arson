// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

// --- SPAWN
int32 constant WORLD_HEIGHT = 10;
int32 constant WORLD_WIDTH = 10;
uint32 constant INITIAL_ENERGY = 100;
uint32 constant DEFAULT_CARRYING_CAPACITY = 10;
uint32 constant STEP_COST = 10;
uint32 constant EXTRACT_COST = 10;
uint32 constant TRANSFER_COST = 10;
uint32 constant MATTER_PER_TILE = 100;
// --- ENERGY
uint32 constant RESOURCE_TO_ENERGY_CONVERSION_RATE = 5;
// --- FIRE
uint32 constant MINIMUM_FIRE_SIZE = 500;
uint32 constant FIRE_BURNTIME_MULTIPLIER = 10;
uint32 constant COST_TO_MAKE_FIRE = 50;
// --- MOVE
// --- PLAY
uint32 constant PLAYING_DURATION = 20;
// --- COOLDOWN
uint32 constant GENERIC_ACTION_COOLDOWN = 10;
