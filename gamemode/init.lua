AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_td.lua")
AddCSLuaFile("cl_td.lua")
include("shared.lua")
include("sh_td.lua")

util.AddNetworkString("TD:ChatAddText")
util.AddNetworkString("TD:Cleanup")
util.AddNetworkString("TD:SpawnTowerGUI")
util.AddNetworkString("TD:TowerInfoGUI")
util.AddNetworkString("TD:BuyTower")
util.AddNetworkString("TD:SellTower")
util.AddNetworkString("TD:MoveTower")

local PLAYER = FindMetaTable("Player")

function ChatAddText(...)
	net.Start("TD:ChatAddText")
	net.WriteTable{...}
	net.Broadcast()
end

function PLAYER:ChatAddText(...)
	net.Start("TD:ChatAddText")
	net.WriteTable{...}
	net.Send(self)
end

function GM:PlayerSpawn(Player)
	player_manager.SetPlayerClass(Player, "player_default")
	player_manager.RunClass(Player, "SetModel")
	self:PlayerLoadout(Player)
	Player:SetTeam(1)
end

function GM:PlayerInitialSpawn(Player)
	Player:SetNWInt("TD:Money", 500)
end

function GM:PlayerLoadout(Player)
	Player:Give("td_placer")
end

function GM:PlayerShouldTakeDamage(Player1, Player2)
	-- Nobody can harm each other.
	return false
end

function GM:PlayerDeath(Player, Inflictor, Attacker)
	-- Respawn the player instantly.
	Player:Respawn()
end