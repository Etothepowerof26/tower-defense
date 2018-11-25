AddCSLuaFile()
SWEP.Author = "26 E's"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Tower Defense Tool"
SWEP.Instructions = "Reload: Choose the tower you want to place.\n\nLeft Click: Place the tower.\n\nRight Click: If you are facing a tower, it will show you it's settings."
SWEP.ViewModel = "models/weapons/v_physcannon.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 75
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.UseHands = false
SWEP.HoldType = "physgun"
SWEP.Weight = 5
SWEP.AutoSwitchTo      = true
SWEP.AutoSwitchFrom    = false
SWEP.ShouldDropOnDie   = false
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	if(not IsFirstTimePredicted())then return end
	if(!self:CanPrimaryAttack())then return end
	if(SERVER)then
		return false
	else
		net.Start("TD:BuyTower")
		net.WriteString(TD.CurrentTower)
		net.SendToServer()
		return false
	end
end
	
function SWEP:SecondaryAttack()
	if(SERVER)then
		
	else
		return false
	end
end	

if(SERVER)then
	function SWEP:Reload()
		local Owner = self:GetOwner()
		net.Start("TD:SpawnTowerGUI")
		net.Send(Owner)
		return false
	end
else

end