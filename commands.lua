-- Kill Function

local function handle_kill_command(suspect, victim)
	local victimref = minetest.get_player_by_name(victim)
	if victimref == nil then
		return false, ("Player "..victim.." does not exist.")
	elseif victimref:get_hp() <= 0 then
		if suspect == victim then
			return false, "You are already dead"
		else
			return false, (victim.." is already dead")
		end
	end
	if not suspect == victim then
		minetest.log("action", suspect.." killed "..victim)
	end
	victimref:set_hp(0)
end

-- Kill a player

minetest.register_chatcommand("kill", {
	params = "<name>",
	description = "Kill player",
	privs = {kill=true},
	func = function(name, param)
		return handle_kill_command(name, param)
	end,
})


-- Kill yourself

minetest.register_chatcommand("killme", {
	description = "Kill yourself",
	func = function(name)
		return handle_kill_command(name, name)
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

