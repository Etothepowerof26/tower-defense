local Tag = 'tower_defense'
local Player = FindMetaTable('Player')

module(Tag, package.seeall)

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

		// this piece of code doesn't work.
		local wep = self:GetActiveWeapon()
		if wep:GetClass() == "tower_defense_tool" then
			wep:SendWeaponAnim(ACT_PHYSCANNON_ANIMATE)
		end

		self:EmitSound("ambient/alarms/warningbell1.wav")

		local t = ents.Create(tower.ent)
		t:Spawn()
		t:SetPlayerOwner(self)
		timer.Simple(0, function()
			t:SetPos(pos + Vector(0, 0, t:OBBMaxs().z / 2))
		end)

		self:Notify("You have placed a " .. tower.name .. "!", 3, 5)
		self:SetNWInt("tower_defense.cash", self:GetNWInt("tower_defense.cash") - tower.price)

		if not placed_towers[self] then
			placed_towers[self] = {t}
		else
			local placed = placed_towers[self]
			placed[#placed + 1] = t
		end

	end

	
end
