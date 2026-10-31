# Waywall Command Line

Run commands through waywall config via text inputs rather than keyboard shortcuts

## Setup
### Using [plug.waywall](https://github.com/its-saanvi/plug.waywall)
```lua
return {
    url = "https://github.com/arjuncgore/ww_command_line",
    config = function(config)
        require("command_line").setup(config, {
            start_key = "BACKSLASH",
            enter_key = "Return",
            look = {
                x = 200,
                y = 200,
                size = 7,
                color = "#FFFFFF"
            },
            commands = {
                -- [<string>] = <function>
            },
            arbitrary_command = function(key)
                -- <function>
            end,
    })
    end,
    name = "command_line",
    update_on_load = true,
}
```

### Otherwise
#### Clone plugin to waywall config folder
```bash
git clone https://github.com/arjuncgore/ww_command_line ~/.config/waywall/command_line
```
#### Setup config in `init.lua`
```lua
-- rest of config
require("command_line").setup(config, {
            start_key = "BACKSLASH",
            enter_key = "Return",
            look = {
                x = 200,
                y = 200,
                size = 7,
                color = "#FFFFFF"
            },
            commands = {
                -- [<string>] = <function>
            },
            arbitrary_command = function(key)
                -- <function>
            end,
    })
return config
```

## Configuration
- Edit the `looks` table to move around the input.
- Add commands by typing a string as the key and any function as the value
```lua
["test"] =  function()
                print("test")
            end,
```
- The arbitrary_command function takes in the string input as a parameter, it runs if the user types in a command that doesn't exist as a key in the `commands` table
```lua
arbitrary_command = function(key)
    print(key)
end,
```

## Demo Videos
https://www.twitch.tv/goreay_/clip/PowerfulWrongArugulaNerfRedBlaster-q2RyRhXZgJGp0FXf
https://www.twitch.tv/goreay_/clip/PowerfulStrongBobaBloodTrail-m1d4zlV1o1REGKZW
