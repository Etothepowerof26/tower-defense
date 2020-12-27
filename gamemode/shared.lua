GM.Name = "GMOD Tower Defense"
GM.Author = "twentysix"
GM.Email = "artillerybeacon@gmail.com"
GM.Website = "nil"

function GM:Initialize()
	self.BaseClass.Initialize(self)
end

AddCSLuaFile("core/td_init.lua")
include("core/td_init.lua")

if SERVER then

	ChatPrintColor = function( ... )
		local tab = { ... }
		net.Start( "ChatPrintColor" )
		net.WriteTable( tab )
		net.Broadcast()
	end

else

	ChatPrintColor = chat.AddText

	net.Receive( "ChatPrintColor", function()
		chat.AddText( unpack( net.ReadTable() ) )
	end )

end