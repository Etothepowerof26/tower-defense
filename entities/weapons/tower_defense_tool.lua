AddCSLuaFile()
SWEP.Author 			= "26"
SWEP.Base 				= "weapon_base"
SWEP.PrintName 			= "Tower Defense Tool"
SWEP.Purpose 			= "Does a lot of stuff."
SWEP.Instructions 		= "Left Click: Place the tower.\nRight Click: If you are facing a tower, it will show you it's settings.\nReload: Choose the tower you want to place."
SWEP.ViewModel 			= "models/weapons/v_physcannon.mdl"
SWEP.ViewModelFlip 		= false
SWEP.ViewModelFOV 		= 75
SWEP.WorldModel 		= "models/weapons/w_physics.mdl"
SWEP.UseHands 			= false
SWEP.HoldType 			= "physgun"
SWEP.Weight 			= 5
SWEP.AutoSwitchTo 		= true
SWEP.AutoSwitchFrom 	= false
SWEP.ShouldDropOnDie 	= false
SWEP.Slot 				= 0
SWEP.SlotPos 			= 1
SWEP.DrawAmmo 			= false
SWEP.DrawCrosshair 		= true

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

if CLIENT then


	local selmat = Material("SGM/playercircle")
	local function drawBubble(self, width, height, col, pos)
		local trace = {}
		trace.start = self:GetPos() + Vector(0, 0, 50)
		trace.endpos = trace.start + Vector(0, 0, -300)
		trace.filter = {self, unpack(player.GetAll())}
		
		local tr = util.TraceLine(trace)
		
		if not tr.HitWorld then
			tr.HitPos = self:GetPos()
		end
		
		render.SetMaterial(selmat)
		
		-- local a = math.abs(math.sin(self.SinAction / 25) * 100) + 50
		-- render.DrawQuadEasy(tr.HitPos + tr.HitNormal, tr.HitNormal, 20, 20, Color(100, 255, 100, a))
		render.DrawQuadEasy((not pos and tr.HitPos or pos) + tr.HitNormal, tr.HitNormal, width, height, col)
	end
		
	function SWEP:DrawHUD()
		local f = string.format
		if !self.Markup then
			
			self.Markup = markup.Parse(
				"<font=tdTitle><color=255,255,255>Press <color=255,0,0>" ..
				string.upper(input.LookupBinding("+reload", true)) ..
				"<color=255,255,255> to open your Tower menu.\n" ..

				"Look at a tower and rightclick to see it's menu."
			)

		end

		self.Markup:Draw(ScrW() / 2 - self.Markup:GetWidth() / 2, ScrH() - ScrH() / 4 - self.Markup:GetHeight() / 2)

		local _t = f("Selected tower: %s", tower_defense.CurrentlySelectedTower and tower_defense.CurrentlySelectedTower.name or "Nothing") or ""
		surface.SetFont("tdDesc")
		local tw, th = surface.GetTextSize(_t)
		surface.SetTextPos(ScrW() / 2 + 25, ScrH() / 2 - th / 2)
		surface.DrawText(_t)

		--[[local p = LocalPlayer()
		cam.Start3D()
			drawBubble(p, 50, 50, Color(255,0,0, 100), p:GetEyeTrace().HitPos)
		cam.End3D()]]

	end

end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end 
	if not self:CanPrimaryAttack() then return end

	if CLIENT then
		if not tower_defense or not tower_defense.CurrentlySelectedTower then
			return false
		end

		net.Start("tower_defense.BuyTower")
		net.WriteString(tower_defense.CurrentlySelectedTower.name)
		net.SendToServer()
	end

	self:SetNextPrimaryFire(CurTime() + 0.25)
	return false
end
	
function SWEP:SecondaryAttack()
	return false
end	

function SWEP:Reload()
	if not IsFirstTimePredicted() then return end
	local owner = self:GetOwner()

	if SERVER and IsValid(owner) then
		owner:BroadcastSound("UI/buttonrollover.wav")
		owner:ConCommand("td_menu")
	end

	return false
end