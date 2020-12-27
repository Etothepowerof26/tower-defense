
DIFFVOTE = DIFFVOTE || {}

local Tag = "tower_defense.DiffVote"


if SERVER then
	
	util.AddNetworkString(Tag .. ".ShowVote")
	util.AddNetworkString(Tag .. ".AddVote")

	DIFFVOTE.Started = false
	DIFFVOTE.TimeSinceStart = -1
	DIFFVOTE.Votes = {}
	DIFFVOTE.Duration = 30

	function DIFFVOTE:StartVote()
		self.Started = true
		self.TimeSinceStart = SysTime()

		print( # DIFFS.Difficulties )
		if ( table.Count( DIFFS.Difficulties ) < 2 ) then
			self.TimeSinceStart = SysTime() + DIFFVOTE.Duration
			return
		end

		net.Start( Tag .. ".ShowVote" )
		net.WriteBit( 1 )

		net.WriteUInt( #DIFFS.Difficulties, 8 )
		for i = 1, DIFFS.Difficulties do
			local the_diff = table.Copy( DIFFS.Difficulties )
			the_diff.Rounds = nil

			net.WriteTable( the_diff )
		end

		net.Send( player.GetHumans() )
	end

	function DIFFVOTE:EndVote()
		-- self.Started = false
		self.TimeSinceStart = -1

		if ( table.Count( DIFFS.Difficulties ) < 2 ) then
			PrintMessage( 3, "ERROR: There's only 1 difficulty! Ending vote now." )
			return DIFFS.Difficulties[1]
		end


	end

	net.Receive( Tag .. ".AddVote", function()
		local option = net.ReadUInt( 4 )
		local remove_or_add = net.ReadBit() == 0 -- remove is 1

	end )

end

if CLIENT then
	
	DIFFVOTE.Frame = DIFFVOTE.Frame or nil

	local function createFrame(diffs)
		PrintTable(diffs)
	end

	net.Receive(Tag .. ".ShowVote", function()
		local show = net.ReadBit() == 1

		if show then

			local diffs = {}
			local amount = net.ReadUInt( 8 )

			for i = 1, amount do
				diffs[#diffs + 1] = net.ReadTable()
			end

			createFrame(diffs)

		else
		end
	end)

end