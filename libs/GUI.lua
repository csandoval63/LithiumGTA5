local GUI = {};
GUI.GUI = {};
GUI.buttonCount = 0;
GUI.loaded = false;
GUI.selection = 0;
GUI.time = 0;
GUI.show = true;
GUI.maxHeight = 0;
GUI.offsetX = 0;
GUI.offsetY = 0;

function GUI.addButton(name, func, xmin, xmax, ymin, ymax)
	print("Added Button " .. name )
	GUI.GUI[GUI.buttonCount + 1] = {};
	GUI.GUI[GUI.buttonCount + 1]["name"] = name;
	GUI.GUI[GUI.buttonCount + 1]["func"] = func;
	GUI.GUI[GUI.buttonCount + 1]["active"] = false;
	GUI.GUI[GUI.buttonCount + 1]["xmin"] = xmin;
	GUI.GUI[GUI.buttonCount + 1]["ymin"] = 0.0175 * (GUI.buttonCount + 0.01) +0.02;
	GUI.GUI[GUI.buttonCount + 1]["xmax"] = xmax ;
	GUI.GUI[GUI.buttonCount + 1]["ymax"] = ymax ;
	GUI.buttonCount = GUI.buttonCount + 1;
end

--[[
	Drawing Functions.
]]--

function GUI.drawTextRGB(text, height, r, g, b)
	UI.SET_TEXT_FONT(0);
	UI.SET_TEXT_SCALE(0.55, 0.55);
	UI.SET_TEXT_COLOUR(r, g, b, 255);
	UI.SET_TEXT_WRAP(0.0, 1.0);
	UI.SET_TEXT_CENTRE(true);
	UI.SET_TEXT_DROPSHADOW(1, 0, 0, 0, 205);
	UI.SET_TEXT_EDGE(1, 0, 0, 0, 205);
	UI._SET_TEXT_ENTRY("STRING");
	UI._ADD_TEXT_COMPONENT_STRING(text);
	UI._DRAW_TEXT(0.5, height);
end

function GUI.drawTextRGBScale(text, height, scale, r, g, b)
	UI.SET_TEXT_FONT(0);
	UI.SET_TEXT_SCALE(scale, scale);
	UI.SET_TEXT_COLOUR(r, g, b, 255);
	UI.SET_TEXT_WRAP(0.0, 1.0);
	UI.SET_TEXT_CENTRE(true);
	UI.SET_TEXT_DROPSHADOW(1, 0, 0, 0, 205);
	UI.SET_TEXT_EDGE(1, 0, 0, 0, 205);
	UI._SET_TEXT_ENTRY("STRING");
	UI._ADD_TEXT_COMPONENT_STRING(text);
	UI._DRAW_TEXT(0.5, height);
end

function GUI.drawText(text, height)
	UI.SET_TEXT_FONT(0);
	UI.SET_TEXT_SCALE(0.55, 0.55);
	UI.SET_TEXT_COLOUR(255, 255, 255, 255);
	UI.SET_TEXT_WRAP(0.0, 1.0);
	UI.SET_TEXT_CENTRE(false);
	UI.SET_TEXT_DROPSHADOW(1, 0, 0, 0, 205);
	UI.SET_TEXT_EDGE(1, 0, 0, 0, 205);
	UI._SET_TEXT_ENTRY("STRING");
	UI._ADD_TEXT_COMPONENT_STRING(text);
	UI._DRAW_TEXT(0.5, height);
end

function GUI.drawTextScaleXY(text, x, y, scale)
	UI.SET_TEXT_FONT(0);
	UI.SET_TEXT_SCALE(scale, scale);
	UI.SET_TEXT_COLOUR(255, 255, 255, 255);
	UI.SET_TEXT_WRAP(0.0, 1.0);
	UI.SET_TEXT_CENTRE(false);
	UI.SET_TEXT_DROPSHADOW(1, 0, 0, 0, 205);
	UI.SET_TEXT_EDGE(1, 0, 0, 0, 205);
	UI._SET_TEXT_ENTRY("STRING");
	UI._ADD_TEXT_COMPONENT_STRING(text);
	UI._DRAW_TEXT(x, y);
end

function GUI.drawTextScale(text, height, scale)
	UI.SET_TEXT_FONT(0);
	UI.SET_TEXT_SCALE(scale, scale);
	UI.SET_TEXT_COLOUR(255, 255, 255, 255);
	UI.SET_TEXT_WRAP(0.0, 1.0);
	UI.SET_TEXT_CENTRE(true);
	UI.SET_TEXT_DROPSHADOW(1, 0, 0, 0, 205);
	UI.SET_TEXT_EDGE(1, 0, 0, 0, 205);
	UI._SET_TEXT_ENTRY("STRING");
	UI._ADD_TEXT_COMPONENT_STRING(text);
	UI._DRAW_TEXT(0.5, height);
end

function GUI.unload()
end

function GUI.init()
	GUI.loaded = true
end

function GUI.tick()
	if( GUI.time == 0) then
		GUI.time = GAMEPLAY.GET_GAME_TIMER()
	end
	if((GAMEPLAY.GET_GAME_TIMER() - GUI.time)> 100) then
		GUI.updateSelection()
	end
	GUI.renderGUI()
	if(not GUI.loaded ) then
		GUI.init()
	end
end

function GUI.updateSelection()
	if(get_key_pressed(Keys.NumPad2)) then
		if (GUI.show == true) then
			if(GUI.selection < GUI.buttonCount - 1)then
				AUDIO.PLAY_SOUND_FRONTEND(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", false);
				GUI.selection = GUI.selection + 1
				GUI.time = 0
			end
		end
	elseif (get_key_pressed(Keys.NumPad8) )then
		if (GUI.show == true) then
			if (GUI.selection > 0) then
				AUDIO.PLAY_SOUND_FRONTEND(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", false);
				GUI.selection = GUI.selection -1
				GUI.time = 0
			end
		end
	elseif (get_key_pressed(Keys.NumPad5)) then
		if (GUI.show == true) then
			if(type(GUI.GUI[GUI.selection +1]["func"]) == "function") then
				AUDIO.PLAY_SOUND_FRONTEND(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", false);
				GUI.GUI[GUI.selection +1]["func"]()
			else
				print(type(GUI.GUI[GUI.selection]["func"]))
			end
			GUI.time = 0
		end
	elseif (get_key_pressed(Keys.NumPad0)) then
		AUDIO.PLAY_SOUND_FRONTEND(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", false);
		if (GUI.show == true) then
			GUI.show = false
		else
			GUI.show = true
		end
		GUI.time = 0
	end
	local iterator = 0
	for id, settings in ipairs(GUI.GUI) do
		GUI.GUI[id]["active"] = false
		if(iterator == GUI.selection ) then
			GUI.GUI[iterator + 1]["active"] = true
		end
		iterator = iterator + 1
	end
end

function GUI.renderGUI()
	if (GUI.show == true) then
		GUI.renderButtons()
	end
end

function GUI.renderBox(xMin,xMax,yMin,yMax,color1,color2,color3,color4)
	GRAPHICS.DRAW_RECT(xMin, yMin,xMax, yMax, color1, color2, color3, color4);
end

function GUI.renderButtons()
	for id, settings in pairs(GUI.GUI) do
		boxColor = { 255, 255, 255, 255 }
		if (settings["active"]) then
			boxColor = { 141, 245, 247, 255 }
		end

		UI.SET_TEXT_FONT(0)
		UI.SET_TEXT_SCALE(0.0, 0.30)
		UI.SET_TEXT_COLOUR(boxColor[1], boxColor[2], boxColor[3], boxColor[4])
		UI.SET_TEXT_CENTRE(true)
		UI.SET_TEXT_DROPSHADOW(1, 1, 1, 1, 1)
		UI.SET_TEXT_EDGE(1, 1, 1, 1, 1)
		UI._SET_TEXT_ENTRY("STRING")
		UI._ADD_TEXT_COMPONENT_STRING(settings["name"])
		UI._DRAW_TEXT(0.5, 0.0425 + (settings["ymin"] - 0.0125))
	 end
end

return GUI
