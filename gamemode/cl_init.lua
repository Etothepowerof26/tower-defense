include("shared.lua")
include("cl_td.lua")
include("sh_meta.lua")

net.Receive('tower_defense.PlaySound', function()
	surface.PlaySound(net.ReadString())
end)

net.Receive('tower_defense.Cleanup', function()
	game.CleanUpMap()
	RunConsoleCommand("r_cleardecals")
end)

net.Receive('tower_defense.ChatPrint', function()
	chat.AddText(unpack(net.ReadTable() or {}))
end)

net.Receive('tower_defense.Notify', function(len)
	local str = net.ReadString()
	local enum = net.ReadUInt(4)
	local time = net.ReadUInt(8)

	notification.AddLegacy(str, enum, time)
end)

local mat_white = Material("vgui/white")

function draw.LinearGradient(x, y, w, h, stops, horizontal)
	if #stops == 0 then
		return
	elseif #stops == 1 then
		surface.SetDrawColor(stops[1].color)
		surface.DrawRect(x, y, w, h)
		return
	end

	table.SortByMember(stops, "offset", true)

	render.SetMaterial(mat_white)
	mesh.Begin(MATERIAL_QUADS, #stops - 1)
	for i = 1, #stops - 1 do
		local offset1, offset2 = math.Clamp(stops[i].offset, 0, 1), math.Clamp(stops[i + 1].offset, 0, 1)
		if offset1 == offset2 then continue end

		local deltaX1, deltaY1, deltaX2, deltaY2

		local color1 = stops[i].color
		local color2 = stops[i + 1].color

		local r1, g1, b1, a1, 
			  r2, g2, b2, a2,
			  r3, g3, b3, a3,
			  r4, g4, b4, a4 = color1.r, color1.g, color1.b, color1.a,
							   nil, nil, nil, nil,
							   color2.r, color2.g, color2.b, color2.a,
							   nil, nil, nil, nil

		if horizontal then
			r2, g2, b2, a2, r4, g4, b4, a4 = r3, g3, b3, a3, r1, g1, b1, a1
			deltaX1, deltaY1, deltaX2, deltaY2 = offset1 * w, 0, offset2 * w, h
		else
			r2, g2, b2, a2, r4, g4, b4, a4 = r1, g1, b1, a1, r3, g3, b3, a3
			deltaX1, deltaY1, deltaX2, deltaY2 = 0, offset1 * h, w, offset2 * h
		end

		mesh.Color(r1, g1, b1, a1)
		mesh.Position(Vector(x + deltaX1, y + deltaY1))
		mesh.AdvanceVertex()

		mesh.Color(r2, g2, b2, a2)
		mesh.Position(Vector(x + deltaX2, y + deltaY1))
		mesh.AdvanceVertex()

		mesh.Color(r3, g3, b3, a3)
		mesh.Position(Vector(x + deltaX2, y + deltaY2))
		mesh.AdvanceVertex()

		mesh.Color(r4, g4, b4, a4)
		mesh.Position(Vector(x + deltaX1, y + deltaY2))
		mesh.AdvanceVertex()
	end
	mesh.End()
end

local nextUpdate = 0
local function glowText(text, font, x, y, color, xalign, yalign, thickness, pulse)
	if (nextUpdate <= CurTime()) then
		nextUpdate = CurTime() + 0.5
	end

	local col = Color(color.r, color.g, color.b, color.a)
	local p = color.a / 255
	if (pulse == true) then
		local s = math.Clamp(math.abs(math.sin(RealTime() / 6 * 3)), 0, 1)
		col = Color(color.r * s, color.g * s, color.b * s, p * (s * 20))
	end

	surface.SetFont(font)
	local w, h = surface.GetTextSize(text)
	if (xalign == TEXT_ALIGN_CENTER) then
		x = x - w / 2
	end

	if (yalign == TEXT_ALIGN_CENTER) then
		y = y - h / 2
	end

	w = w + 2
	for i = 1, thickness do
		local thick = i
		col.a = (64 * ((1 / 10 * i))) * p
		draw.SimpleTextOutlined(text, font, x + w / 2, y + h / 2, Color(color.r, color.g, color.b, col.a / 10), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, thickness - thick, col)
	end
end

local cLerp = Color(255, 255, 255)
local tLerp = 0

hook.Add("PostDrawTranslucentRenderables", "TD:DrawTowerNames", function()
	
	local e = ents.FindByClass"tower_defense_enemy"
	if next(e) == nil then
		e = {}
		for k,v in pairs(ents.GetAll()) do
			if v.Base == "tower_defense_enemy" then
				e[#e+1] = v
			end
		end
	end
	if not (next(e) == nil) then
		
		for k,v in pairs(e) do
			if v:Health() > 1 then
				local mul = 3
				local eang = LocalPlayer():EyeAngles()
				local epos = v:GetPos() + Vector(0, 0, v:OBBMaxs().z + 6) + eang:Up()
				eang:RotateAroundAxis(eang:Forward(), 90)
				eang:RotateAroundAxis(eang:Right(), 90)
				
				cam.Start3D2D(epos, eang, .05)
				
				local hp = v:Health()
				local mhp = v:GetMaxHealth()
				local barScale = 200
				
				surface.SetDrawColor(0, 0, 0, 255)
				surface.DrawRect(-barScale, 0, barScale*2, 30)
				
				local c = Color((255 * (1 - hp / mhp)), (255 * (hp / mhp)), 0)
				surface.SetDrawColor(c.r, c.g, c.b, 255)
				surface.DrawRect(-barScale + mul, mul, (barScale * 2 - (mul * 2)) * (hp / mhp), 30 - mul * 2)
				
				cam.End3D2D()
			end
		end
	end
end)
hook.Add("HUDPaint", "yeet", function()
	-- cash
	draw.LinearGradient(0, ScrH() / 4, 350, 35, {
		{offset = 0 , color = Color(70, 70, 70)},
		{offset = .4, color = Color(70, 70, 70)},
		{offset = 1 , color = Color(70, 70, 70, 0)}
	}, true)
	
	do
		surface.SetFont( "Trebuchet24" )
		local t = "Cash: $" .. string.Comma(tostring(LocalPlayer():GetCash()))
		local tw, th = surface.GetTextSize( t )
		surface.SetTextColor( 255, 255, 255 )
		surface.SetTextPos( 15, (ScrH() / 4) + (35 / 2) - (th / 2) )
		surface.DrawText( t )
	end
	
	-- waves
	
	
	
	local w = GetGlobalInt("tower_defense.round", 1)
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
			
		glowText(t, "Trebuchet24",  ScrW() - 15 - tw - 1, (ScrH() / 4) + (35 / 2) - 1, cLerp, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, tLerp, true)
	end
end)