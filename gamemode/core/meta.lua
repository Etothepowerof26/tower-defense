local Tag = 'tower_defense'
local Player = FindMetaTable('Player')

function Player:GetCash()
	return self:GetNWInt(Tag .. ".cash", 150)
end

function Player:CanAfford(amnt)
	return self:GetCash() >= amnt
end

if SERVER then
	util.AddNetworkString(Tag .. ".CashChange")

	function Player:SetCash(amnt)
		assert(isnumber(amnt))

		local old = self:GetCash()
		self:SetNWInt(Tag .. ".cash", amnt)

		net.Start(Tag .. ".CashChange")
			if self:GetCash() > old then
				net.WriteBit(1)
			else
				net.WriteBit(0)
			end

			net.WriteUInt(amnt, 32)
		net.Send(self)
	end

	function Player:AddCash(amnt)
		assert(isnumber(amnt))

		self:SetCash(math.Clamp(self:GetCash() + amnt, 0, 2^31-1))
	end

	function Player:TakeCash(amnt)
		assert(isnumber(amnt))
		if not (self:GetCash() - amnt > 0) then return false end

		self:SetCash(math.Clamp(self:GetCash() - amnt, 0, 2^31-1))
		return true
	end

	-- tower stuff
		
	function Player:BuyTower(tower, pos)
		PrintMessage(3, "BuyTower")
	end
	
end