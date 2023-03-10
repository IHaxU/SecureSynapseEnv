local getgenv = getgenv
local getrawmetatable = getrawmetatable
local checkcaller = checkcaller
local newcclosure = newcclosure
local next = next
local getinfo = debug.getinfo
local is_synapse_function = is_synapse_function
local globalEnv = {}
for i, v in next, getgenv() do
    globalEnv[i] = v
    getgenv()[i] = nil
end
local mt = getrawmetatable(getgenv())
local robloxEnv = mt.__index -- mt.__index == getrenv() -> true
mt.__index = newcclosure(function(self, idx)
    if is_synapse_function(getinfo(3).func) then -- 3 with newcclosure, 2 without.
        if globalEnv[idx] ~= nil then
            return globalEnv[idx]
        end
    end
    return robloxEnv[idx]
end)
mt.__newindex = newcclosure(function(self, idx, val)
    if is_synapse_function(getinfo(3).func) then -- 3 with newcclosure, 2 without.
        globalEnv[idx] = val
    else
        robloxEnv[idx] = val
    end
end)
