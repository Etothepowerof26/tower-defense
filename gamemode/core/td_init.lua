local shared = function(f)
	AddCSLuaFile(f)
	include(f)
end

local server = function(f)
	if SERVER then
		include(f)
	end
end

local client = function(f)
	AddCSLuaFile(f)
	if CLIENT then
		include(f)
	end
end

/*
	Tower Defense gamemode for GMod 13
	made by E^26, started on 2020

	The motivation behind this project is the lack of
	tower defense gamemodes on the server list, because
	I am a sucker for tower defense games.

	Rewrite counter: 3
*/

tower_defense = tower_defense || {}

shared("meta.lua")
shared("round/waypoints.lua")
if WAYPOINTS then WAYPOINTS.Init() end
shared("round/logic.lua")

client("ui/hudutil.lua")
client("ui/hud.lua")
client("ui/roundnotif.lua")

server("difficulties/diffloader.lua")
if DIFFS then DIFFS.Init() end
shared("difficulties/diffvote.lua")