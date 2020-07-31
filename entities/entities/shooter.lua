AddCSLuaFile()

/*
	I'm doing this because bullet tracers are super dumb.
*/

ENT.PrintName = "Shooter"
ENT.Author    = "26"
ENT.Base      = "base_anim"
ENT.Type      = "anim"

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_combine/breenglobe.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end