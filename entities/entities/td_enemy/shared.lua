if(SERVER)then AddCSLuaFile() end

ENT.PrintName = "Tower Defense Enemy"
ENT.Author = "26"
ENT.Base = "base_nextbot"
ENT.Type = "nextbot"

if(SERVER)then
	function ENT:SetupDataTables()
		self:NetworkVar("Int", 0, "CurrentPoint")
		self:NetworkVar("Int", 1, "TDDesiredSpeed")
		self:NetworkVar("Int", 2, "DistCheck")
		self:NetworkVar("String", 0, "TDEnemy")
	end
	
	function ENT:Initialize()
		local ETable = TD.EnemyTable["Headcrab"]
		self:SetModel(ETable.Model)
		self:SetTDDesiredSpeed(ETable.Speed)
		self:SetModelScale(ETable.Scale)
		self:SetMaxHealth(ETable.Health)
		self:SetHealth(ETable.Health)
		self:SetTDEnemy("Headcrab")
		self:SetCurrentPoint(1)
		self:SetDistCheck(50^2)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	end
	
	function ENT:SetTDType(EnemyString)
		local ETable = TD.EnemyTable[EnemyString]
		if not ETable then
			error("trying to set " .. tostring(self) .. " to invalid enemy '" .. EnemyString .. "'")
		else
			self:SetTDEnemy(EnemyString)
			
			self:SetModel(ETable.Model)
			self:SetTDDesiredSpeed(ETable.Speed)
			self:SetModelScale(ETable.Scale)
			self:SetMaxHealth(ETable.Health)
			self:SetHealth(ETable.Health)
			self:SetTDEnemy(EnemyString)
		end
	end
	
	function ENT:Think()
		local Point = TD.EntWaypoints[self:GetCurrentPoint()+1]
		if(self:GetPos():DistToSqr(Point:GetPos())<self:GetDistCheck())then
			Point:OnReach(self)
		end
	end
	
	-- Default BehaveUpdate
	function ENT:BehaveUpdate( fInterval )
		-- You really shouldn't override this method.
		
		if ( !self.BehaveThread ) then return end
		
		local ok, message = coroutine.resume( self.BehaveThread )
		if ( ok == false ) then
			self.BehaveThread = coroutine.create( function() self:RunBehavior() end )
		end
	end
	
	function ENT:RunBehavior()
		while true do
			local Point = TD.EntWaypoints[self:GetCurrentPoint()+1]
			self.loco:FaceTowards(Point:GetPos())
			self.loco:SetDesiredSpeed(self:GetTDDesiredSpeed())
			self:StartActivity(ACT_RUN)
			self:MoveToPos(Point:GetPos())
			coroutine.wait(1)
			coroutine.yield()
		end
	end
	
	function ENT:OnKilled(dmginfo)
		local Atk = dmginfo:GetAttacker()
		local Inf = dmginfo:GetInflictor()
		hook.Call("OnNPCKilled",GAMEMODE,self,Atk,Inf)
		self:BecomeRagdoll(dmginfo)
		if(IsValid(Atk))and(Atk:IsPlayer())then
			local EnemyTable=TD.EnemyTable[self:GetTDEnemy()]
			Atk:SetNWInt("TD:Money",Atk:GetNWInt("TD:Money",0)+EnemyTable.MoneyOnKill)
		end
		TD.EnemiesKilled = TD.EnemiesKilled + 1
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end