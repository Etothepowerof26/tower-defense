-- placing system
local color_white = Color(255,255,255)

include("pnl/DTowerPanel.lua")
include("pnl/DTowerUpgradePanel.lua")

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