AddCSLuaFile()

ENT.PrintName = "Fast Headcrab"
ENT.Author    = "26"
ENT.Base      = "tower_defense_enemy"
ENT.Type      = "nextbot"

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/zombie/classic.mdl")
		self:SetModelScale(1)
		self:SetMaxHealth(25)
		self:SetHealth(25)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetLastChosenPoint("1")

		--self:SetBodygroup(0, 1)

		--PrintTable(self:GetBodyGroups())
	end
	
	function ENT:RunBehaviour()
		while true do
			local point = self.point
			if not point then
				hook.Run("OnEnemyGotThroughExit", self)
				timer.Simple(0, function()
					--tower_defense.spawned_enemies[self] = false
					self:Remove()
				end)
				return
			end
			
			self:StartActivity(ACT_WALK)
			self.loco:FaceTowards(point)
			self.loco:SetDesiredSpeed(50)
			self:MoveToPos(point)
			
			coroutine.wait(.1)
			coroutine.yield()
		end
	end
end