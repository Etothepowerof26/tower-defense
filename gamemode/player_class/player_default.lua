AddCSLuaFile()

local PLAYER = {}

PLAYER.DisplayName			= "Player"
PLAYER.WalkSpeed			= 300		-- How fast to move when not running
PLAYER.RunSpeed				= 450		-- How fast to move when running
PLAYER.CrouchedWalkSpeed	= 0.3		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 200		-- How powerful our jump should be
PLAYER.CanUseFlashlight		= true		-- Can we use the flashlight
PLAYER.MaxHealth			= 100		-- Max health we can have
PLAYER.StartHealth			= 100		-- How much health we start with
PLAYER.StartArmor			= 0			-- How much armour we start with
PLAYER.DropWeaponOnDie		= false		-- Do we drop our weapon when we die
PLAYER.TeammateNoCollide	= true		-- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers			= true		-- Automatically swerves around other players
PLAYER.UseVMHands			= true		-- Uses viewmodel hands

function PLAYER:SetupDataTables() end
function PLAYER:Init() end
function PLAYER:Spawn() end
function PLAYER:Loadout() end
function PLAYER:SetModel()
	local cl_playermodel = self.Player:GetInfo("cl_playermodel")
	local modelname = player_manager.TranslatePlayerModel(cl_playermodel)
	util.PrecacheModel(modelname)
	self.Player:SetModel(modelname)
end
function PLAYER:CalcView(view) end		-- Setup the player's view
function PLAYER:CreateMove(cmd) end		-- Creates the user command on the client
function PLAYER:ShouldDrawLocal() end		-- Return true if we should draw the local player
function PLAYER:StartMove(cmd, mv) end	-- Copies from the user command to the move
function PLAYER:Move(mv) end				-- Runs the move (can run multiple times for the same client)
function PLAYER:FinishMove(mv) end		-- Copy the results of the move back to the Player
function PLAYER:ViewModelChanged(vm, old, new) end
function PLAYER:PreDrawViewModel(vm, weapon) end
function PLAYER:PostDrawViewModel(vm, weapon) end
function PLAYER:GetHandsModel()
	local playermodel = player_manager.TranslateToPlayerModelName(self.Player:GetModel())
	return player_manager.TranslatePlayerHands(playermodel)
end

player_manager.RegisterClass("player_default", PLAYER, nil)