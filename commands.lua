-- Suicide from minetest for fun server

minetest.register_chatcommand("killme", {
	params = "",
	description = "Kills yourself",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then return end
		player:set_hp(0)
		if minetest.setting_getbool("enable_damage") == false then
			minetest.chat_send_player(name, "[X] Damage is disabled on this server.")
		else
			minetest.chat_send_player(name, "[X] You suicided.")
		end
	end,
})

-- List banned players

	minetest.register_chatcommand("banlist", {
		description = "List bans",
		privs = minetest.chatcommands["ban"].privs,
		func = function(name)
			return true, "Ban list: " .. core.get_ban_list()
		end,
	})


  
 -- Aliases function

local function register_chatcommand_alias(alias, cmd)
	local def = minetest.chatcommands[cmd]
	minetest.register_chatcommand(alias, def)
end

-- Minecraft commands for minetest

register_chatcommand_alias("?", "help")
register_chatcommand_alias("list", "status")
register_chatcommand_alias("pardon", "unban")
register_chatcommand_alias("stop", "shutdown")
register_chatcommand_alias("tell", "msg")
register_chatcommand_alias("w", "msg")
register_chatcommand_alias("tp", "teleport")
register_chatcommand_alias("suicide", "killme")

