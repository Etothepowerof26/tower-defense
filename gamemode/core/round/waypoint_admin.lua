// Admins create waypoints here
	local function cp(...)
		LocalPlayer():ChatPrint(...)
	end

	function captureMouseClickput(cb,gridsnap)
		if not gridsnap then
			gridsnap=false
		end
		local function roundfunc(a)
			return math.Round(a)
		end
		local thepos=Vector(0,0,0)
		hook.Add("HUDPaint","waiting",function()
			surface.SetFont("BudgetLabel")
			local pos = tostring(thepos)
			local tw,th = surface.GetTextSize(pos)
			surface.SetTextPos(ScrW()/2-(tw/2), ScrH()/4-(th/2))
			surface.SetTextColor(255, 255, 255)
			surface.DrawText(pos)
		end)
		hook.Add("PostDrawOpaqueRenderables","waiting",function()
			local pos = thepos
			render.SetColorMaterial()
			render.DrawBox(pos, Angle(), Vector(-6,-6,-6), Vector(6,6,6), HSVToColor(CurTime()%180,1,1))
		end)
		hook.Add("Think","waiting",function()
			thepos = LocalPlayer():GetEyeTrace().HitPos
			if gridsnap and input.IsKeyDown(KEY_LALT) then
				thepos.x = roundfunc(thepos.x)
				thepos.y = roundfunc(thepos.y)
				thepos.z = roundfunc(thepos.z)
			end
			local is=input.IsMouseDown(107)
			if is then
				hook.Remove("Think","waiting")
				hook.Remove("PostDrawOpaqueRenderables","waiting")
				hook.Remove("HUDPaint","waiting")
				cp("DETECTED")
				local there = thepos
				cp(tostring(there))
				cb(there)
				return
			end
		end)
	end

concommand.Add("td_admin_createwaypoints", function()
	--if not LocalPlayer():IsSuperAdmin() then return end
	
	cp("Now creating waypoints.")

	local function captureChatInput(prompt, cb)
		if prompt then cp(prompt) end
		cp("Enter your choice in chat...")
		hook.Add("OnPlayerChat", "chatInput", function(ply,txt)
			if ply != LocalPlayer() then return end
			cb(txt)
			hook.Remove("OnPlayerChat", "chatInput")
			return true
		end)
	end

	cp("Choices:")
	local choices = {
		"Create new checkpoint",
		"Select checkpoint (nearest to crosshair)",
		"Edit checkpoint",
		"Save",
		"Load",
		"Copy loaded waypoint into clipboard",
		"Exit"
	}
	local choicecallbacks = {}
	--for i = 1, #choices do
	--	cp(tostring(i)..": "..choices[i])
	--end

	local function mainloop()
		cp("What would you like to do?")
		for i = 1, #choices do
			cp(tostring(i)..": "..choices[i])
		end
		captureChatInput(nil, function(inp)
			local choice = tonumber(string.Trim(inp))
			-- stuff here
			local callback = choicecallbacks[choice]
			if callback and isfunction(callback) then
				callback()
			end
		end)
	end

	local OUR_CHECKPOINTS = {}
	local id=0
	local selected_idx=-1

	hook.Add("PostDrawOpaqueRenderables","drawallcps",function()
		render.SetColorMaterial()
		for i = 1, #OUR_CHECKPOINTS do
			local cp = OUR_CHECKPOINTS[i]
			local col = Color(255, 255, 255)

			-- Get the game's camera angles
			local angle = EyeAngles()
			angle = Angle( 0, angle.y, 0 )
			angle.y = angle.y + math.sin( CurTime() ) * 10
			angle:RotateAroundAxis( angle:Up(), -90 )
			angle:RotateAroundAxis( angle:Forward(), 90 )

			local trace = LocalPlayer():GetEyeTrace()
			local pos = cp.pos
			pos = pos + Vector( 0, 0, math.cos( CurTime() / 2 ) + 20 )
			cam.Start3D2D( pos, angle, 0.4 )

				local text = "Waypoint ID:" .. tostring(cp.id)
				if cp.type == "start" then
					col = Color(0, 255, 0)
					text = "Enemy Spawn (ID:" .. tostring(cp.id) .. ")"
				elseif cp.type == "end" then
					col = Color(255, 0, 0)
					text = "Enemy End (ID:" .. tostring(cp.id) .. ")"
				end

				surface.SetFont( "Default" )
				local tW, tH = surface.GetTextSize( text )
				local pad = 5
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( -tW / 2 - pad, -pad, tW + pad * 2, tH + pad * 2 )
				draw.SimpleText( text, "Default", -tW / 2, 0, color_white )
			cam.End3D2D()

			render.DrawBox(cp.pos, Angle(), Vector(-6,-6,-6), Vector(6,6,6), col)
		end

		
		--[[]]
	end)
	-- create
	choicecallbacks[1] = function()
		cp("Wherever you click a checkpoint will be created. You will be sent into edit mode automatically.")
		cp("Hold LALT to use grid snapping.")
		captureMouseClickput(function(pos)
			id=id+1
			local cp_datatype = {
				type="link",
				pos=pos,
				linksto=nil,
				id=id
			}
			selected_idx=#OUR_CHECKPOINTS+1
			OUR_CHECKPOINTS[selected_idx]=cp_datatype
			PrintTable(OUR_CHECKPOINTS)
			choicecallbacks[3]()
		end, true)
	end
	-- select
	choicecallbacks[2] = function()
		cp("I'll try to find the nearest checkpoint to your mouse cursor wherever you click!")
		hook.Add("PostDrawOpaqueRenderables","finder",function()
			local thepos = LocalPlayer():GetEyeTrace().HitPos
			render.SetColorMaterial()
			local nearest = {dist = 999999999, cp = {}}
			for i = 1, #OUR_CHECKPOINTS do
				local check = OUR_CHECKPOINTS[i]
				local dist = check.pos:DistToSqr(thepos)
				if dist < nearest.dist then
					nearest.dist = dist
					nearest.cp = check
				end
			end
			render.DrawLine( thepos, nearest.cp.pos, Color( 255, 255, 255 ) )
		end)
		captureMouseClickput(function(pos)
			hook.Remove("PostDrawOpaqueRenderables","finder")
			if next(OUR_CHECKPOINTS)==nil then
				cp("No checkpoints found...")
				timer.Simple(1,mainloop)
				return
			end
			local nearest = {dist = 999999999, cp = {}}
			for i = 1, #OUR_CHECKPOINTS do
				local check = OUR_CHECKPOINTS[i]
				local dist = check.pos:DistToSqr(pos)
				if dist < nearest.dist then
					nearest.dist = dist
					nearest.cp = check
				end
			end
			selected_idx = nearest.cp.id
			cp("Found checkpoint id: "..tostring(nearest.cp.id))
			choicecallbacks[3]()
		end)
	end
	-- edit
	choicecallbacks[3] = function()
		if selected_idx == -1 then
			cp("Nothing is selected you dingus")
			timer.Simple(1, mainloop)
			return
		end
		cp("What would you like to do to this checkpoint?")
		local choice_edit={
			"Mark as starting area",
			"Mark as ending area",
			"Set next in line",
			"Move",
			"Delete",
			"Do nothing",
		}
		local choice_edit_cb={
			--mark as starting
			function()
				local the = OUR_CHECKPOINTS[selected_idx]
				the.type = "start"
				cp("Marked checkpoint " .. tostring(selected_idx) .. " as the start.")
			end,
			--mark as ending
			function()
				local the = OUR_CHECKPOINTS[selected_idx]
				the.type = "end"
				cp("Marked checkpoint " .. tostring(selected_idx) .. " as the start.")
			end,
			--set next in line
			function()
				cp("Not implemented")
			end,
			--move
			function()
				cp("Click where you want this checkpoint to be")
				captureMouseClickput(function(pos)
					local the = OUR_CHECKPOINTS[selected_idx]
					the.pos = pos
				end)
			end,
			--delete
			function()
				table.remove(OUR_CHECKPOINTS, selected_idx)
				selected_idx = -1
			end,
			function()end
		}
		for i = 1, #choice_edit do
			cp(tostring(i)..": "..choice_edit[i])
		end
		captureChatInput(nil, function(inp)
			local choice = tonumber(string.Trim(inp))
			-- stuff here
			local callback = choice_edit_cb[choice]
			if callback and isfunction(callback) then
				callback()
			end
			selected_idx = -1
			timer.Simple(1, mainloop)
		end)
	end
	-- save
	choicecallbacks[4] = function()
	end
	-- load
	choicecallbacks[5] = function()
	end
	-- copy to clipboard
	choicecallbacks[6] = function()
	end
	-- exit
	choicecallbacks[7] = function()
		hook.Remove("PostDrawOpaqueRenderables","drawallcps")
		hook.Remove("Think","waiting")
		hook.Remove("PostDrawOpaqueRenderables","waiting")
		hook.Remove("HUDPaint","waiting")
		cp("Exited")
	end

	mainloop()
end)