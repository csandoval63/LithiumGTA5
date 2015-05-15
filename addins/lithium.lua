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

--	TODO:
-- Sort functions into separate folder and load dynamically.
-- Fix explosions being spawned at incorrect locations, [X:0 Y:0 Z:0] // 0.2.8 fixed this?

local lithium = {}
local vars = require("_lithium.variables");
local functions = require("_lithium.functions");

function lithium.unload()

end

-- TODO: Cleanup, Sort Into Menu Items, Add Multiple Menus, etc.
function lithium.init()
	lithium.GUI = Libs["GUI"]
	lithium.GUI.addButton("Explode All", functions.explodeAll, 0, 0.0, 0.0025, 0);
	lithium.GUI.addButton("God Mode", functions.godMode, 0, 0.0, 0.0025, 0);
	lithium.GUI.addButton("God Mode (Vehicle)", functions.carGodMode, 0, 0, 0.1, 0);
	lithium.GUI.addButton("Never Wanted", functions.neverWanted, 0, 0, 0.1, 0);
	lithium.GUI.addButton("Give All Weapons", functions.giveAllWeapons, 0, 0, 0.1, 0);
	lithium.GUI.addButton("Speed Boost (Vehicle)", functions.speedBoost, 0, 0, 0.1, 0);
	lithium.GUI.addButton("LSD Vehicle", functions.lsdVehicle, 0, 0, 0.1, 0);
	lithium.GUI.addButton("Explosive Bullets", functions.explosiveBullets, 0, 0, 0.1, 0);
	lithium.GUI.addButton("Super Run", functions.superRun, 0, 0, 0.1, 0);
	lithium.GUI.addButton("Super Jump", functions.superJump, 0, 0, 0.1, 0);
	lithium.GUI.addButton("Teleport To Marker", functions.teleportMarker, 0, 0, 0.1, 0);
	lithium.GUI.addButton("Teleport Up", functions.teleportUp, 0, 0, 0.1, 0);
	lithium.GUI.addButton("Drop Cash", functions.cashDrop, 0, 0, 0.1, 0);
	lithium.GUI.addButton("Clear Reports", functions.clearReports, 0, 0, 0.1, 0);
	vars.LITHIUM_GUI = lithium.GUI;
end

function lithium.tick()
	lithium.GUI.drawTextRGB("Lithium v" .. vars._VER, 0.0125, 0, 182, 242);

	if ((GAMEPLAY.GET_GAME_TIMER() - vars.fadeTimer) < 2500) then
		lithium.GUI.drawTextScale(vars.statusText, 0.8, 0.40);
	end

	lithium.GUI.tick()
	functions.update()
end

return lithium
