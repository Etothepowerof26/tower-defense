# tower-defense
Garry's Mod Tower Defense gamemode

### Defining a tower
1. Navigate to sh_td.lua
2. Find `TD.TowerTable`
3. Create a new table with this format
```lua
	["ClassNameOfTower"] = {
		-- This is the name of the tower.
		-- It will show up when you try to buy it.
		PrintName = "Test Tower",
		-- UNUSED
		Description = "it will be used some day...",
		-- This is the model of the tower.
		-- It will show up when you place it.
		Model = "blah blah some model here",
		-- The model scale of the tower.
		Scale = 1,
		-- Price of the tower.
		Price = 100,
		
		-- The color of the model.
		Color = Color(255, 0, 0),
		-- The sound it makes when it shoots.
		ShootSound = "",
		-- The bullet tracer.
		BulletTracer = "AirboatGunHeavyTracer",
		-- Stats table
		Stats = {
			-- Damage
			Damage = 10,
			-- Range of tower
			FindDist = 750,
			-- Delay between shots
			ShootSpeed = .25,
			-- Number of bullets
			NumBullets = 1
		},
		-- This is the default upgrade table.
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
		-- This think function will exist on the server.
		-- Currently the default think function for the Basic Tower.
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
```
4. It should pop up when you go to buy towers.

### Defining an enemy
1. Navigate to sv_td.lua
2. Find `TD.EnemyTable`
3. Create a new table with this format
```lua
	["ClassNameOfEnemy"] = {
		-- The model of the enemy.
		-- Find one with animations so that it moves when the nextbot pathfinds to the next point.
		Model = "models/Lamarr.mdl",
		-- The speed of the enemy.
		Speed = 100, -- Player Walking Speed
		-- The health of the enemy.
		Health = 50,
		-- The model scale of the enemy
		Scale = 1,
		-- The money you get when you kill the enemy.
		MoneyOnKill = 10
	}
```
Your enemy wont pop up yet, you have to create a round with the enemy.

### Defining a wave
1. Navigate to sv_td.lua
2. Find `TD.RoundTable`
3. Create a table with this format
```lua
{
	Sequence = {
		{
			-- The delay between the last enemy spawn (or the start of the round) and the time which this
			-- enemy spawns.
			Delay = 0.25, -- .25 seconds
			-- The enemy type (you probably just defined)
			Enemy = "ClassNameOfEnemy"
		}
	}
}
```
4. When the round counter is at the position of your round you defined, it will go through the sequence and spawn the enemies you put in the round.
