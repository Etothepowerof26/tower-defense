TD.EnemyTable = {
	["Headcrab"] = {
		Model = "models/Lamarr.mdl",
		Speed = 100, -- Player Walking Speed
		Health = 50,
		Scale = 1,
		MoneyOnKill = 10
	},
	["FastHeadcrab"] = { -- Fast Headcrab
		Model = "models/headcrab.mdl",
		Speed = 175,
		Health = 35, -- Less health than the regular headcrab
		Scale = 1,
		MoneyOnKill = 10
	},
	["PoisonHeadcrab"] = {
		Model = "models/headcrabblack.mdl",
		Speed = 125,
		Health = 75,-- Little stronger and little faster
		Scale = 1,
		MoneyOnKill = 15
	},
	["Zombie"] = { -- More health than headcrabs
		Model = "models/Zombie/Classic.mdl",
		Speed = 125,
		Health = 100,
		Scale = 1,
		MoneyOnKill = 30
	},
	["FastZombie"] = {
		Model = "models/Zombie/Fast.mdl",
		Speed = 200,
		Health = 50, -- Has the health of a regular headcrab but 'super' fast
		Scale = 1,
		MoneyOnKill = 35
	},
	["Zombine"] = {
		Model = "models/zombie/zombie_soldier.mdl", -- a miniboss?
		Speed = 100,
		Health = 500,
		Scale = 1,
		MoneyOnKill = 50
	},
	["Antlion"] = {
		Model = "models/AntLion.mdl", -- a miniboss?
		Speed = 125,
		Health = 300,
		Scale = 1,
		MoneyOnKill = 100
		},
	["AntlionGuard"] = {
		Model = "models/antlion_guard.mdl", -- One of the bosses
		Speed = 75,
		Health = 1000,
		Scale = 1,
		MoneyOnKill = 250
	},
	["Alyx"] = {
		Model = "models/alyx.mdl",
		Speed = 200,
		Health = 250,
		Scale = .75,
		MoneyOnKill = 100
	},
	["Kleiner"] = {
		Model = "models/kleiner.mdl",
		Speed = 150,
		Health = 150,
		Scale = .75,
		MoneyOnKill = 75
	}
}

TD.RoundTable = {
	{
		Sequence = {
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
		}
	},
	{
		Sequence = {
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
		}
	},
	{
		Sequence = {
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.1, Enemy = "FastHeadcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.1, Enemy = "FastHeadcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.1, Enemy = "FastHeadcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.1, Enemy = "FastHeadcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.1, Enemy = "FastHeadcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.1, Enemy = "FastHeadcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.1, Enemy = "FastHeadcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.1, Enemy = "FastHeadcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.1, Enemy = "FastHeadcrab"},
			{Delay = 0.5, Enemy = "Headcrab"},
			{Delay = 0.1, Enemy = "FastHeadcrab"}
		}
	},
	{
		Sequence = {
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"}
		}
	},
	{
		Sequence = {
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"}
		}
	},
	{
		Sequence = {
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "Antlion"}
		}
	},
	{
		Sequence = {
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"}
		}
	},
	{
		Sequence = {
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 1, Enemy = "Antlion"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
		}
	}
	--[[{	--Engine_Machiner waves, just to test
		Sequence = {
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.5,  Enemy = "Kleiner"},
			{Delay = 0.25, Enemy = "Headcrab"},
			{Delay = 0.25, Enemy = "Headcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "Antlion"},
			{Delay = 0.25, Enemy = "Antlion"},
			{Delay = 1,    Enemy = "Alyx"}
		}
	},
	{	--Engine_Machiner waves, just to test
		Sequence = {
			{Delay = 0.25, Enemy = "Headcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "Headcrab"},
			{Delay = 0.25, Enemy = "Headcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "Zombine"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "FastZombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "Alyx"},
			{Delay = 0.25, Enemy = "Alyx"}
		}
	},
	{	--Engine_Machiner waves, just to test
		Sequence = {
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "Zombine"},
			{Delay = 0.25, Enemy = "FastZombie"},
			{Delay = 0.25, Enemy = "Zombie"},
			{Delay = 0.25, Enemy = "FastHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "PoisonHeadcrab"},
			{Delay = 0.25, Enemy = "Antlion"},
			{Delay = 0.25, Enemy = "Antlion"},
			{Delay = 0.25, Enemy = "Zombine"}
		}	
	}]]
}
