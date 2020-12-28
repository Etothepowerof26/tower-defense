ROUNDS = ROUNDS || {}

ROUNDS.GAME_STATE_WAITING_PLAYERS = 2^5
ROUNDS.GAME_STATE_DIFFVOTE = 2^6
ROUNDS.GAME_STATE_INTERMISSION = 2^7
ROUNDS.GAME_STATE_SPAWNING = 2^8
ROUNDS.GAME_STATE_WAITING_ALL_DEAD = 2^9

function ROUNDS:GetState()
	return GetGlobalInt("tower_defense.GameState", GAME_STATE_WAITING_PLAYERS)
end

function ROUNDS:SetState(n)
	SetGlobalInt("tower_defense.GameState", n)
end

function ROUNDS:GetGameStartTimer()
	return GetGlobalInt("tower_defense.GameStartTimer", 0)
end

function ROUNDS:SetGameStartTimer(n)
	SetGlobalInt("tower_defense.GameStartTimer", n)
end

if SERVER then

	ROUNDS:SetState(ROUNDS.GAME_STATE_WAITING_PLAYERS)
	ROUNDS:SetGameStartTimer(0)

	local function GetAllCurrentlyLoaded()
		local players = player.GetAll()
		local tbl = {}
		for i = 1, #players do
			local ply = players[i]
			if ply:GetVar("NotFullyLoaded", true) == false then
				tbl[#tbl + 1] = ply
			end
		end
		return tbl
		-- todo: 
	end

	local LAST_MESSAGE = SysTime()

	function ROUNDS.SpawnEnemy(enm)
		
		local spawns = WAYPOINTS.GetSpawns()
		local ourSpawn
		if #spawns == 1 then
			ourSpawn = spawns[1] 
		else
			ourSpawn = spawns[math.random(1, #spawns)]
		end
		
		local ent = ents.Create(enm)
		ent:SetPos(ourSpawn.pos)
		ent:Spawn()
		ent:SetCurrentWaypointID(ourSpawn.nextWaypoint)
		ent:UpdateCurrentWaypointInformation()
		
	end


	function ROUNDS.DoGameLogic()
		local state = ROUNDS:GetState()

		if state == ROUNDS.GAME_STATE_WAITING_PLAYERS then
			if #GetAllCurrentlyLoaded() > 0 then
				local time = ROUNDS:GetGameStartTimer()
				if time == 0 then
					ROUNDS:SetGameStartTimer(SysTime() + 10)
					LAST_MESSAGE = SysTime()

					PrintMessage(3, "There are players!")
				else
					if SysTime() > LAST_MESSAGE + 1 then
						LAST_MESSAGE = SysTime()
						PrintMessage(3, "Game starting in " .. math.ceil(time - SysTime()) .. " seconds")
					end
					if SysTime() > time then
						ROUNDS:SetState(ROUNDS.GAME_STATE_DIFFVOTE)
						ROUNDS:SetGameStartTimer(0)
					end
				end
			else
				ROUNDS:SetGameStartTimer(0)
			end
		elseif ROUNDS.GAME_STATE_DIFFVOTE then
			if not DIFFVOTE.Started then
				DIFFVOTE:StartVote()
			end

			if DIFFVOTE.Started and DIFFVOTE.TimeSinceStart > DIFFVOTE.Duration then
				local winner = DIFFVOTE:EndVote()

				PrintMessage(3, "The winning difficulty is... " .. winner.Name .. "!")

				ROUNDS:SetState( ROUNDS.GAME_STATE_INTERMISSION )
				ROUNDS:SetGameStartTimer(0)
			end
		elseif ROUNDS.GAME_STATE_INTERMISSION then
		elseif ROUNDS.GAME_STATE_SPAWNING then
		elseif ROUNDS.GAME_STATE_WAITING_ALL_DEAD then
		end
	end


	hook.Remove("Think", "ROUNDS_Logic", ROUNDS.DoGameLogic)

	concommand.Add("test_headcrab_swarm", function()
		timer.Create("the crabs are invading", 0.75, 0, function()
			ROUNDS.SpawnEnemy("td_enemy_thecrab")
		end)
	end)


end

if CLIENT then

end