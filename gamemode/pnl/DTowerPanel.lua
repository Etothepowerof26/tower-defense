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