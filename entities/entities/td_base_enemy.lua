AddCSLuaFile()

ENT.PrintName = "Tower Defense Enemy"
ENT.Author    = "26"
ENT.Base      = "base_nextbot"
ENT.Type      = "nextbot"

if SERVER then
	local R = 20^2
	function ENT:SetupDataTables()
		self:NetworkVar("Int", 0, "CurrentWaypointID")
	end
	
	function ENT:Initialize()
		self:SetModel("models/headcrabclassic.mdl")
		self:SetModelScale(1)
		self:SetMaxHealth(10)
		self:SetHealth(10)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	end

	function ENT:UpdateCurrentWaypointInformation()
		if not WAYPOINTS or next(WAYPOINTS.MapWaypoints) == nil then
			error("rip, how did I Get here?")
		end
		self.CurrentWaypoint = WAYPOINTS.MapWaypoints[WAYPOINTS.FormatIDString(self:GetCurrentWaypointID())]
	end
	
	function ENT:Think()
		if self.CurrentWaypoint then
			self.CanGo = true
		end
		return
	end
	
	function ENT:CoroutineFigureOutMyPath()
			if self.CanGo and self.CurrentWaypoint then
				if not self.Path then
					self.Path = Path( "Follow" )
					self.Path:SetMinLookAheadDistance( 300 )
					self.Path:SetGoalTolerance( 20 )
				end

				self.Path:Compute(self, self.CurrentWaypoint.pos)
				self.Path:Update(self)

				if self:GetPos():DistToSqr(self.CurrentWaypoint.pos) <= R then
					local next_wp = self.CurrentWaypoint.nextWaypoint
					if istable(next_wp) then
						next_wp = next_wp[math.random(1, #next_wp)]
					end
					if not next_wp then
						PrintMessage(3, "we ded")
						self:Remove()
						return
					end
					self:SetCurrentWaypointID(next_wp)
					self:UpdateCurrentWaypointInformation()
				end
			end
	end

	function ENT:RunBehaviour()
		while true do
			self:StartActivity(ACT_RUN)
			self.loco:SetDesiredSpeed(75)
			self:CoroutineFigureOutMyPath()
			coroutine.wait(.1)
			coroutine.yield()
		end
	end

	function ENT:OnInjured(dmginfo) -- TODO
	end
	
	function ENT:OnKilled(dmginfo)
		local atk = dmginfo:GetAttacker()
		local inf = dmginfo:GetInflictor()

		self:BecomeRagdoll(dmginfo)
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end