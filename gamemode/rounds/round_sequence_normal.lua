if not tower_defense then return end
/*
	These functions gets turned into a 
	coroutine, which is used in the tower defense
	state system. You can also put messages
	if you use the wait function before spawning the
	mobs.

	Keep in mind, every 13 rounds is a boss round,
	so on the 13th round, the function will be executed and a boss will
	be appended to the end of the sequence. Unless you
	specify the round with a table instead of a function.
*/

//
// Helper function because coroutine.wait
// doesn't work
//
local function wait(n)
	local stop = SysTime() + n

	while true do
		if SysTime() < stop then
			coroutine.yield()
		else
			break
		end
	end
end

local rounds = {}
local SpawnEnemy

// Regular headcrabs, to start the game out
rounds[#rounds + 1] = function()
	SpawnEnemy = tower_defense.SpawnEnemy
	for i = 1, 7 do
		SpawnEnemy("tower_defense_headcrab")
		wait(2)
	end
end

// They should have a bit more money, so let's give them a couple more headcrabs
rounds[#rounds + 1] = function()
	for i = 1, 12 do
		SpawnEnemy("tower_defense_headcrab")
		wait(1)
	end
end

// Introduce the players to fast headcrabs, faster than usual but lower health.
rounds[#rounds + 1] = function()
	for i = 1, 3 do
		SpawnEnemy("tower_defense_headcrab")
		wait(1)
	end
		
	for i = 1, 2 do
		SpawnEnemy("tower_defense_fheadcrab")
		wait(.5)
	end

	wait(1.5)

	for i = 1, 5 do
		SpawnEnemy("tower_defense_headcrab")
		wait(.75)
	end
end

// Give them a bit of a challenge.
rounds[#rounds + 1] = function()
	for i = 1, 10 do
		SpawnEnemy("tower_defense_fheadcrab")
		wait(.75)
	end

	wait(1)

	for i = 1, 3 do
		SpawnEnemy("tower_defense_headcrab")
		wait(1)
	end
end

// Introduce them to zombies.
rounds[#rounds + 1] = function()
	for i = 1, 5 do
		SpawnEnemy("tower_defense_fheadcrab")
		wait(.6)
	end

	SpawnEnemy("tower_defense_zombie")
end

// Spawn a couple of them now.
rounds[#rounds + 1] = function()
	for i = 1, 3 do
		SpawnEnemy("tower_defense_zombie")
		wait(2)
	end
	
	for i = 1, 7 do
		SpawnEnemy("tower_defense_fheadcrab")
		wait(.6)
	end
end

// Introduce poison headcrabs.
rounds[#rounds + 1] = function()
	for i = 1, 3 do
		SpawnEnemy("tower_defense_bheadcrab")
		wait(2)
	end
	
	wait(3)

	for i = 1, 2 do
		SpawnEnemy("tower_defense_zombie")
		wait(.6)
	end
end

// Give them a couple.
rounds[#rounds + 1] = function()
	for i = 1, 15 do
		SpawnEnemy("tower_defense_bheadcrab")
		wait(1)
	end
end

//
// You shouldnt get to here.
//

rounds[#rounds + 1] = function()
	while true do
		wait(.1)
	end
end

// That's it for now.
return rounds