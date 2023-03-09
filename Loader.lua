--[[
    Loader.lua
    Nicklaus_s
    8 March 2023

    Responsible for caching modules.
--]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService('StarterPlayer').StarterPlayerScripts
local RunService = game:GetService("RunService")

local Loader = {}
Loader.__index = Loader

function Loader.New()
    return setmetatable({
        Container = nil,
        Cache = {}
    }, Loader)
end

function Loader:Require(Value: string)
    self:_Setup()

    local Existing = self.Cache[Value]

    if Existing then
        return require(Existing)
    else
        warn(`[Loaded] Request module "{Value}" does not exist.`)
    end
end

function Loader:_Setup()
    local Existing = rawget(self, 'Container')

    if Existing then
        return Existing
    end

    if RunService:IsRunning() then
        if RunService:IsServer() then
            local List = {}

            for _, Object in ReplicatedStorage.Modules:GetDescendants() do
                if Object:IsA('ModuleScript') and not Object:FindFirstAncestorWhichIsA('ModuleScript') then
                    List[Object.Name] = Object
                    warn(`[Loader] Added {Object.Name} to cache.`)
                end
            end

            for _, Object in ServerScriptService.Modules:GetDescendants() do
                if Object:IsA('ModuleScript') and not Object:FindFirstAncestorWhichIsA('ModuleScript') then
                    List[Object.Name] = Object
                    warn(`[Loader] Added {Object.Name} to cache.`)
                end
            end

            rawset(self, 'Container', List)
            self:_Build()
        end

        if RunService:IsClient() then
            local List = {}

            for _, Object in ReplicatedStorage.Modules:GetDescendants() do
                if Object:IsA('ModuleScript') and not Object:FindFirstAncestorWhichIsA('ModuleScript') then
                    List[Object.Name] = Object
                    warn(`[Loader] Added {Object.Name} to cache.`)
                end
            end

            for _, Object in StarterPlayerScripts.Modules:GetDescendants() do
                if Object:IsA('ModuleScript') and not Object:FindFirstAncestorWhichIsA('ModuleScript') then
                    List[Object.Name] = Object
                    warn(`[Loader] Added {Object.Name} to cache.`)
                end
            end

            rawset(self, 'Container', List)
            self:_Build()
        end
    else
        error('[Loader] Test mode is not supported.')
    end
end

function Loader:_Build()
    for Name, Object in self.Container do
        if Object:IsA('ModuleScript') and not Object:FindFirstAncestorWhichIsA('ModuleScript') then
            local Existing = self.Cache[Name]

            if Existing then
                warn(`[Loader] "{Name}" already exists within cache, skipping and using first found.`)
                continue
            else
                self.Cache[Name] = Object
            end
        end
    end
end

return Loader