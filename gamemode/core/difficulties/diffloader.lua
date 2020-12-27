DIFFS = {}
DIFFS.Difficulties = {}


local currentDiff
function DIFFS.CurrentDiff()
	return currentDiff
end


function DIFFS.Include(fi)
	DIFF = {}

	include("difficulties/"..fi..".lua")

	table.insert( DIFFS.Difficulties, DIFF )
	PrintTable(DIFF)
	DIFF = nil
end


function DIFFS.Init()
	DIFFS.Include("normal")
end