AddCSLuaFile()

ENT.PrintName = "Tower"
ENT.Author = "26"
ENT.Base = "base_anim"
ENT.Type = "anim"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "TargetMode")
	self:NetworkVar("Int", 1, "EnemiesKilled")
	self:NetworkVar("Int", 2, "TargetDamage")
	self:NetworkVar("Int", 3, "TargetRange")
	self:NetworkVar("Entity", 0, "PlayerOwner") -- ent index
end

function ENT:DefaultVars()
	-- 1 : highest health
	-- 2 : lowest health
	-- 3 : nearest
	-- 4 : farthest
	-- 5 : first
	self:SetTargetMode(1)
	
	self:SetEnemiesKilled(0)
	self:SetTargetDamage(2.5)
	self:SetTargetRange(300^2)
end

if SERVER then

local function entCheck(ent)
	if ent.Base == "tower_defense_enemy" or ent:GetClass() == "tower_defense_enemy" then
		return true
	end
	
	return false
end
	
	function ENT:Initialize()
		self:SetModel("models/props_combine/breenglobe.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:DefaultVars()
		--self:FallToFloor()
	end
	
	ENT.Target = nil
	function ENT:FindTarget()
		local sphere = ents.FindInSphere(self:GetPos(), self:GetTargetRange())
		--print("mhh")
		if self:GetTargetMode() == 1 then
			local highest = { ent = NULL, hp = 0 }
			for k,v in pairs(sphere) do
				if not entCheck(v) then continue end
				
				if v:Health() >= highest.hp and self:Visible(v) then
					highest.ent = v
					highest.hp = v:Health()
				else
					continue
				end
			end
			
			self.Target = highest.ent
			self.ChangingTarget = false
			--print("bruh")
		elseif self:GetTargetMode() == 2 then
			local lowest = { ent = NULL, hp = 99999 }
			for k,v in pairs(sphere) do
				if not entCheck(v) then continue end
				
				if v:Health() <= lowest.hp and self:Visible(v) then
					lowest.ent = v
					lowest.hp = v:Health()
				else
					continue
				end
			end
			
			self.Target = lowest.ent
			self.ChangingTarget = false
		elseif self:GetTargetMode() == 3 then
			local closest = { ent = NULL, dist = 999999999999 }
			for k,v in pairs(sphere) do
				if not entCheck(v) then continue end
				
				if v:DistToSqr(self:GetPos()) <= closest.dist and self:Visible(v) then
					closest.ent = v
					closest.dist = v:DistToSqr(self:GetPos())
				else
					continue
				end
			end
			
			self.Target = closest.ent
			self.ChangingTarget = false
		elseif self:GetTargetMode() == 4 then
			local furthest = { ent = NULL, dist = 0 }
			for k,v in pairs(sphere) do
				if not entCheck(v) then continue end
				
				if v:DistToSqr(self:GetPos()) >= furthest.dist and self:Visible(v) then
					furthest.ent = v
					furthest.dist = v:DistToSqr(self:GetPos())
				else
					continue
				end
			end
			
			self.Target = furthest.ent
			self.ChangingTarget = false
		else
			--print("huhh")
			self.Target = NULL
			self.ChangingTarget = false
		end
	end
	
	function ENT:Think()
		if not self.LastShoot then
			self.LastShoot = SysTime()
		end
		
		if SysTime() > self.LastShoot + .5 then
			self.LastShoot = SysTime()
			
			if IsValid(self.Target) and self.Target:Health() > 0 then
				local src = self:GetPos() + Vector(0, 0, self:OBBMaxs().z / 2)
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
				self:FireBullets(b)
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
	
else

	function ENT:Draw()
		self:DrawModel()
	end
	
end
