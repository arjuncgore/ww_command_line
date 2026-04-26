local M = {}
local waywall = require("waywall")
local h = require("ww_command_line.helpers")

Command_Mode = false
local command_cur = ""
local command_text = nil
local command_overlay = nil
local command_last = nil

local example_cfg = {
    start_key = "F8",
    enter_key = "Return",
    look = {
        x = 200,
        y = 200,
        size = 7,
        color = "#FFFFFF"
    },
    commands = {
        ["test1"] = function() print("testing: test1") end,
        ["test2"] = function() print("testing: test2") end,
    },
    arbitrary_command = function(key)
        print(key)
    end,
    repeat_last_arbitrary = false,
}

function Run_Command(key, cfg)
    print("running command: " .. key)
    if key == nil then
        print("no command ran")
    end
    if key == "" then
        print("running last command")
        print(command_last)
        Command_Mode = false
        Run_Command(command_last, cfg)
    elseif cfg.commands[key] ~= nil then
        print("found command")
        Command_Mode = false
        cfg.commands[key]()
        command_last = key
        print("set last command to :::" .. command_last)
    else
        Command_Mode = false
        cfg.arbitrary_command(key)
        if cfg.repeat_last_arbitrary then
            command_last = key
        end
    end
end

function Clear_Command()
    command_cur = ""
    if command_overlay then
        command_overlay:close()
        command_overlay = nil
    end
    if command_text then
        command_text:close()
        command_text = nil
    end
end

function Update_Command(key, cfg)
    if command_text then
        command_text:close()
        command_text = nil
    end
    if key ~= "Return" then
        if key == "Backspace" then
            command_cur = command_cur:sub(1, math.max(#command_cur - 1, 0))
        elseif key == "Space" then
            command_cur = command_cur .. " "
        else
            command_cur = command_cur .. key
        end
    elseif key == "Return" then
        -- ACTIONS
        Run_Command(command_cur, cfg)
        Clear_Command()
    end
    print(command_cur)
    command_text = waywall.text(command_cur, {
        x = cfg.look.x,
        y = cfg.look.y + (cfg.look.size + 2) * 10,
        size = cfg.look.size,
        color = cfg.look.color
    })


    -- return true
end

function Toggle_Command_Line(config, cfg)
    if command_overlay then
        command_overlay:close()
        command_overlay = nil
    end
    if command_text then
        command_text:close()
        command_text = nil
    end
    -- SWITCH MODE FROM NORMAL TO GOREDLE AND BACK
    if not Command_Mode then
        -- START GOREDLE
        Command_Mode = true
        command_overlay = waywall.text("Command:", {
            x = cfg.look.x,
            y = cfg.look.y - (cfg.look.size + 2) / 2,
            size = cfg.look.size,
            color = cfg.look.color
        })
    else
        -- STOP GOREDLE
        Command_Mode = false
        Clear_Command()
    end
end

M.setup = function(config, cfg)
    if cfg == nil then
        cfg = example_cfg
    end

    Command_Mode = false
    h.typing_actions(config, function(key) Update_Command(key, cfg) end, cfg.enter_key)

    config.actions[cfg.start_key] = function() Toggle_Command_Line(config, cfg) end
end

return M
