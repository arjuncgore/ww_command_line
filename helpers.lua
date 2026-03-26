local waywall = require("waywall")
local M = {}

local letters = {
    "a", "b", "c", "d", "e", "f", "g", "h",
    "i", "j", "k", "l", "m", "n", "o", "p",
    "q", "r", "s", "t", "u", "v", "w", "x",
    "y", "z",
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
    "Return", "Backspace",
}


function M.normalize_key(key)
    key = key:gsub("^%*%-", "")
    key = key:lower()
    return key
end

function M.list_contains(words, word)
    for _, w in ipairs(words) do
        if w == word then return true end
    end
    return false
end

function M.typing_actions(config, fn)
    local saved = {}
    for key, func in pairs(config.actions) do
        local normalized_key = M.normalize_key(key)
        if M.list_contains(letters, normalized_key) then
            config.actions[key] = function()
                if Command_Mode then
                    return fn(normalized_key)
                else
                    return func()
                end
                -- return Command_Mode and fn(normalized_key) or func()
            end
            saved[normalized_key] = true
        else
            config.actions[key] = function()
                return not Command_Mode and func() or false
            end
        end
    end

    for _, letter in ipairs(letters) do
        if not saved[letter] then
            config.actions["*-" .. letter] = function()
                if Command_Mode then
                    return fn(letter)
                else
                    return false
                end
                -- return Command_Mode and fn(letter) or false
            end
        end
    end
end

return M
