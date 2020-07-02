TD.CurrentTower = ""

local function createfont(fontname, font, size, weight)
	surface.CreateFont(fontname, {
		font = font,
		size = size,
		weight = weight,
		extended = false
	})
end

for i = 16, 32 do
	createfont("Verdana"..i, "Verdana", i, 500)
end

-- VGUI
local function CreateTowerGUI()
	if not IsValid(TD.TDFrame) then
		TD.TDFrame = vgui.Create("DFrame")
		function TD.TDFrame:SetTitleEx(t)
			if(not self.tdata)then
				self.tdata={title=t}
				self:SetTitle("")
			end
		end
		
		TD.TDFrame:SetSize(600, 340)
		TD.TDFrame:SetTitleEx("Tower Defense Tool")
		TD.TDFrame:Center()
		TD.TDFrame:MakePopup()
		function TD.TDFrame:Paint(w,h)
			surface.SetDrawColor(0,0,0,255)
			surface.DrawRect(0,0,w,h)
			
			surface.SetTextColor(255,255,255,255)
			surface.SetFont("Verdana24")
			surface.SetTextPos(2,2)
			surface.DrawText(self.tdata.title)
		end
		function TD.TDFrame:OnClose()
			gui.EnableScreenClicker(false)
			self:Hide()
		end
		
		local scroller = vgui.Create("DHorizontalScroller", TD.TDFrame)
		scroller:Dock(FILL)
		for i,v in pairs(TD.TowerTable) do
			local icnpnl = vgui.Create("DPanel",scroller)
			icnpnl:SetSize(200,340)
			
			local spawnicon = vgui.Create("SpawnIcon",icnpnl)
			spawnicon:SetPos(5,5)
			spawnicon:SetSize(190,190)
			spawnicon:SetModel(v.Model)
			spawnicon:SetColor(v.Color)
			spawnicon:SetToolTip("")
			
			local namelabel = vgui.Create("DLabel",icnpnl)
			namelabel:SetPos(5,205)
			namelabel:SetSize(190,25)
			namelabel:SetFont("Verdana18")
			namelabel:SetTextColor(Color(0,0,0))
			namelabel:SetText(v.PrintName)
			
			local pricelabel = vgui.Create("DLabel",icnpnl)
			pricelabel:SetPos(5,230)
			pricelabel:SetSize(190,25)
			pricelabel:SetFont("Verdana18")
			pricelabel:SetTextColor(Color(0,255,0))
			pricelabel:SetText("$" .. string.Comma(tostring(v.Price)))
			
			local selectbutton = vgui.Create("DButton",icnpnl)
			selectbutton:SetPos(5,260)
			selectbutton:SetSize(190,35)
			selectbutton:SetFont("Verdana18")
			selectbutton:SetText("Select Tower")
			function selectbutton:Paint(w,h)
				if(TD.CurrentTower==i)then
					surface.SetDrawColor(0,255,0,255)
				else
					surface.SetDrawColor(255,255,255,255)
				end
				surface.DrawRect(0,0,w,h)
			end
			
			function selectbutton:DoClick()
				TD.CurrentTower=i
			end
			scroller:AddPanel(icnpnl)
		end
	else
		TD.TDFrame:Show()
	end
end

net.Receive("TD:SpawnTowerGUI", CreateTowerGUI)

-- nametags for towers
hook.Add("PostDrawTranslucentRenderables", "TD:DrawTowerNames", function()
	local e = ents.FindByClass"td_enemy"
	if not (next(e) == nil) then
		
		for k,v in pairs(e) do
			if v:Health() > 1 then
				local mul=3
				local eang = LocalPlayer():EyeAngles()
				local epos = v:GetPos() + Vector(0, 0, v:OBBMaxs().z + 6) + eang:Up()
				eang:RotateAroundAxis(eang:Forward(), 90)
				eang:RotateAroundAxis(eang:Right(), 90)
				
				cam.Start3D2D(epos, eang, .05)
				
				surface.SetDrawColor(0, 0, 0, 255)
				local hp = v:Health()
				local mhp = v:GetMaxHealth()
				surface.DrawRect(-mhp*mul/2,0,mhp*mul,30)
				
				local c = Color((255 * (1 - hp / mhp)), (255 * (hp / mhp)), 0)
				surface.SetDrawColor(c.r, c.g, c.b, 255)
				
				local s = (-mhp*mul)/2 + 3
				local sy = 3
				local e = ((mhp*mul) * ((hp - 6) / mhp))
				local ey = 24
				surface.DrawRect(s, sy, e, ey)
				
				cam.End3D2D()
			end
		end
	end
end)
-- healthbars for enemies
