if(SERVER)then AddCSLuaFile() end

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Spawnable = false

if(SERVER)then
	function ENT:SetupDataTables()
		-- 1:start,2:waypoint,3:end
		self:NetworkVar("Int", 0, "PointType")
	end
	
	function ENT:Initialize()
		self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self:SetMaterial("models/debug/debugwhite")
		self:SetModelScale(1)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	end
	
	function ENT:OnReach(e)
		if(e:GetClass()=="td_enemy")then
			if(self:GetPointType()==3)then
				TD.HandleOnReachedEnd(e)
			else
				e:SetCurrentPoint(e:GetCurrentPoint()+1)
			end
		end
	end
	
	function ENT:Think()
		if not TD then self:Remove() end
		self:SetColor(self:GetPointType()==1 and Color(0, 255, 0) or (self:GetPointType()==2 and Color(255, 255, 255) or Color(255, 0, 0)))	
	end
else
	function ENT:Draw()
		self:DrawModel()	
	end
end