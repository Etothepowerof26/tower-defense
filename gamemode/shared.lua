GM.Name    = "Tower Defense"
GM.Author  = "twentysix"
GM.Email   = ""
GM.Website = "Etothepowerof26.github.io"

DeriveGamemode("base")

function GM:Initialize()
	self.BaseClass.Initialize(self)
end

team.SetUp(1, "Players", Color(0, 127, 255))