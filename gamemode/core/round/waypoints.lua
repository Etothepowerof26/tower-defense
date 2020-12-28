WAYPOINTS = WAYPOINTS || {}


if SERVER then

	--[[
	
	-- isEndingPoint
	file.Write("WAYPOINTTEST.txt", util.TableToJSON({
		["_1"] = {
			pos = Vector(-160,-416,256),
			isStartingPoint = true,
			nextWaypoint = 2
		},
		["_2"] = {
			pos = Vector(414,-416,256),
			nextWaypoint = 3
		},
		["_3"] = {
			pos = Vector(608,-480,256),
			nextWaypoint = 4
		},
		["_4"] = {
			pos = Vector(672,-608,256),
			nextWaypoint = 5
		},
		["_5"] = {
			pos = Vector(412,-812,256),
			nextWaypoint = 6
		},
		["_6"] = {
			pos = Vector(-285,-812,256),
			nextWaypoint = 7
		},
		["_7"] = {
			pos = Vector(-396,-702,256),
			nextWaypoint = 8
		},
		["_8"] = {
			pos = Vector(-396,-258,256),
			nextWaypoint = 9
		},
		["_9"] = {
			pos = Vector(-515,-150,256),
			nextWaypoint = 10
		},
		["_10"] = {
			pos = Vector(-802,-150,256),
			nextWaypoint = 11
		},
		["_11"] = {
			pos = Vector(-912,-264,256),
			nextWaypoint = { 12, 13 }
		},
		["_12"] = {
			pos = Vector(-832,-448,256),
			nextWaypoint = 15
		},
		["_13"] = {
			pos = Vector(-985,-448,256),
			nextWaypoint = 14
		},
		["_14"] = {
			pos = Vector(-967,-594,256),
			nextWaypoint = 15
		},
		["_15"] = {
			pos = Vector(-832,-835,256),
			nextWaypoint = 16
		},
		["_16"] = {
			pos = Vector(-907,-928,256),
			nextWaypoint = 17
		},
		["_17"] = {
			pos = Vector(-967,-928,256),
			isEndingPoint = true
		}
	}, true))
]]

end

function WAYPOINTS.FormatIDString(id)
	return "_" .. tostring(id)
end

if SERVER then

	AddCSLuaFile("waypoint_admin.lua")
	AddCSLuaFile("waypoint_arrowbuilder.lua")

	util.AddNetworkString("TD_WaypointRequest")
	file.CreateDir('tdwaypoints')
	WAYPOINTS.MapWaypoints = WAYPOINTS.MapWaypoints || {}

	PrintTable(WAYPOINTS.MapWaypoints)

	function WAYPOINTS.GetStored(map)
		if not map then
			map = game.GetMap()
		end

		local fname = "tdwaypoints/" .. game.GetMap() .. ".txt"
		local exists = file.Exists(fname, "DATA")

		if not exists then
			return false, nil
		end

		local contents = file.Read(fname, DATA)

		if not contents then
			return false, {}
		end

		return true, util.JSONToTable(contents)
	end
 
	function WAYPOINTS.Init()
		local ok, err = WAYPOINTS.GetStored()
		if not ok then
			Error("[td] Error reading waypoints for current map. Recreate them or something went really bad!\n")
			return
		end

		WAYPOINTS.MapWaypoints = err

		local color_white = Color(255, 255, 255)
		local color_green = Color(0, 255, 0)

		MsgC(color_green, ">> ", color_white, "Loaded ", color_green, table.Count(WAYPOINTS.MapWaypoints), color_white, " waypoints for ", game.GetMap())
		print() 
	end

	local cached_spawns = {}
	function WAYPOINTS.GetSpawns()
		if next(cached_spawns) == nil then
			for k,v in pairs(WAYPOINTS.MapWaypoints) do
				if v.isStartingPoint then
					table.insert(cached_spawns, v)
				end
			end
		end
		return cached_spawns
	end


	local RECEIVED = setmetatable({}, {__mode = "k"})
	net.Receive("TD_WaypointRequest", function(len, ply)
		if RECEIVED[ply:AccountID()] then
			return
		end

		RECEIVED[ply:AccountID()] = true
		
		local nowayp = next(WAYPOINTS.MapWaypoints) == nil

		net.Start("TD_WaypointRequest")
			net.WriteBit(nowayp and 0 or 1)
			if not nowayp then
				net.WriteUInt(table.Count(WAYPOINTS.MapWaypoints), 8)
				for k,v in pairs(WAYPOINTS.MapWaypoints) do
					net.WriteString(k)
					net.WriteTable(v)
				end
			end
		net.Send(ply)
	end)

end

if CLIENT then

	include("waypoint_admin.lua")
	include("waypoint_arrowbuilder.lua")

	function WAYPOINTS.Init()
		return
	end

	WAYPOINTS.OurWaypoints = nil
	WAYPOINTS.RequestedSVWaypoints = false
	function WAYPOINTS.Request()
		if WAYPOINTS.RequestedSVWaypoints then
			return
		end

		net.Start("TD_WaypointRequest")
		net.SendToServer()
	end

	net.Receive("TD_WaypointRequest", function()
		local empty = net.ReadBit() == 0
		if empty then
			print("RIP no waypoints :(")
			return
		end

		WAYPOINTS.OurWaypoints = {}

		local amount = net.ReadUInt(8)
		print(amount)

		for i = 1, amount do
			WAYPOINTS.OurWaypoints[net.ReadString()] = net.ReadTable()
		end
	end)

	// hook.Add("something", "WAYPOINTS", WAYPOINTS.Render)
	local color_red = Color(255, 0, 0)
	local color_green = Color(0, 255, 0)

	function WAYPOINTS.Render()
		--print("drawing waypoints!")
		-- local i = 0
		local wp = WAYPOINTS.OurWaypoints
		if not wp or next(wp) == nil then
			return
		end
		
		render.SetColorMaterial()
		for k,v in pairs(wp) do
			if v.isStartingPoint then
				local the_next = wp[WAYPOINTS.FormatIDString(v.nextWaypoint)]

				local ang = (the_next.pos - v.pos):Angle()
				local total_length = 50 -- units

				if render.DrawArrow3D then
					local galpha = math.abs(math.sin(CurTime() * 2) * 255)
					
					render.DrawArrow3D(total_length, 0.5, total_length / 2, v.pos, ang, Color(0, 255, 0, galpha), 10)
				end
--render.DrawArrow3D = function(length, relative_arrowhead_start, width, pos, ang, color, height)

				-- render.DrawLine( v.pos, , color_green )
			else
				-- isStartingPoint
				render.DrawSphere(v.pos, 10, 10, 10, color_white)
			end
		end
	end

	concommand.Add("dowaypoint",function()
		WAYPOINTS.Request()
		timer.Simple(0.5, function()
		hook.Add("PostDrawOpaqueRenderables", "draw", WAYPOINTS.Render)
		end)
	end)
end
