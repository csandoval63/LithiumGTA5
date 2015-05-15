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

local FUNCS = {};
local VARS = require("_lithium.variables");

function draw(text, x, y, scale)
	if (VARS.LITHIUM_GUI ~= nil) then
		VARS.LITHIUM_GUI.drawTextScaleXY(text, x, y, scale);
	end
end

function updateStatus(newStatus)
	VARS.statusText = newStatus;
	VARS.fadeTimer = GAMEPLAY.GET_GAME_TIMER();
end

function updateModStatus(name, state)
	updateStatus(name .. " " .. (state and "Enabled" or "Disabled"));
end

function explodeAll()
	local player = PLAYER.PLAYER_ID();
	local playerPed = PLAYER.PLAYER_PED_ID();
	local bPlayerExists = ENTITY.DOES_ENTITY_EXIST(playerPed);
	local radius = 10;
	local explosionType = 4;
	local explosionRadius = 100; -- This seems to be very limited and or not working.
	local isAudible = false;
	local isVisible = true;
	local cameraShake = 0;

	if (bPlayerExists) then
		local playerCount = PLAYER.GET_NUMBER_OF_PLAYERS();
		if (playerCount > 1) then
			updateStatus("Exploding All Players!");

			for i = 0, playerCount - 1, 1 do
				local iCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(i), false);
				local iCoordsX = math.floor(iCoords.x);
				local iCoordsY = math.floor(iCoords.y);
				local iCoordsZ = math.floor(iCoords.z);

				if (playerPed ~= PLAYER.GET_PLAYER_PED(i)) then
					FIRE.ADD_EXPLOSION(iCoords.x, iCoords.y, iCoords.z, explosionsType, explosionRadius, isAudible, isVisible, cameraShake);

					-- TODO: Make sure explosions kill all players regardless of their movement speeds.
					for i = 1, radius do
						FIRE.ADD_EXPLOSION(iCoords.x + i, iCoords.y + radius, iCoords.z + radius, explosionsType, explosionRadius, isAudible, isVisible, cameraShake);
						FIRE.ADD_EXPLOSION(iCoords.x - i, iCoords.y - radius, iCoords.z - radius, explosionsType, explosionRadius, isAudible, isVisible, cameraShake);
					end
				end
			end
		else
			updateStatus("Not enough players in lobby")
		end
	end
end

function clearReports()
	updateStatus("Featured Removed. Don't Abuse Online Play ;~)");
end

function godMode()
	if VARS.godModeState == false then
		VARS.godModeState = true
	else
		VARS.godModeState = false
	end

	updateModStatus("God Mode", VARS.godModeState)
end

function carGodMode()
	if VARS.carGodModeState == false then
		VARS.carGodModeState = true
	else
		VARS.carGodModeState = false
	end

	updateModStatus("Vehicle God Mode", VARS.carGodModeState)
end

function neverWanted()
	if VARS.neverWantedState == false then
		VARS.neverWantedState = true
	else
		VARS.neverWantedState = false
	end

	updateModStatus("Never Wanted", VARS.neverWantedState)
end

function giveAllWeapons()
	local index = 0
	for k, v in pairs(VARS.weaponNames) do
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(PLAYER.PLAYER_PED_ID(), GAMEPLAY.GET_HASH_KEY(VARS.weaponNames[index]), 9999, false);
		index = index + 1
	end

	updateStatus("All weapons applied!");
end

function explosiveBullets()
	if VARS.explosiveBulletsState == false then
		VARS.explosiveBulletsState = true
	else
		VARS.explosiveBulletsState = false
	end

	updateModStatus("Explosive Bullets", VARS.explosiveBulletsState)
end

function superRun()
	if VARS.superRunState == false then
		VARS.superRunState = true
	else
		VARS.superRunState = false
		PLAYER._SET_MOVE_SPEED_MULTIPLIER(PLAYER.PLAYER_ID(), 1);
	end

	updateModStatus("Super Run", VARS.superRunState)
end

function speedBoost()
	if VARS.speedBoostState == false then
		VARS.speedBoostState = true
	else
		VARS.speedBoostState = false
	end

	updateModStatus("Speed Boost (Vehicle)", VARS.speedBoostState)
end

function lsdVehicle()
	if VARS.lsdVehicleState == false then
		VARS.lsdVehicleState = true
		VARS.lsdTimer = GAMEPLAY.GET_GAME_TIMER();
	else
		VARS.lsdVehicleState = false
	end

	updateModStatus("LSD Vehicle", VARS.lsdVehicleState)
end

function teleportMarker()
	local entity = PLAYER.PLAYER_PED_ID();

	if (PED.IS_PED_IN_ANY_VEHICLE(entity, false)) then
		entity = PED.GET_VEHICLE_PED_IS_USING(entity);
	end

	local iterator = UI.GET_FIRST_BLIP_INFO_ID(UI._GET_BLIP_INFO_ID_ITERATOR());
	local coords = UI.GET_BLIP_INFO_ID_COORD(iterator)
	if (UI.DOES_BLIP_EXIST(iterator)) then
		coords = UI.GET_BLIP_INFO_ID_COORD(iterator)
		local heightArray = { 100.0, 150.0, 50.0, 0.0, 200.0, 250.0, 300.0, 350.0, 400.0, 450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0 }
		for i, height in ipairs(heightArray) do
			ENTITY.SET_ENTITY_COORDS_NO_OFFSET(entity, coords.x, coords.y, heightArray[i], false, false, true)
			VARS.lastTeleportCoords[0] = coords.x;
			VARS.lastTeleportCoords[1] = coords.y;
			VARS.lastTeleportCoords[2] = height + 1.0;
			wait(100)
			local height = select(2, GAMEPLAY.GET_GROUND_Z_FOR_3D_COORD(coords.x, coords.y, heightArray[i], coords.z))
			if (height > 0) then
				ENTITY.SET_ENTITY_COORDS_NO_OFFSET(entity, coords.x, coords.y, height + 1.0, false, false, true)
				VARS.lastTeleportCoords[0] = coords.x;
				VARS.lastTeleportCoords[1] = coords.y;
				VARS.lastTeleportCoords[2] = height + 1.0;
			break
		end
	end
	else
		if (VARS.lastTeleportCoords[0] ~= 0 and VARS.lastTeleportCoords[1] ~= 0) then
			ENTITY.SET_ENTITY_COORDS_NO_OFFSET(entity, VARS.lastTeleportCoords[0], VARS.lastTeleportCoords[1], VARS.lastTeleportCoords[2], false, false, true)
			updateStatus("Teleported to last saved location");
		else
			updateStatus("No marker found to teleport to");
		end
	end
end

function superJump()
	if VARS.superJumpState == false then
		VARS.superJumpState = true
	else
		VARS.superJumpState = false
	end

	updateModStatus("Super Jump", VARS.superJumpState)
end

function teleportUp()
	local entity = PLAYER.PLAYER_PED_ID();

	if (PED.IS_PED_IN_ANY_VEHICLE(entity, false)) then
		entity = PED.GET_VEHICLE_PED_IS_USING(entity);
	end

	local coords = ENTITY.GET_ENTITY_COORDS(entity, false);
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(entity, coords.x, coords.y, coords.z + 5, false, false, true);
end

function cashDrop()
	if VARS.dropCashState == false then
		VARS.dropCashState = true
	else
		VARS.dropCashState = false
	end

	updateModStatus("Drop Cash", VARS.dropCash)
end

function update()
	local player = PLAYER.PLAYER_ID();
	local playerPed = PLAYER.PLAYER_PED_ID();
	local bPlayerExists = ENTITY.DOES_ENTITY_EXIST(playerPed);
	local playerCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), false);
	local coordRoundX = math.floor(playerCoords.x);
	local coordRoundY = math.floor(playerCoords.y);
	local coordRoundZ = math.floor(playerCoords.z);

	if (VARS.godModeState) then
		PLAYER.SET_PLAYER_INVINCIBLE(PLAYER.PLAYER_ID(), true)
	else
		if (PLAYER.GET_PLAYER_INVINCIBLE(PLAYER.PLAYER_ID())) then
			PLAYER.SET_PLAYER_INVINCIBLE(PLAYER.PLAYER_ID(), false)
		end
	end

	if (VARS.carGodModeState) then
		local veh = PED.GET_VEHICLE_PED_IS_USING(playerPed);
		ENTITY.SET_ENTITY_INVINCIBLE(veh, true);
		ENTITY.SET_ENTITY_PROOFS(veh, true, true, true, true, true, true, true, true);
		VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(veh, false);
		VEHICLE.SET_VEHICLE_WHEELS_CAN_BREAK(veh, false);
		VEHICLE.SET_VEHICLE_CAN_BE_VISIBLY_DAMAGED(veh, false);
		VEHICLE.SET_VEHICLE_FIXED(veh);
	end

	if (VARS.neverWantedState) then
		PLAYER.CLEAR_PLAYER_WANTED_LEVEL(player);
	end

	if (VARS.explosiveBulletsState) then
		GAMEPLAY.SET_EXPLOSIVE_AMMO_THIS_FRAME(player);
	end

	if (VARS.superRunState) then
		PLAYER._SET_MOVE_SPEED_MULTIPLIER(player, 1.49);
	end

	if (VARS.superJumpState) then
		if (bPlayerExists) then
			GAMEPLAY.SET_SUPER_JUMP_THIS_FRAME(player);
		end
	end

	if (VARS.speedBoostState) then
		if (PED.IS_PED_IN_ANY_VEHICLE(playerPed, false)) then
			local veh = PED.GET_VEHICLE_PED_IS_USING(playerPed);
			local speed = ENTITY.GET_ENTITY_SPEED(veh);
			draw("Boost: F1", 0, 0, 0.35);
			draw("MP/H: " .. tostring(math.floor(speed)), 0, 0.0225, 0.35);

			if (get_key_pressed(Keys.F1)) then
				VEHICLE.SET_VEHICLE_FORWARD_SPEED(veh, speed * 1.05);
			end
		end
	end

	if (VARS.lsdVehicleState) then
		if ((GAMEPLAY.GET_GAME_TIMER() - VARS.lsdTimer) > 5) then
			local veh = PED.GET_VEHICLE_PED_IS_USING(playerPed);
			VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(veh, math.random(255) % 255, math.random(255) % 255, math.random(255) % 255);
			if (VEHICLE._DOES_VEHICLE_HAVE_SECONDARY_COLOUR(veh)) then
				VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(veh, math.random(255) % 255, math.random(255) % 255, math.random(255) % 255);
			end

			VARS.lsdTimer = GAMEPLAY.GET_GAME_TIMER();
		end
	end

	if (VARS.dropCashState) then
		-- TODO: 40K Job Pickups
		OBJECT.CREATE_AMBIENT_PICKUP(GAMEPLAY.GET_HASH_KEY("PICKUP_MONEY_MED_BAG"), playerCoords.x, playerCoords.y, playerCoords.z + 2, 0, 40000, 0, false, true);
	end
end

FUNCS.updateStatus = updateStatus;
FUNCS.updateModStatus = updateModStatus;
FUNCS.explodeAll = explodeAll;
FUNCS.clearReports = clearReports;
FUNCS.godMode = godMode;
FUNCS.carGodMode = carGodMode;
FUNCS.neverWanted = neverWanted;
FUNCS.giveAllWeapons = giveAllWeapons;
FUNCS.explosiveBullets = explosiveBullets;
FUNCS.superRun = superRun;
FUNCS.speedBoost = speedBoost;
FUNCS.lsdVehicle = lsdVehicle;
FUNCS.teleportMarker = teleportMarker;
FUNCS.superJump = superJump;
FUNCS.teleportUp = teleportUp;
FUNCS.cashDrop = cashDrop;
FUNCS.update = update;

return FUNCS;
