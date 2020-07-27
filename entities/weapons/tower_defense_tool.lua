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

function SWEP:DrawHUD()

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