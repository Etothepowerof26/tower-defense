local Tag = "tower_defense"
local Player = FindMetaTable("Player")
module(Tag, package.seeall)

/*
	Tower Defense gamemode for GMod 13
	made by E^26, started on 2020

	The motivation behind this project is the lack of
	tower defense gamemodes on the server list, because
	I am a sucker for tower defense games.
*/

placed_towers = placed_towers or {}
enemies = enemies or {}
max_lives = GetConVar("gtd_default_lives"):GetInt()
max_towers = GetConVar("gtd_max_towers"):GetInt()
new_cash = GetConVar("gtd_default_cash"):GetInt()

stinger_sounds = {
	"music/stingers/HL1_stinger_song16.mp3",
	"music/stingers/HL1_stinger_song27.mp3",
	"music/stingers/HL1_stinger_song28.mp3",
	"music/stingers/HL1_stinger_song7.mp3",
	"music/stingers/HL1_stinger_song8.mp3",
	"music/stingers/industrial_suspense1.wav"
}
boss_round_music = "music/stingers/industrial_suspense2.wav"

ResetGame = function()
	max_lives = GetConVar("gtd_default_lives"):GetInt()
	max_towers = GetConVar("gtd_max_towers"):GetInt()
	new_cash = 5123213--GetConVar("gtd_default_cash"):GetInt()

	-- default global ints
	SetGlobalInt("tower_defense.round", 0)
	SetGlobalInt("tower_defense.enemies_left", 0)
	SetGlobalInt("tower_defense.time_left", 30)
	SetGlobalInt("tower_defense.lives", max_lives)

	SetGlobalBool("tower_defense.settingup", true)

	PrintTable(Towers)
end

function ClearEnemies()
	local _ents = ents.GetAll()
	for i = 1, #_ents do
		local ent = _ents[i]

		if ent:GetClass() == "tower_defense_enemy" or ent.Base == "tower_defense_enemy" then
			ent:Remove()
		end
	end
end

local ratelimit
do
	local ratelimits = {}

	ratelimit = function(ply, name, time)
		if not ratelimits[ply] then
			ratelimits[ply] = {}
		end

		if not ratelimits[ply][name] then
			ratelimits[ply][name] = SysTime() + time
			return true
		end

		if SysTime() > ratelimits[ply][name] then
			ratelimits[ply][name] = SysTime() + time
			return true
		end

		return false
	end
end


function Player:BuyTower(tower,pos)
	local wep = self:GetActiveWeapon()
	if wep:GetClass() == "tower_defense_tool" then
		wep:SendWeaponAnim(ACT_PHYSCANNON_ANIMATE)
	end
	self:EmitSound("ambient/alarms/warningbell1.wav")
	local t=ents.Create(tower.ent)
	t:SetSpawnEffect( true )
	t:Spawn()
	t:SetPlayerOwner(self)
	timer.Simple(0,function()
		t:SetPos(pos+Vector(0,0,t:OBBMaxs().z/2))
	end)
	self:Notify("You have placed a " .. tower.name .. "!", 3, 5)
	self:SetNWInt("tower_defense.cash", self:GetNWInt("tower_defense.cash") - tower.price)
	if not placed_towers[self] then
		placed_towers[self] = {t}
	else
		local _t = placed_towers[self]
		_t[#_t + 1] = t
	end
end
net.Receive("tower_defense.BuyTower", function(len,ply)
	local tower = net.ReadString()
	if not Towers[tower] then ply:Kick() return end
	if not ratelimit(ply, "BuyTower", 2) then
		ply:Notify("Slow down!", 1, 5)
		return
	end

	local t = Towers[tower]
	if ply:GetNWInt("tower_defense.cash",new_cash) >= t.price then
		local pos = ply:GetEyeTrace().HitPos
		ply:BuyTower(t,pos)
	else
		ply:Notify("You cannot afford this tower!", 1, 5)
	end
end)

hook.Add("InitPostEntity", Tag, ResetGame)

-- I wanna make sure the player fully loads before we do some stuff
hook.Add("PlayerFullLoad", Tag, function(ply, loadtime)
	print(ply, "character loaded in", loadtime, "seconds")
	ply:SetCash(new_cash)

	PrintMessage(3, ply:Nick() .. " has joined the game.")
end)

local cached = {}
local function GetTowerBasedOnClass(class)
	if cached[class] then
		return unpack(cached[class])
	end

	for k,v in pairs(Towers) do
		if v.ent == class then
			cached[class] = {k, v}
			return unpack(cached[class])
		end
	end
	return nil
end

hook.Add("PlayerDisconnected", Tag, function(ply)
	PrintMessage(3, ply:Nick() .. " has left the game.")

	local money_pool = 0
	if placed_towers[ply] then
		print("selling",ply,"towers")
		for i = 1, #placed_towers[ply] do
			local tower = placed_towers[ply]:GetClass()
			money_pool = money_pool + GetTowerBasedOnClass(tower).price

			placed_towers[ply]:Remove()
		end
	end

	PrintMessage(3, "Their towers have been sold and the money from the sale has been distributed between everyone in the game.")

	local amnt = #player.GetAll()
	for k,v in pairs(player.GetAll()) do
		if v == ply then continue end 
		
		v:AddCash(math.floor(money_pool / amnt))
	end
end)

// TODO: Not hardcode.
mapTable = {
	["td_wasteland_fix"] = {
		Vector(-172.36859130859,-415,256.03125),
		Vector(415.09606933594,-415,256.03125),
		Vector(660,-528.67419433594,256.03121948242),
		Vector(660,-699.03607177734,256.03125),
		Vector(410.96697998047,-819,256.03128051758),
		Vector(-392,-819,256.03125),
		Vector(-392,-133.01284790039,256.03125),
		Vector(-917,-150.60887145996,256.03125),
		Vector(-917,-399.08746337891,256.03125),
		{
			Vector(-836,-524.24597167969,256.03125),
			Vector(-986.75921630859,-523.60107421875,256.03121948242)
		},
		Vector(-856,-768.18408203125,256.03125),
		Vector(-855.04656982422,-924.76928710938,256.03125),
		Vector(-978.73059082031,-927.00848388672,256.03125)
	}
}
hook.Add("PlayerLoadout", Tag, function(ply)
	ply:Give("tower_defense_tool")
end)

include("td_state.lua")

function StopGame()
	ClearEnemies()
	hook.Remove('Think',Tag)
	hook.Remove('OnEnemyGotThroughExit',Tag)
end

hook.Add("OnEnemyGotThroughExit",Tag,function(enemy)
	local lives = GetGlobalInt('tower_defense.lives')

	SetGlobalInt("tower_defense.lives", lives - 1)
	GAMEMODE:_ChatPrint(Color(255, 0, 0), "An enemy has gotten through! You now have " .. tostring(lives - 1) .. " lives left.")

	spawned_enemies[enemy] = false

	lives = GetGlobalInt('tower_defense.lives')
	if lives < 1 then
		GAMEMODE:_ChatPrint(Color(255, 0, 0), "You are out of lives and subsequently lost the game!")
		-- PrintMessage(3, "Map will change in 5 seconds.")

		StopGame()
		if MapVote and MapVote.Start then
			MapVote.Start(30, true, 8, "td_")
		else
			GAMEMODE:_ChatPrint(Color(255, 0, 0), "ERROR: Map voting is impossible, restarting server in 5s for current map.")
			timer.Simple(5, function()
				game.ConsoleCommand("changelevel " .. game.GetMap() .. "\n")
			end)
		end
	end
end)


concommand.Add("_debug_add_enemy", function()
local _ = SpawnEntity and SpawnEntity("tower_defense_enemy")
end)
-- 