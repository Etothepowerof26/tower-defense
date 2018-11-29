if(SERVER)then AddCSLuaFile() end

ENT.PrintName = "Tower Defense Tower"
ENT.Author = "26"
ENT.Base = "base_anim"
ENT.Type = "anim"

if(SERVER)then
	function ENT:SetupDataTables()
		self:NetworkVar("Int", 0, "TargetDistance")
		self:NetworkVar("Int", 1, "TargetMode")
		self:NetworkVar("Int", 2, "Damage")
		self:NetworkVar("Int", 3, "NumBullets")
		self:NetworkVar("String", 0, "TowerType")
		self:NetworkVar("Float", 0, "LastShoot")
		self:NetworkVar("Float", 1, "ShootSpeed")
	end
	
	function ENT:ChangeTowerType(TowerType)
		-- If no tower is specified, it will fallback to the default tower
		-- "Basic Tower"
		TowerType = TowerType or "BasicTower"
		local TowerTable = TD.TowerTable[TowerType]
		self:SetModel(TowerTable.Model)
		self:SetModelScale(TowerTable.Scale)
		self:SetTowerType(TowerType)
		self:SetTargetDistance(TowerTable.Stats.FindDist)
		self:SetDamage(TowerTable.Stats.Damage)
		self:SetShootSpeed(TowerTable.Stats.ShootSpeed)
		self:SetNumBullets(TowerTable.Stats.NumBullets)
		self:SetLastShoot(CurTime())
		self.Think = TowerTable.Think
	end
	
	function ENT:Initialize()
		self:ChangeTowerType("BasicTower")
		
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)
	end
	
	function ENT:GetNearestTarget()
		local Distance = self:GetTargetDistance()^2
		local Target = NULL
		for _, v in pairs(ents.FindByClass("td_enemy")) do
			local NewDistance = self:GetPos():DistToSqr(v:GetPos())
			if(Distance==nil)then continue end
			if(NewDistance<=Distance)and(v:Health()>0)then
				Target = v
				Distance = newdist
			end
		end
		return Target
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end