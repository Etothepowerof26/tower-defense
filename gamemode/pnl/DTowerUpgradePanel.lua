/*
using https://github.com/Earu/Quest
modifierd frame
*/
local tag = 'td'

local cached = {}
local function GetTowerBasedOnClass(class)
	if cached[class] then
		return unpack(cached[class])
	end

	for k,v in pairs(tower_defense.Towers) do
		if v.ent == class then
			cached[class] = {k, v}
			return unpack(cached[class])
		end
	end
	return nil
end

surface.CreateFont(tag .. "Title", {
	font = "Roboto Bk",
	size = 26,
	weight = 800
})

surface.CreateFont(tag .. "Desc", {
	font = "Roboto",
	size = 20,
	weight = 500
})

local shadowDist = 3
local WordWrap = function(str, maxW)
	local strSep = str:Split(" ")
	local buf = ""
	local wBuf = 0
	for k, word in next, strSep do
		local txtW, txtH = surface.GetTextSize(word .. (k == #strSep and "" or " "))
		wBuf = wBuf + txtW
		if wBuf > maxW then
			buf = buf .. "\n"
			wBuf = 0
		end
		buf = buf .. word .. " "
	end

	return buf
end
local animTime = 5

local PANEL = {}
PANEL.Width = 500
PANEL.Height = 300
PANEL.OnGoing = false
function PANEL:Init()
	self:SetPos(0, 0)
	self:SetSize(0, 0)

	self.Alpha = 0
	self:NoClipping(false)

	self.Buttons = vgui.Create("EditablePanel", self)
	self.Buttons:Dock(BOTTOM)
	self.Buttons:SetTall(48)

	self.Upgrade = vgui.Create("DButton", self.Buttons)
	self.Upgrade:Dock(LEFT)
	self.Upgrade:SetFont(tag .. "Title")
	self.Upgrade:SetText("Upgrade")
	self.Upgrade.Paint = function(s, w, h)
		if s:IsHovered() then
			surface.SetDrawColor(188, 57, 240)
			surface.DrawOutlinedRect(5,5,w-10,h-10)
			surface.SetDrawColor(188, 57, 240,20)
			surface.DrawRect(5,5,w-10,h-10)
			s:SetTextColor(Color(188, 57, 240))
		else
			s:SetTextColor(Color(200, 200, 200, 250))
		end
	end
	self.Upgrade.DoClick = function()
		self:Close()
	end

	self.Sell = vgui.Create("DButton", self.Buttons)
	self.Sell:Dock(LEFT)
	self.Sell:SetFont(tag .. "Title")
	self.Sell:SetText("Sell")
	self.Sell.Paint = function(s, w, h)
		if s:IsHovered() then
			surface.SetDrawColor(188, 57, 240)
			surface.DrawOutlinedRect(5,5,w-10,h-10)
			surface.SetDrawColor(188, 57, 250,20)
			surface.DrawRect(5,5,w-10,h-10)
			s:SetTextColor(Color(188, 57, 240))
		else
			s:SetTextColor(Color(200, 200, 200, 250))
		end
	end
	self.Sell.DoClick = function()
		self:Close()
	end

	
	self.Exit = vgui.Create("DButton", self.Buttons)
	self.Exit:Dock(RIGHT)
	self.Exit:SetFont(tag .. "Title")
	self.Exit:SetText("Exit")
	self.Exit.Paint = function(s, w, h)
		if s:IsHovered() then
			surface.SetDrawColor(188, 57, 240)
			surface.DrawOutlinedRect(5,5,w-10,h-10)
			surface.SetDrawColor(188, 57, 250,20)
			surface.DrawRect(5,5,w-10,h-10)
			s:SetTextColor(Color(188, 57, 240))
		else
			s:SetTextColor(Color(200, 200, 200, 250))
		end
	end
	self.Exit.DoClick = function()
		self:Close()
	end
end

function PANEL:PerformLayout()
	self.Upgrade:SetWide(self:GetWide() * 0.333)
	self.Exit:SetWide(self:GetWide() * 0.333)
	self.Sell:SetWide(self:GetWide() * 0.333)

	self.TowerInfo = { GetTowerBasedOnClass(self.NPC:GetClass()) }
	PrintTable(self.TowerInfo)
end

function PANEL:Paint(w,h)
	if not IsValid(self.NPC) then return end

	DisableClipping(true)
	surface.DisableClipping(true)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
		surface.SetDrawColor(100,100,100,200)
		surface.DrawOutlinedRect(0,0,w,h)

		-- local x, y = self:GetPos()
		local triW, triH = 24, 16
		local tri = {
			{
				x = w + 5,
				y = h * 0.5 - triH * 0.5
			},
			{
				x = w + triW + 5,
				y = h * 0.5
			},
			{
				x = w + 5,
				y = h * 0.5 + triH * 0.5
			}
		}

		draw.NoTexture()
		surface.SetDrawColor(0,0,0,200)
		surface.DrawPoly(tri)
		surface.SetDrawColor(100, 100, 100, 200)
		surface.DrawLine(tri[1].x,tri[1].y,tri[2].x,tri[2].y)
		surface.DrawLine(tri[2].x,tri[2].y,tri[3].x,tri[3].y)
		surface.DrawLine(tri[3].x,tri[3].y,tri[1].x,tri[1].y)
	surface.DisableClipping(false)
	DisableClipping(false)

	local x, y = 8, 12

	surface.SetFont(tag .. "Title")
	local txt = WordWrap(self.TowerInfo[1], self:GetWide() - x * 2)
	local txtW, txtH = surface.GetTextSize(txt)
	draw.DrawText(txt, tag .. "Title", x, y, Color(242, 150, 58))

	y = y + txtH + 8
	surface.SetFont(tag .. "Desc")
	local txt = WordWrap(self.TowerInfo[2].desc, self:GetWide() - x * 2)
	local txtW, txtH = surface.GetTextSize(txt)
	draw.DrawText(txt, tag .. "Desc", x, y, Color(225, 225, 225, 255))

end

function PANEL:Think()
	if not IsValid(self.NPC) then return end

	-- Reinventing the wheel because garry animations suck dick
	if self.Opening and not self.Closing then
		self:SetWide(Lerp(FrameTime() * animTime, self:GetWide(), self.Width))
		self:SetTall(Lerp(FrameTime() * animTime, self:GetTall(), self.Height))
		self.Alpha = Lerp(FrameTime() * animTime, self.Alpha, 1)
	elseif self.Closing then
		self:SetWide(Lerp(FrameTime() * animTime, self:GetWide(), 0))
		self:SetTall(Lerp(FrameTime() * animTime, self:GetTall(), 0))
		self.Alpha = Lerp(FrameTime() * animTime, self.Alpha, 0)

		if self.Alpha < 0.05 then
			self:Remove()
		end
	end

	local eyes = {Pos=self.NPC:GetPos(),Ang=self.NPC:GetAngles()}
	local pos = eyes.Pos - eyes.Ang:Right() * -10
	local scrPos = pos:ToScreen()
	local x, y = scrPos.x, scrPos.y
	x = x - self:GetWide() - 16
	y = y - self:GetTall() * 0.5

	self:SetPos(x, y)
end
 
function PANEL:Setup(npc)
	self.NPC = npc
	self:Open()
end

function PANEL:Open()
	-- self:MakePopup()
	gui.EnableScreenClicker(true)
	self:SetKeyboardInputEnabled(true)
	self:SetMouseInputEnabled(true)
	self.Opening = true
end

function PANEL:Close()
	gui.EnableScreenClicker(false)
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
	self.Closing = true
end

vgui.Register("DTowerUpgradePanel", PANEL, "EditablePanel")






concommand.Add("upograde",function()
	local p=vgui.Create('DTowerUpgradePanel')
	p:Setup(ents.FindByClass("tower_defense_sniper_tower")[1])
	p:Open()
end)