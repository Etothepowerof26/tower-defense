
local DIFF = {
}

DIFF.Name = "Normal"
DIFF.Description = "How the game was meant to be played!"
DIFF.NameColor = Color(255, 255, 69)


DIFF.CashMultiplier = 1
DIFF.LifeMultiplier = 1
DIFF.SpeedMultiplier = 1



surface.CreateFont("DiffShow", {
	size = 25,
	weight = 100,
	font = "Trebuchet",
	extended = false
})

surface.CreateFont("DiffName", {
	size = 45,
	weight = 800,
	font = "Trebuchet",
	extended = false
})

local glowmat = Material("daglow.png")


function DoRoundNotificationFunc( tab )
	local frame = vgui.Create( "DFrame" )
	frame:SetSize( ScrW() / 4, ScrH() / 3 )
	frame:SetPos( ScrW() / 2 - frame:GetWide() / 2, ScrH() / 4 - frame:GetTall() / 2 )
	--frame:MakePopup()
	frame:ShowCloseButton( false )
	frame:SetTitle( "" )

	local start = SysTime()
	local _a
	local a
	local b
	local c

	function frame:Paint( w, h )
			if not _a then
				_a = 0
			else
				_a = Lerp( 0.1, _a, 255 )
			end
		render.SetColorMaterial()
		surface.SetDrawColor(25, 25, 25, _a)
		surface.DrawRect(0, 0, w, h)

		if SysTime() > start + 0.5 then
			if not a then
				a = 0
			else
				a = Lerp( 0.025, a, 255 )
			end
			
			surface.SetFont( "DiffShow" )
			surface.SetTextColor( 255, 255, 255, a )
			local tw, th = surface.GetTextSize("Difficulty:")
			surface.SetTextPos( w / 2 - tw / 2, h / 8 - th / 2 )
			surface.DrawText( "Difficulty:" )
		end

		if SysTime() > start + 1.5 then
			if not b then
				b = 0
			else
				b = Lerp( 0.025, b, 255 )
			end
			tab.NameColor.a = b

			surface.SetFont( "DiffName" )
			local tw, th = surface.GetTextSize( tab.Name or "Normal" )
			local tx, ty = w / 2 - tw / 2, h / 4 - th / 2

			surface.SetMaterial(glowmat)
			surface.SetDrawColor(tab.NameColor.r, tab.NameColor.g, tab.NameColor.b, math.Remap( b / 255, 0, 1, 0, 80 ))
			surface.DrawTexturedRect(tx - 65, ty - 15, tw + 130, th + 30)

			
--glowmat
			surface.SetTextColor( tab.NameColor:Unpack() )
			surface.SetTextPos( w / 2 - tw / 2, h / 4 - th / 2 )
			surface.DrawText( tab.Name )
		end

	end

	timer.Simple( 12, function()
		if not IsValid(frame) then return end
		frame:Close()
	end )

end

concommand.Add("donormal", function()
DoRoundNotificationFunc( DIFF )
end)