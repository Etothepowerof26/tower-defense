local Tag = "tower_defense"

function player.GetAllCurrentlyLoaded()
	local players = player.GetAll()
	local tbl = {}
	for i = 1, #players do
		local ply = players[i]
		if ply:GetVar("NotFullyLoaded", true) == false then
			tbl[#tbl + 1] = ply
		end
	end
	return tbl
end

local function wait(n)
	local stop=SysTime()+n

	while true do
		if SysTime() < stop then
			coroutine.yield()
		else
			break
		end
	end
end

local rounds = {
	function()
		for i = 1, 7 do
			tower_defense.SpawnEnemy("tower_defense_headcrab")
			wait(2)
		end
		--coroutine.yield(26)
	end,
	function()
		for i = 1, 14 do
			tower_defense.SpawnEnemy("tower_defense_headcrab")
			wait(1)
		end
		--coroutine.yield(26)
	end,
	function()
		for i = 1, 3 do
			tower_defense.SpawnEnemy("tower_defense_headcrab")
			wait(1)
		end
		
		for i = 1, 2 do
			tower_defense.SpawnEnemy("tower_defense_fheadcrab")
			wait(.5)
		end

		wait(1.5)

		for i = 1, 5 do
			tower_defense.SpawnEnemy("tower_defense_headcrab")
			wait(.75)
		end
	end,
	function()
		for i = 1, 10 do
			tower_defense.SpawnEnemy("tower_defense_fheadcrab")
			wait(.75)
		end
		wait(1)
		for i = 1, 3 do
			tower_defense.SpawnEnemy("tower_defense_headcrab")
			wait(1)
		end
	end,
	function()
		for i = 1, 5 do
			tower_defense.SpawnEnemy("tower_defense_fheadcrab")
			wait(.6)
		end
		tower_defense.SpawnEnemy("tower_defense_zombie")
	end,
	function()
		for i = 1, 3 do
			tower_defense.SpawnEnemy("tower_defense_zombie")
			wait(2)
		end
		for i = 1, 7 do
			tower_defense.SpawnEnemy("tower_defense_fheadcrab")
			wait(.6)
		end
	end

}

module(Tag, package.seeall)

local function thegamemode()
	return GM or GAMEMODE or {}
end

/*
	Tower Defense gamemode for GMod 13
	made by E^26, started on 2020
*/

SetGlobalInt("tower_defense.GameState", GAME_STATE_WAITING_PLAYERS)

function SpawnEnemy(ent)
	if not ent:find("tower_defense") then return end
	local e = ents.Create(ent)
	e:SetPos(mapTable[game.GetMap()][1])
	e:Spawn()
	spawned_enemies[e] = true
end

local GAME_STATE_WAITING_PLAYERS = 2^5
local GAME_STATE_INTERMISSION = 2^6
local GAME_STATE_SPAWNING = 2^7
local GAME_STATE_WAITING_ALL_DEAD = 2^8

local LAST_MESSAGE = SysTime()

spawned_enemies = {}

function AllFalse(tab)
	for k,v in pairs(tab) do
		if v == false then continue else return false end
	end
	return true
end

hook.Add("Think", Tag, function()
	local state = GetGlobalInt("tower_defense.GameState", GAME_STATE_WAITING_PLAYERS)

	-- waiting for players
	if state == GAME_STATE_WAITING_PLAYERS then
		if #player.GetAllCurrentlyLoaded() > 0 then
			if GetGlobalInt("tower_defense.GameStartTimer", 0) == 0 then
				SetGlobalInt("tower_defense.GameStartTimer", SysTime() + 10)
				LAST_MESSAGE = SysTime()

				PrintMessage(3, "There is players!")
			else
				if SysTime() > LAST_MESSAGE + 1 then
					LAST_MESSAGE = SysTime()
					PrintMessage(3, "Game starting in " .. math.ceil(GetGlobalInt("tower_defense.GameStartTimer", 0) - SysTime()) .. " seconds")
				end
				if SysTime() > GetGlobalInt("tower_defense.GameStartTimer", 0) then
					SetGlobalInt("tower_defense.GameState", GAME_STATE_INTERMISSION)
					SetGlobalInt("tower_defense.GameStartTimer", 0)
				end
			end
		else
			SetGlobalInt("tower_defense.GameStartTimer", 0)
		end
	-- players are placing towers
	elseif state == GAME_STATE_INTERMISSION then
		if #player.GetAllCurrentlyLoaded() > 0 then
			if GetGlobalInt("tower_defense.GameStartTimer", 0) == 0 then
				SetGlobalInt("tower_defense.GameStartTimer", SysTime() + 30)
				LAST_MESSAGE = SysTime()

				PrintMessage(3, "The next wave will start in 30 seconds!")
			else
				local time = math.ceil(GetGlobalInt("tower_defense.GameStartTimer", 0) - SysTime())
				local wave = GetGlobalInt("tower_defense.round", 0) + 1
				if SysTime() > LAST_MESSAGE + 1 and (time <= 5 or time % 10 == 0) then
					LAST_MESSAGE = SysTime()
					PrintMessage(3, "Wave " .. wave .. " is starting in " .. time .. " seconds")
				end
				if time < 1 then
					SetGlobalInt("tower_defense.GameState", GAME_STATE_SPAWNING)
					SetGlobalInt("tower_defense.GameStartTimer", 0)
					GAMEMODE:BroadcastSound((table.Random(stinger_sounds)))
					PrintMessage(3, "Wave " .. wave .. " is starting!")
				end
			end
		else
			LAST_MESSAGE = SysTime()
			SetGlobalInt("tower_defense.GameStartTimer", 0)
			PrintMessage(3, "There are not enough players.")
			SetGlobalInt("tower_defense.GameState", GAME_STATE_WAITING_PLAYERS)
		end
	-- enemies are spawning
	elseif state == GAME_STATE_SPAWNING then
		if not SPAWNING_COROUTINE then
			local round = GetGlobalInt("tower_defense.round", 0) + 1
			SetGlobalInt("tower_defense.round", round)
			
			if not rounds[round] then
				StopGame()
				MapVote.Start(30, true, 8, "td_")
				return
			end 
			SPAWNING_COROUTINE = coroutine.create(rounds[round])
		end

		local worked, val = coroutine.resume(SPAWNING_COROUTINE)
		if not worked then
			SetGlobalInt("tower_defense.GameState", GAME_STATE_WAITING_ALL_DEAD)
		end
	-- waiting for all enemies to die
	elseif state == GAME_STATE_WAITING_ALL_DEAD then
		SPAWNING_COROUTINE = nil

		if AllFalse(spawned_enemies) then
			PrintMessage(3, "You have completed wave " .. GetGlobalInt("tower_defense.round", 0) .. "!")
			SetGlobalInt("tower_defense.GameState", GAME_STATE_INTERMISSION)
			spawned_enemies = {}

			net.Start('tower_defense.Cleanup', true)
			net.Send(player.GetHumans())
		end
	
	else
		print('invalid state',state)
	end
end)