local getgenv = getgenv
local getrawmetatable = getrawmetatable
local checkcaller = checkcaller
local newcclosure = newcclosure
local next = next
local getinfo = debug.getinfo
local is_synapse_function = is_synapse_function
local realGenv = {}
for i, v in next, getgenv() do
    realGenv[i] = v
    getgenv()[i] = nil
end
local mt = getrawmetatable(getgenv())
local robloxEnv = mt.__index -- mt.__index == getrenv() -> true
mt.__index = newcclosure(function(self, idx)
    if checkcaller() and is_synapse_function(getinfo(3).func) then -- 3 with newcclosure, 2 without.
        if realGenv[idx] ~= nil then
            return realGenv[idx]
        end
    end
    return robloxEnv[idx]
end)
mt.__newindex = newcclosure(function(self, idx, val)
    if checkcaller() and is_synapse_function(getinfo(3).func) then -- 3 with newcclosure, 2 without.
        realGenv[idx] = val
    else
        robloxEnv[idx] = val
    end
end)
