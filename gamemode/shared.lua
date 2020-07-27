GM.Name    = "Tower Defense"
GM.Author  = "twentysix"
GM.Email   = "a"
GM.Website = "b"

DeriveGamemode("base")
AddCSLuaFile("cl_td.lua")
AddCSLuaFile("sh_td.lua")
include("sh_td.lua")

function GM:Initialize()
	self.BaseClass.Initialize(self)
end