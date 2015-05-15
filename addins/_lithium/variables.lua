--[[
	@author Lynxaa
	@game_version 1.24 - 1.0.335.2/1.0.335.3
	@patches http://patches.rockstargames.com/prod/gtav/versioning.xml

	------------------------------ LICENSE ------------------------------
	Copyright 2015 [--]

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

			http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
	------------------------------ LICENSE ------------------------------
]]--

-- TODO: Organize.
local VARS = {};

--[[
	0.4.3.1 - Changelog

	• Changed base structure, utilized LUA's require function and modularity.
	• Hopefully made Explode All function better.
	• Fixed SpeedBoost, still need to make it work while car godmode is on.
]]--
local _VER = "0.4.3.1";

-- TODO: Rename variables.
local godModeState = false;
local carGodModeState = false;
local neverWantedState = false;
local explosiveBulletsState = false;
local superRunState = false;
local speedBoostState = false;
local lsdVehicleState = false;
local superJumpState = false;
local dropCashState = false;

local fadeTimer = 0;
local lsdTimer = 0;
local lastTeleportCoords = { 0, 0, 0 };
local statusText = "";
local weaponNames = {
	"WEAPON_KNIFE", "WEAPON_NIGHTSTICK", "WEAPON_HAMMER", "WEAPON_BAT", "WEAPON_GOLFCLUB", "WEAPON_CROWBAR",
	"WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_APPISTOL", "WEAPON_PISTOL50", "WEAPON_MICROSMG", "WEAPON_SMG",
	"WEAPON_ASSAULTSMG", "WEAPON_ASSAULTRIFLE", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE", "WEAPON_MG",
	"WEAPON_COMBATMG", "WEAPON_PUMPSHOTGUN", "WEAPON_SAWNOFFSHOTGUN", "WEAPON_ASSAULTSHOTGUN", "WEAPON_BULLPUPSHOTGUN",
	"WEAPON_STUNGUN", "WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER", "WEAPON_GRENADELAUNCHER", "WEAPON_GRENADELAUNCHER_SMOKE",
	"WEAPON_RPG", "WEAPON_MINIGUN", "WEAPON_GRENADE", "WEAPON_STICKYBOMB", "WEAPON_SMOKEGRENADE", "WEAPON_BZGAS",
	"WEAPON_MOLOTOV", "WEAPON_FIREEXTINGUISHER", "WEAPON_PETROLCAN", "WEAPON_SNSPISTOL", "WEAPON_SPECIALCARBINE",
	"WEAPON_HEAVYPISTOL", "WEAPON_BULLPUPRIFLE", "WEAPON_HOMINGLAUNCHER", "WEAPON_PROXMINE", "WEAPON_SNOWBALL",
	"WEAPON_VINTAGEPISTOL", "WEAPON_DAGGER", "WEAPON_FIREWORK", "WEAPON_MUSKET", "WEAPON_MARKSMANRIFLE", "WEAPON_HEAVYSHOTGUN",
	"WEAPON_GUSENBERG", "WEAPON_HATCHET", "WEAPON_RAILGUN"
};


VARS.godModeState = godModeState;
VARS.carGodModeState = carGodModeState;
VARS.neverWantedState = neverWantedState;
VARS.explosiveBulletsState = explosiveBulletsState;
VARS.superJumpState = superJumpState;
VARS.superRunState = superRunState;
VARS.speedBoostState = speedBoostState;
VARS.lsdVehicleState = lsdVehicleState;
VARS.dropCashState = dropCashState;

VARS._VER = _VER;
VARS.fadeTimer = fadeTimer;
VARS.lsdTimer = lsdTimer;
VARS.lastTeleportCoords = lastTeleportCoords;
VARS.statusText = statusText;
VARS.weaponNames = weaponNames;
VARS.LITHIUM_GUI = nil;

return VARS;
