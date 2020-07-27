AddCSLuaFile()

ENT.PrintName = "Tower Defense Enemy"
ENT.Author    = "26"
ENT.Base      = "base_nextbot"
ENT.Type      = "nextbot"

if SERVER then
	local R = 50^2
	function ENT:SetupDataTables()
		self:NetworkVar("String", 0, "LastChosenPoint")
	end
	
	function ENT:Initialize()
		self:SetModel("models/headcrabclassic.mdl")
		self:SetModelScale(1)
		self:SetMaxHealth(10)
		self:SetHealth(10)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetLastChosenPoint("1")

		--self:SetBodygroup(0, 1)

		--PrintTable(self:GetBodyGroups())
	end
	
	function ENT:FindPoint()
		local nextPoint = tower_defense.mapTable[game.GetMap()][tonumber(self:GetLastChosenPoint()) + 1]
		local point = Vector()
		if istable(nextPoint) then
			point = (table.Random(nextPoint))
		else
			point = nextPoint
		end
			
		self.point = point
	end
	
	function ENT:Think()
		if not self.point then
			self:FindPoint()
			return
		end
		
		if self:GetPos():DistToSqr(self.point) <= R then
			self:SetLastChosenPoint(self:GetLastChosenPoint() + 1)
			self:FindPoint()
		end
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
			
			self:StartActivity(ACT_RUN)
			self.loco:FaceTowards(point)
			self.loco:SetDesiredSpeed(75)
			self:MoveToPos(point)
			
			coroutine.wait(.1)
			coroutine.yield()
		end
	end

	function ENT:OnInjured(dmginfo)
		local atk = dmginfo:GetAttacker()
		local inf = dmginfo:GetInflictor()

		if IsValid(inf) then
			local owner = inf:GetPlayerOwner()
			if IsValid(owner) then
				owner:SetNWInt("tower_defense.cash", owner:GetNWInt("tower_defense.cash") + 2)
			end
		end
		print(dmginfo:GetAttacker(), dmginfo:GetInflictor())
	end
	
	function ENT:OnKilled(dmginfo)
		local atk = dmginfo:GetAttacker()
		local inf = dmginfo:GetInflictor()

		self:BecomeRagdoll(dmginfo)
		if tower_defense and tower_defense.spawned_enemies then
			tower_defense.spawned_enemies[self] = false
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end