GM.Name    = "Tower Defense"
GM.Author  = "twentysix"
GM.Email   = ""
GM.Website = "https://github.com/Etothepowerof26/tower-defense"

DeriveGamemode("base")

function GM:Initialize()
	self.BaseClass.Initialize(self)
end

team.SetUp(1, "Players", Color(0, 127, 255))