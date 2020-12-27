AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

resource.AddFile( "materials/daglow.png" )

function GM:PlayerInitialSpawn(ply)
	ply:SetModel("models/player/kleiner.mdl")
end


util.AddNetworkString( "ChatPrintColor" )


---
-- Modified version of
-- https://github.com/yumi-xx/gmod-streamstage/blob/master/gamemodes/stream/gamemode/init.lua#L7
---
hook.Add("PlayerInitialSpawn", "FullLoadSetup", function(ply)
	ply:SetVar("NotFullyLoaded", true)
	ply:SetVar("StartLoadTime", SysTime())
end)

hook.Add("SetupMove", "FullLoadSetup", function(ply, _, cmd)
	if ply:GetVar("NotFullyLoaded", true) and not cmd:IsForced() then
		ply:SetVar("NotFullyLoaded", false)
		hook.Run("PlayerFullLoad", ply, SysTime() - ply:GetVar("StartLoadTime", SysTime()))
	end
end)