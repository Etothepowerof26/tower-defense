local PLAYER = FindMetaTable("Player")

TD = TD or {}

TD.TowerTable = {
	["BasicTower"] = {
		Model = "models/props_combine/breenglobe.mdl",
		ShootSound = "weapons/ar2/fire1.wav",
		BulletTracer = "AirboatGunHeavyTracer",
		Price = 150,
		PrintName = "Basic Tower",
		Description = "For its type, it works really well.",
		Scale = 1,
		Color = Color(255,255,255),
		Stats = {
			Damage = 10,
			FindDist = 750,
			ShootSpeed = 0.25,
			NumBullets = 1
		},
		Upgrades = {
			[1] = {
				{UpgradeName="Damage Upgrade",UpgradeDesc="Makes the tower a bit stronger.",UpgradePrice=100,UpgradeCallback=function(self)
					self:SetDamage(self:GetDamage()+5)
				end}
			},
			[2] = {
				{UpgradeName="Range Upgrade",UpgradeDesc="Makes the tower see a bit farther.",UpgradePrice=75,UpgradeCallback=function(self)
					self:SetTargetDistance(self:GetTargetDistance()+100)
				end}
			}
		},
		--TODO: Add think function for serverside. It will allow for custom projectiles.
		Think = function(self)
			if CLIENT then return end
			
			if(CurTime()>=self:GetLastShoot()+self:GetShootSpeed())then
				self:SetLastShoot(CurTime())
				local Target = self:GetNearestTarget()
				if(IsValid(Target))then
					local Source = self:GetPos()+Vector(0,0,self:OBBMaxs().z/2)
					local TPosition = Target:GetPos()+Target:OBBCenter()
					local Bullet = {
						Attacker = self:GetOwner(),
						Num = self:GetNumBullets(),
						Src = Source,
						Dir = (TPosition-Source),
						Spread = Vector(0,0,0),
						TracerName = "AirboatGunHeavyTracer",
						Force = 10,
						Damage = self:GetDamage(),
						AmmoType = 2
					}
					self:FireBullets(Bullet)
				end
			end
		end
	}
}

if(SERVER)then
	include("sv_td.lua")
	
	TD.CurrentEnemies = {}
	
	-- Round system
	TD.CurrentRound = 0
	TD.EnemiesKilled = 0
	function TD.Reset()
		TD.CurrentRound = 0
		table.foreach(player.GetAll(), function(k,v)
			v:Spawn()
		end)
		
		ChatAddText(Color(255, 127, 127), "[TD] ", Color(255, 255, 255), "Welcome to Tower Defense!")
		ChatAddText(Color(255, 127, 127), "[TD] ", Color(255, 255, 255), "There are currently " .. table.Count(TD.RoundTable) .. " rounds in the game.")
		TD.GameStarted=true
	end
	
	-- Hacky stuff for creating enemies.
	local LastDelay = 0
	function TD.SpawnEnemy(Type, Delay)
		LastDelay = LastDelay + Delay
		timer.Simple(LastDelay, function()
			local Ent = ents.Create("td_enemy")
			Ent:SetPos(TD.EntWaypoints[1]:GetPos())
			Ent:Spawn()
			Ent:SetTDType(Type)
		end)
	end
	
	function TD.RoundStart()
		TD.CurrentRound = TD.CurrentRound + 1
		TD.EnemiesKilled = 0
		LastDelay = 0
		
		local RTable = TD.RoundTable[TD.CurrentRound]
		
		ChatAddText(Color(255, 127, 127), "[TD] ", Color(255, 255, 255), "Round " .. tostring(TD.CurrentRound) .. " is starting!")
		
		for i,v in pairs(RTable.Sequence) do
			TD.SpawnEnemy(v.Enemy, v.Delay)
		end
	end
	
	-- Waypoints for enemies
	TD.EntWaypoints = TD.EntWaypoints or {}
	
	TD.MapWaypoints = {
		["gm_construct"] = {
			[1] = Vector(844.18603515625,-741.97637939453,-143.96875), -- Start
			[2] = Vector(-711.30883789063,-723.31976318359,-148.01229858398),
			[3] = Vector(-1576.6196289063,377.83648681641,-148),
			[4] = Vector(678.27471923828,942.61236572266,-150.21731567383) -- End
		}
	}
	
	TD.ConstructWaypointsFromTable = function()
		local Map = game.GetMap()
		local MapTable = TD.MapWaypoints[Map]
		if not MapTable then
			return
		else
			for i,v in ipairs(MapTable) do
				local Ent = ents.Create("td_point")
				Ent:SetPos(v)
				Ent:Spawn()
				Ent:SetPointType((i==1)and(1)or(i==table.Count(MapTable)and(3)or(2)))
				TD.EntWaypoints[table.Count(TD.EntWaypoints) + 1] = Ent
			end
		end
	end
	
	-- Lives system.
	TD.Lives = 10
	TD.GameEnded = false
	TD.HandleOnReachedEnd = function(Entity)
		Entity:Remove()
		TD.Lives = TD.Lives - 1
		TD.EnemiesKilled = TD.EnemiesKilled + 1
		ChatAddText(Color(255, 127, 127), "[TD] ", Color(255, 255, 255), "An enemy has gone through your defenses! You have ", tostring(TD.Lives), " lives left!")
	end
	
	TD.HandleWaveEnd = function()
		if(TD.WaveStarted)and(TD.EnemiesKilled==table.Count(TD.RoundTable[TD.CurrentRound].Sequence))then
			ChatAddText(Color(255, 127, 127), "[TD] ", Color(255, 255, 255), "You have completed the wave!")
			TD.DisplayedWarningMessage=false
			TD.WaveStarted=false
			TD.LastWaveStarted=CurTime()
			net.Start("TD:Cleanup")
			net.Broadcast()
		else
			if(TD.Lives<=0)then
				TD.WaveStarted=false
				TD.GameEnded=true
				
				ChatAddText(Color(255, 127, 127), "[TD] ", Color(255, 0, 0), "Game over!", Color(255, 255, 255), " A new game will start in 10 seconds.")
				-- Destroy all of the enemies!
				table.foreach(ents.FindByClass("td_enemy"),function(k,v) v:Remove(); end)
				table.foreach(ents.FindByClass("td_tower"),function(k,v) v:Remove(); end)
				
				-- timer simple
				timer.Simple(10,function()
					TD.LastCheckPlayers=CurTime()
					TD.DisplayedWarningMessage=false
					table.foreach(player.GetAll(),function(k,v) v:SetNWInt("TD:Money",500); v:Spawn(); end)
					TD.Reset()
				end)
			end
		end
	end
	
	-- Automation!
	RunConsoleCommand("sv_hibernate_think", "1")
	
	TD.WaveDelay = CreateConVar("td_wave_delay", "15", FCVAR_NONE)
	TD.PlayerCheckDelay = CreateConVar("td_player_check_delay", "10", FCVAR_NONE)
	TD.MinimumPlayers = CreateConVar("td_minimum_players", "2", FCVAR_NONE)
	
	TD.LastWaveStarted = CurTime()
	TD.DisplayedWarningMessage = false
	TD.WaveStarted = false
	TD.GameStarted = false
	
	TD.LastCheckPlayers = CurTime()
	
	timer.Create("TD:Think", 1, 0, function()
		if(CurTime()>=TD.LastCheckPlayers+TD.PlayerCheckDelay:GetInt())and(not TD.GameStarted)then
			TD.LastCheckPlayers = CurTime()
			local AmntPlayers = table.Count(player.GetAll())
			if(AmntPlayers>=GetConVar("td_minimum_players"):GetInt())then
				ChatAddText(Color(255, 127, 127), "[TD] ", Color(255, 255, 255), "There are more than " .. tostring(GetConVar("td_minimum_players"):GetInt()) .. " players! The game is going to start!")
				TD.LastWaveStarted = CurTime()
				TD.GameStarted = true
				table.foreach(ents.FindByClass("td_tower"),function(k,v)
					v:Remove();
				end)
				table.foreach(player.GetAll(),function(k,v)
					v:SetNWInt("TD:Money",500)
					v:Spawn()
				end)
			else
				ChatAddText(Color(255, 127, 127), "[TD] ", Color(255, 255, 255), "There is not enough players, " .. tostring(GetConVar("td_minimum_players"):GetInt()) .. " minimum, " .. tostring(GetConVar("td_minimum_players"):GetInt()-AmntPlayers) .. " players needed.")
			end
		end
		
		if(TD.GameStarted)and(not TD.WaveStarted)then
			if(not TD.DisplayedWarningMessage)then
				TD.DisplayedWarningMessage=true
				ChatAddText(Color(255, 127, 127), "[TD] ", Color(255, 255, 255), "Round " .. tostring(TD.CurrentRound+1) .. " will start in " .. tostring(GetConVar("td_wave_delay"):GetInt()) .. " seconds!")
			end
			if(CurTime()>=TD.LastWaveStarted+GetConVar("td_wave_delay"):GetInt())then
				TD.RoundStart()
				TD.WaveStarted=true
			end
		end
		
		if(TD.WaveStarted)and(not TD.GameEnded)then
			TD.HandleWaveEnd()
		end
	end)
	
	hook.Add("InitPostEntity", "TD", TD.ConstructWaypointsFromTable)
	
	net.Receive("TD:BuyTower", function(Length, Player)
		local TypeOfTower = net.ReadString()
		local TowerTable = TD.TowerTable[TypeOfTower]
		if(TowerTable)then
			local CanAfford = Player:GetNWInt("TD:Money",0)>=TowerTable.Price
			if(CanAfford)then
				local NicePrice = string.Comma(tostring(TowerTable.Price))
				Player:SetNWInt("TD:Money",Player:GetNWInt("TD:Money")-TowerTable.Price)
				Player:ChatAddText(Color(255,127,127),"[TD] ",Color(255,255,255),"You have bought the ",TowerTable.PrintName," for ",Color(0,255,0), "$",NicePrice,Color(255,255,255),"!")
				
				local EyeTrace = util.QuickTrace(Player:EyePos(),Player:GetAimVector()*1000,{Player})
				local Tower = ents.Create("td_tower")
				Tower:SetPos(EyeTrace.HitPos)
				Tower:Spawn()
				Tower:SetOwner(Player)
				Tower:ChangeTowerType(TypeOfTower)
				Tower:SetPos(Tower:GetPos()+Vector(0,0,Tower:OBBMaxs().z/2))
			else
				local NicePrice = string.Comma(tostring(TowerTable.Price-Player:GetNWInt("TD:Money",0)))
				Player:ChatAddText(Color(255,127,127),"[TD] ",Color(255,255,255),"Cannot afford the ",TowerTable.PrintName,"! You need ",Color(0,255,0), "$",NicePrice,Color(255,255,255)," more to buy this tower!")
			end
		else
			Player:ChatAddText(Color(255, 127, 127), "[TD] ", Color(255, 255, 255), "Invalid tower to place!")
		end
	end)
else
	include("cl_td.lua")
end
