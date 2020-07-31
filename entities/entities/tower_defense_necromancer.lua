AddCSLuaFile()

ENT.PrintName = "Fast Headcrab"
ENT.Author    = "26"
ENT.Base      = "tower_defense_enemy"
ENT.Type      = "nextbot"

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/zombie/classic.mdl")
		self:SetModelScale(1)
		self:SetMaxHealth(150)
		self:SetHealth(150)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetLastChosenPoint("1")
		self:SetColor(0, 255, 255, 127)

		--self:SetBodygroup(0, 1)

		--PrintTable(self:GetBodyGroups())
	end

	ENT.defaultRunBehaviour = function(self)
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
			self.loco:SetDesiredSpeed(25)
			self:MoveToPos(point)
			
			coroutine.wait(.1)
			coroutine.yield()
		end
	end

	local R = 50^2
	local noop = function() while true do coroutine.yield() end end
	function ENT:Think()
		if not self.point then
			self:FindPoint()
			return
		end
		
		if self:GetPos():DistToSqr(self.point) <= R then
			self:SetLastChosenPoint(self:GetLastChosenPoint() + 1)
			self:FindPoint()
		end

		-- necromancer ai
		if not self.LastSpawn then
			self.LastSpawn = SysTime()
		end

		--[[
0       =       Idle01
1       =       walk
2       =       walk2
3       =       walk3
4       =       walk4
5       =       FireWalk
6       =       FireIdle
7       =       attackA
8       =       attackB
9       =       attackC
10      =       attackD
11      =       attackE
12      =       attackF
13      =       swatleftmid
14      =       swatrightmid
15      =       swatleftlow
16      =       swatrightlow
17      =       releasecrab
18      =       physflinch1
19      =       physflinch2
20      =       physflinch3
21      =       smashfall64
22      =       slump_a
23      =       slumprise_a
24      =       slumprise_a_attack
25      =       slumprise_a2
26      =       slump_b
27      =       slumprise_b
28      =       Breakthrough
29      =       canal5await
30      =       canal5aattack
31      =       flinch1inDelta
32      =       flinch1inFrame
33      =       flinch1CoreDelta
34      =       flinch1OutFrame
35      =       flinch1outDelta
36      =       flinch1
37      =       flinch2inDelta
38      =       flinch2inFrame
39      =       flinch2CoreDelta
40      =       flinch2OutFrame
41      =       flinch2outDelta
42      =       flinch2
43      =       flinch3inDelta
44      =       flinch3inFrame
45      =       flinch3CoreDelta
46      =       flinch3OutFrame
47      =       flinch3outDelta
48      =       flinch3
49      =       Tantrum
50      =       WallPound
51      =       ragdoll
		]]

		if SysTime() > self.LastSpawn + 15 then
			self.LastSpawn = SysTime()
			PrintTable(self:GetSequenceList())
			self.RunBehaviour = noop
			self:BehaveStart()
			
			-- tantrum = 49
			local name = self:GetSequenceName(49)
			local len = self:SetSequence(name)

			local mult = .5

			self:ResetSequenceInfo()
			self:SetCycle( 0 )
			self:SetPlaybackRate( mult )

			-- wait for it to finish
			timer.Simple(len / mult, function()
				if not IsValid(self) then return end

				self.RunBehaviour = function()
					self:defaultRunBehaviour()
				end
				self.LastSpawn = SysTime()
				self:BehaveStart()
				self:SetHealth(math.Clamp(self:Health() + 25, 0, self:GetMaxHealth()))

				local rad = 35
				local despawns = {
					self:GetPos() + Vector(rad, rad, 0),
					self:GetPos() + Vector(rad, -rad, 0),
					self:GetPos() + Vector(-rad, rad, 0),
					self:GetPos() + Vector(-rad, -rad, 0)

				}
				for i = 1, math.random(2,4) do
					local vec = despawns[i] or self:GetPos()

					local ed = EffectData()

					local headcrab = ents.Create("tower_defense_bheadcrab")
					headcrab:SetPos(vec)
					headcrab:Spawn()
					headcrab.point = self.point

					
					ed:SetEntity(headcrab)
					util.Effect("propspawn", ed)
				end

			end)
		end
	end
	

	function ENT:RunBehaviour()
		self:defaultRunBehaviour()
	end
end