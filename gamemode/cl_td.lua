-- placing system
local color_white = Color(255,255,255)
local PANEL = {}
function PANEL:Init()
	self:SetSize(80,80)
	self.mpnl = vgui.Create("DModelPanel",self)
	self.mpnl:Dock(FILL)
	self.mpnl:SetFOV(45)
	
	function self.mpnl.DoClick(_mpnl)
		if not tower_defense then return end
		tower_defense.CurrentlySelectedTower = self.tower
	end
end
function PANEL:SetTower(tower_table)
	self.tower = tower_table

	local str = tower_table.name
	str = str .. "($" .. string.Comma(tostring(tower_table.price)) .. ")\n\n"
	str = str .. tower_table.desc
	self.mpnl:SetModel(tower_table.mdl)
	self.mpnl:SetTooltip(str)

	local mn, mx = self.mpnl.Entity:GetRenderBounds()
	local size = 0
	size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
	size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
	size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
	self.mpnl:SetCamPos(Vector(size, size, size))
	self.mpnl:SetLookAt((mn + mx) * 0.5)
end
function PANEL:Think()
	if tower_defense and tower_defense.CurrentlySelectedTower then
		if tower_defense.CurrentlySelectedTower.name == self.tower.name then
			self:SetBackgroundColor(Color(100,255,100))
		else
			self:SetBackgroundColor(color_white)
		end
	end
end
vgui.Register("DTowerPanel", PANEL, "DPanel")

module("tower_defense", package.seeall)

CurrentlySelectedTower = nil

function createMenuFrame()
	--if not frame or not IsValid(frame) then
		frame = vgui.Create("DFrame")
		frame:SetSize(ScrW() / 2, 300)
		frame:SetPos(ScrW() / 2 - (frame:GetWide() / 2), ScrH())
		frame:SetTitle("Towers")
		frame:SetDraggable(false)
		frame:Hide()
		
		function frame:Close()
			LocalPlayer():EmitSound("UI/buttonclickrelease.wav")
			self:SetMouseInputEnabled(false)
			self:SetKeyboardInputEnabled(false)

			self:MoveTo(ScrW() / 2 - (self:GetWide() / 2), ScrH(), 1, 0, .1, function()
				frame:Remove()
				frame = nil
			end)
			return
		end
		
		local scroll = vgui.Create("DScrollPanel", frame) -- Create the Scroll panel
		scroll:Dock(FILL)

		local List = vgui.Create("DIconLayout", scroll)
		List:Dock(FILL)
		List:SetSpaceY(5) -- Sets the space in between the panels on the Y Axis by 5
		List:SetSpaceX(5)

		for k,v in pairs(Towers) do
			local ListItem = List:Add("DTowerPanel")
			ListItem:SetTower(v)
		end
	--end
end
	
concommand.Add("td_menu", function()
	if frame or IsValid(frame) then
		return
	end

	createMenuFrame()
	if frame then
		frame:Show()
		frame:MakePopup()
		frame:MoveTo(ScrW() / 2 - (frame:GetWide() / 2), ScrH() - frame:GetTall(), 1, 0, .1, function()end)
	end
end)