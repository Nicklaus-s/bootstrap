--[[
    Bootstrap.lua
    Nicklaus_s
    8 March 2023

    Responsible for providing require() functionality,
    relying on a caching method.
--]]

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Loader = require(ReplicatedStorage.Loader).New()

local Bootstrap = {}
Bootstrap.__index = Bootstrap

function Bootstrap.Load()
    return setmetatable({}, {
        __call = function(_, Value: string)
            warn(`[Bootstrap] Calling require on {Value}!`)
            return Loader:Require(Value)
        end,
        __index = function(_, Value: string)
            warn(`[Bootstrap] Calling require on {Value}!`)
            return Loader:Require(Value)
        end
    })
end

return Bootstrap

-- return setmetatable({
--     Load = function()
--         print('called .Load()')
--         return setmetatable({}, {
--             __call = function(_, Value)
--                 print('called require')
--                 return Loader:Require(Value)
--             end,
--             __index = function(_, Value)
--                 return Loader:Require(Value)
--             end
--         })
--     end
-- }, {
--     __call = function(_, value)
--         return Loader:Require(value)
--     end,
--     __index = function(_, key)
--         return Loader:Require(key)
--     end
-- })

-- https://github.com/Quenty/NevermoreEngine/blob/main/src/loader/src/init.lua
-- .load is ran: LegacyLoader:GetLoader()
-- https://github.com/Quenty/NevermoreEngine/blob/main/src/loader/src/LegacyLoader.lua
-- returns Loader.new(), which is basically require(module)?? https://github.com/Quenty/NevermoreEngine/blob/main/src/loader/src/Loader.lua
-- runs setup functions and such