include("shared.lua")
include("sh_td.lua")
include("cl_td.lua")

net.Receive("TD:ChatAddText", function()
	local Table = net.ReadTable()
	chat.AddText(unpack(Table))
end)

net.Receive("TD:Cleanup", function()
	game.RemoveRagdolls()
	RunConsoleCommand("r_cleardecals")
end)

language.Add("td_enemy", "Tower Defense Enemy")