-- this is how you easily add stats
local module = require(game:WaitForChild("ModularService").StatConnect) -- requires the module of which has the info
game.Players.PlayerAdded:Connect(function(plr) -- when a player is added make function with plr param
	local sm = module.new(plr)  -- sm - statmanager, makes the leaderstats folder
	sm.EnableDataStore = true 
	local coins = sm:CreateNewStat("Coins")
	coins.Value = 0
	sm:LoadStats()
	spawn(function()
		while plr.Parent do
			wait(0.1)
			sm:SaveStats()
		end
	end)
end)
