
local function arrow_hash(length, relative_arrowhead_start, width, pos)
	return util.CRC(tostring(length) .. tostring(relative_arrowhead_start) .. tostring(width) .. tostring(pos))
end

--[[
	Builds a set of values for arrowhead vertices.
	length = the length of the arrow
	relative_arrowhead_start = a value 0-1 that is the fraction on where the arrowhead should start
	( 0.5 : 50%, etc )
	width = the width of the arrow
	pos = the start pos of the arrow. The butt of the arrow starts here.
	ang = the angle where the arrow should face.
]]
local cached_arrows = setmetatable({}, { __mode = "k" })
render.BuildArrow = function(length, relative_arrowhead_start, width, pos, ang)
	local hash = arrow_hash(length, relative_arrowhead_start, width, pos)
	local ourcache = cached_arrows[hash]
	if ourcache then
		return ourcache
	end

	local s1, s2, s3, s4, s5, s6, e1, e2, e3, e4, e5

	local rs = length * relative_arrowhead_start
	local rw = width / 4

	s1 = pos - ang:Right() * rw
	s2 = pos + ang:Right() * rw

	e1 = s1 + ang:Forward() * rs
	e2 = s2 + ang:Forward() * rs

	s3 = e1
	s4 = e2

	e3 = s3 - ang:Right() * rw
	e4 = s4 + ang:Right() * rw

	s5 = e3
	s6 = e4

	e5 = pos + ang:Forward() * length

	local t = { s1, s2, s3, s4, s5, s6, e1, e2, e3, e4, e5 }
	cached_arrows[hash] = t

	PrintTable(t)
	
	return t
end

local function render_drawArrowEx(color, s1, s2, s3, s4, s5, s6, e1, e2, e3, e4, e5)
	render.DrawLine( s1, s2, color )

	render.DrawLine( s1, e1, color )
	render.DrawLine( s2, e2, color )

	render.DrawLine( s3, e3, color )
	render.DrawLine( s4, e4, color )

	render.DrawLine( s5, e5, color )
	render.DrawLine( s6, e5, color )
end

render.DrawArrow = function(length, relative_arrowhead_start, width, pos, ang, color)
	-- hopefully the vertices are in the right spot, so lets unpack them.
	local build = render.BuildArrow(length, relative_arrowhead_start, width, pos, ang)
	render_drawArrowEx(color, unpack(build))
end


render.DrawArrow3D = function(length, relative_arrowhead_start, width, pos, ang, color, height)
	-- build an arrow with a higher position
	local arrow1_verts = render.BuildArrow(length, relative_arrowhead_start, width, pos, ang)
	local arrow2_verts = render.BuildArrow(length, relative_arrowhead_start, width, pos + Vector(0, 0, height), ang)

	render_drawArrowEx(color, unpack(arrow1_verts))
	render_drawArrowEx(color, unpack(arrow2_verts))

	for i = 1, #arrow1_verts do
		local vp = arrow1_verts[i]
		local vp2 = arrow2_verts[i]
		render.DrawLine( vp, vp2, color )
	end
end
