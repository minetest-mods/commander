    local commander = ""
    minetest.after(0, function()
       for cmd in pairs(minetest.chatcommands) do
          if cmd ~= "command_gui" then
             commander = commander..cmd..","
          end
       end
       commander = commander:sub(1, -2)
    end)

    local function formspec(cmd_name)
       local number = 1
       if cmd_name then
          for i, cmd in ipairs(commander:split(",")) do
             if cmd == cmd_name then
                number = i
                break
             end
          end
       else
          cmd_name = commander:split(",")[1]
       end

       local def = minetest.chatcommands[cmd_name]

       local privileges = ""
       for priv, bool in pairs(def.privs or {}) do
          if bool then
             privileges = privileges..priv..","
          end
       end
       privileges = minetest.formspec_escape(#privileges ~= 0 and privileges:sub(1, -2) or "")
       local description = minetest.formspec_escape(def.description or "")
       local parameters = minetest.formspec_escape(def.params or "")

       return "size[9,4;]"..
          "dropdown[,;9.5,1;command;"..commander..";"..number.."]"..
          "label[,1;Description: "..description.."]"..
          "label[,1.5;Privileges: "..privileges.."]"..
          "field[.3,2.7;9,1;param;Parameter:;"..parameters.."]"..
          "button[,3.3;9,1;run;Run]"
    end


-- Open command gui by chat

    minetest.register_chatcommand("commander", {
       func = function(name)
          minetest.after(0.5, minetest.show_formspec, name, "command_gui:menu", formspec())
       end
    })

	
    minetest.register_on_player_receive_fields(function(player, formname, fields)
       if formname ~= "command_gui:menu" then
          return
       end

       local name = player:get_player_name()

       if fields.run then
          local def = minetest.chatcommands[fields.command]
          if not def then
             return
          end

          local has_privs, missing_privs = minetest.check_player_privs(name, def.privs)
          if has_privs then
             minetest.set_last_run_mod(def.mod_origin)
             local success, message = def.func(name, fields.param)
             if message then
                minetest.chat_send_player(name, message)
             end
          else
             minetest.chat_send_player(name, "You don't have permission"..
                " to run this command (missing privileges: "..
                table.concat(missing_privs, ", ") .. ")")
          end
       elseif fields.command and not fields.quit then
          minetest.show_formspec(name, "command_gui:menu", formspec(fields.command))
       end
    end)
  
------
-- Commander Tool


-- items
minetest.register_craftitem("commander:commander", {
    description = "Commander",
    inventory_image = "commander.png",   
    on_use =  function(itemstack, user, pointed_thing)
          local name = user:get_player_name()
          minetest.after(0.5, minetest.show_formspec, name, "command_gui:menu", formspec())

    end,      
})


-- recipes
minetest.register_craft({
    output = "commander:commander",
    recipe = {
        {"vessels:glass_fragments", "default:iron_lump", ""}
    }
})  
