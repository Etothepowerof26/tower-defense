AddCSLuaFile()

ENT.PrintName = "Sniper Tower"
ENT.Author = "26"
ENT.Base = "tower_defense_tower"

function ENT:DefaultVars()
	-- 1 : highest health
	-- 2 : lowest health
	-- 3 : nearest
	-- 4 : farthest
	-- 5 : first
	self:SetTargetMode(1)
	
	self:SetEnemiesKilled(0)
	self:SetTargetDamage(7)
	self:SetTargetRange(700^2)
	self:SetStartTrace(Vector(0, 0, 32))
end

function ENT:Initialize()
	self:SetModel("models/Cranes/crane_frame.mdl")
	self:SetModelScale(0.05)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	if SERVER then

		self:DropToFloor()
		self:DefaultVars()

		local shooter = ents.Create("shooter")
		shooter:Spawn()
		self.shooter = shooter
		self.shooter.tower = self

		--[[timer.Simple(0.01, function()
		local shooter = ents.Create("shooter")
		print(self:GetPos(), self:GetStartTrace())
		shooter:Spawn()
		-- shooter:SetPos(self:GetPos() + self:GetStartTrace())
		player.GetAll()[1]:SetPos(shooter:GetPos())
		print(shooter:GetPos())
		self.shooter = shooter
		end)]]
	end
end

// TODO: dont override think, thats terrible.
if SERVER then
		
	function ENT:Think()
		if not self.LastShoot then
			self:SetPos(self:GetPos()-Vector(0,0,10))
			self.shooter:SetPos(self:GetPos() + self:GetStartTrace())
			-- player.GetAll()[1]:SetPos(shooter:GetPos())
			self.LastShoot = SysTime()
		end
		
		if SysTime() > self.LastShoot + 1.5 then
			self.LastShoot = SysTime()
			
			if IsValid(self.Target) and self.Target:Health() > 0 then
				local src = self.shooter:GetPos()
				-- player.GetAll()[1]:SetPos(src)
				local pos = self.Target:GetPos() + self.Target:OBBCenter()
				local b = {
					Attacker = self:GetOwner(),
					Num = 1,
					Src = src,
					Dir = (pos - src),
					Spread = Vector(0, 0, 0),
					TracerName = "AirboatGunHeavyTracer",
					Force = 1,
					Damage = self:GetTargetDamage(),
					AmmoType = 2
				}
				self.shooter:FireBullets(b)

				// Make a custom tracer, as the tracer made by
				// FireBullets starts at the origin, instead of the top of the tower.
				// util.ParticleTracer( "GunshipTracer", self:GetPos() + Vector(0, 0, 500), (pos - src), true )
			end
			
			if not self.Target or not IsValid(self.Target) then
				self:FindTarget()
			else
				if self.Target and self.Target:Health() < 1 then
					self:FindTarget()
				end	
			end
		
		
		end
	end
end