--
-- /notify <player> <message>
--
-- Sends a PM to an online player using HUD elements
-- Restricted to only moderators, due to the potential for abuse
--

local setting = "hud_notify.duration"

minetest.register_chatcommand("notify", {
	params = "<player_name> <message>",
	description = "Shows a message to player using HUD elements. e.g. /notify LegendaryGriefer Stop griefing or face a ban!",
	privs = {kick = true, ban = true},
	func = function(name, param)
		param = param:trim()
		local player_name, msg = param:match("^(%S+)%s(.+)$")
		if not player_name then
			return false, "Invalid usage, see /help notify."
		end
		if not core.get_player_by_name(player_name) then
			return false, "The player " ..player_name.. " is not online."
		end
		minetest.chat_send_player(name, "Notification sent to " ..player_name.. ": \"" ..msg.. "\"")
		
		local player = minetest.get_player_by_name(player_name)
		local hud_bg = player:hud_add({
			hud_elem_type = "image",
			position = {x = 0, y = 0},
			offset = {x = 50, y = 300},
			scale = {x = -30, y = -30},
			alignment = {x = 1, y = 0},
			text = "hud_notify_bg.png"
		})
		local hud_msg = player:hud_add({
			hud_elem_type = "text",
			position = {x = 0, y = 0},
			offset = {x = 70, y = 210},
			alignment = {x = 1, y = 0},
			number = 0xFFFFFF,
			text = msg
		})
		
		local duration = tonumber(minetest.settings:get(setting))
		if not duration then
			duration = 10
			minetest.settings:set(setting, "10")
		end
		
		minetest.after(duration, function()
			local player = minetest.get_player_by_name(player_name)
			if player then
				player:hud_remove(hud_bg)
				player:hud_remove(hud_msg)
			end
		end)
	end
})
