
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

function draw.GlowText(text, font, x, y, color, xalign, yalign, thickness, pulse)
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