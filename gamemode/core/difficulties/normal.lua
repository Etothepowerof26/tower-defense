if (!DIFF) then return end

DIFF.Name = "Normal"
DIFF.Description = "How the game was meant to be played!"
DIFF.NameColor = Color(255, 255, 69)


DIFF.CashMultiplier = 1
DIFF.LifeMultiplier = 1
DIFF.SpeedMultiplier = 1


-- rounds!
local wait = coroutine.wait
local spawn = ROUNDS.SpawnEnemy

DIFF.Rounds = {}

DIFF.Rounds[#DIFF.Rounds + 1] = function()
	PrintMessage(3, "Just sending a couple headcrabs to start things off.")
	for i = 1, 7 do
		spawn("td_base_headcrab")
		wait(2.5)
	end
end