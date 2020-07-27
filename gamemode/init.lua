AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_meta.lua")
include("shared.lua")
include("sv_td.lua")
include("sh_meta.lua")

local Player = FindMetaTable("Player")
util.AddNetworkString("tower_defense.PlaySound")
util.AddNetworkString("tower_defense.BuyTower")
util.AddNetworkString("tower_defense.Cleanup")
util.AddNetworkString("tower_defense.Notify")
util.AddNetworkString("tower_defense.ChatPrint")

function GM:CleanupTheWholeMap()
	net.Start('tower_defense.Cleanup')
	net.Broadcast()
end

function GM:PlayerInitialSpawn(ply)
	ply:SetModel("models/player/kleiner.mdl")
end

function GM:BroadcastSound(snd)
	net.Start("tower_defense.PlaySound")
		net.WriteString(snd)
	net.Broadcast()
end

function Player:BroadcastSound(snd)
	net.Start("tower_defense.PlaySound")
		net.WriteString(snd)
	net.Send(self)
end

function Player:Notify(str, enum, time)
	net.Start('tower_defense.Notify')
		net.WriteString(str or "")
		net.WriteUInt(enum or 1, 4)
		net.WriteUInt(time or 2, 8)
	net.Send(self)
end


function GM:_ChatPrint(...)
	net.Start('tower_defense.ChatPrint')
		net.WriteTable{...}
	net.Broadcast()
end

function Player:_ChatPrint(...)
	net.Start('tower_defense.ChatPrint')
		net.WriteTable{...}
	net.Send(self)
end


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