
local cLerp = Color(255, 255, 255)
local tLerp = 0
hook.Add("HUDPaint", "", function()
	-- cash
	draw.LinearGradient(0, ScrH() / 4, 350, 35, {
		{offset = 0 , color = Color(70, 70, 70)},
		{offset = .4, color = Color(70, 70, 70)},
		{offset = 1 , color = Color(70, 70, 70, 0)}
	}, true)

	do
		surface.SetFont( "Trebuchet24" )
		local t = "Cash: $" .. string.Comma(tostring(LocalPlayer():GetCash() or 0))
		local tw, th = surface.GetTextSize( t )
		surface.SetTextColor( 255, 255, 255 )
		surface.SetTextPos( 15, (ScrH() / 4) + (35 / 2) - (th / 2) )
		surface.DrawText( t )
	end

	-- waves



	local w = GetGlobalInt("tower_defense.round", 0)
	if w == 0 then return end


	local coef = 0.01
	if w % 13 == 0 and w ~= 00 then
		cLerp = Color(
			Lerp(coef, cLerp.r, 255),
			Lerp(coef, cLerp.g, 80),
			Lerp(coef, cLerp.b, 80)
		)

		tLerp = math.Round(tLerp,0) ~= 4 and Lerp(coef * 2, tLerp, 4) or 4
	else
		cLerp = Color(
			Lerp(coef, cLerp.r, 255),
			Lerp(coef, cLerp.g, 255),
			Lerp(coef, cLerp.b, 255)
		)

		tLerp = math.Round(tLerp,0) ~= 2 and Lerp(coef * 2, tLerp, 2) or 2
	end



	do
		draw.LinearGradient(ScrW() - 200, ScrH() / 4, 200, 35, {
			{offset = 0 , color = Color(70, 70, 70, 0)},
			{offset = .4, color = Color(70, 70, 70)},
			{offset = 1 , color = Color(70, 70, 70)},
		}, true)

		surface.SetFont( "Trebuchet24" )
		local t = "Wave: " .. string.Comma(tostring(w))
		local tw, th = surface.GetTextSize( t )
		surface.SetTextColor( cLerp.r, cLerp.g, cLerp.b )

		surface.SetTextPos( ScrW() - 15 - tw, (ScrH() / 4) + (35 / 2) - (th / 2) )
		surface.DrawText( t )

		draw.GlowText(t, "Trebuchet24",  ScrW() - 15 - tw - 1, (ScrH() / 4) + (35 / 2) - 1, cLerp, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, tLerp, true)
	end
end) 