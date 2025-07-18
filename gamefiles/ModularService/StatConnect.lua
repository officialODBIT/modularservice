--local module = {}
--module.__index = module

--function module.new(player)
--	local self = setmetatable({}, module)

--	local leaderstats = player:FindFirstChild("leaderstats")
--	if not leaderstats then
--		leaderstats = Instance.new("Folder")
--		leaderstats.Name = "leaderstats"
--		leaderstats.Parent = player
--	end

--	self.leaderstats = leaderstats
--	self.stats = {}
--	return self
--end

--function module:CreateNewStat(statName)
--	local stat = Instance.new("IntValue")
--	stat.Name = statName
--	stat.Value = 0
--	stat.Parent = self.leaderstats

--	table.insert(self.stats, stat)
--	return stat
--end

--return module
local DataStoreService = game:GetService("DataStoreService")
local module = {}
module.__index = module

function module.new(player)
	local self = setmetatable({}, module)

	self.player = player
	self.EnableDataStore = false  -- default: off

	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player
	end

	self.leaderstats = leaderstats
	self.stats = {}

	self.dataStore = DataStoreService:GetDataStore("Leaderstats_" .. player.UserId)

	player.AncestryChanged:Connect(function()
		if not player:IsDescendantOf(game) then
			if self.EnableDataStore then
				self:SaveStats()
			end
		end
	end)

	return self
end

function module:CreateNewStat(statName)
	local stat = Instance.new("IntValue")
	stat.Name = statName
	stat.Value = 0
	stat.Parent = self.leaderstats

	table.insert(self.stats, stat)
	return stat
end

function module:SaveStats()
	if not self.EnableDataStore then return end
	local data = {}
	for _, stat in ipairs(self.stats) do
		data[stat.Name] = stat.Value
	end

	local success, err = pcall(function()
		self.dataStore:SetAsync(tostring(self.player.UserId), data)
	end)
	if not success then
		warn("data failed/refused to save data for "..self.player.Name..": "..err)
	end
end

function module:LoadStats()
	if not self.EnableDataStore then return end

	local success, data = pcall(function()
		return self.dataStore:GetAsync(tostring(self.player.UserId))
	end)

	if success and data then
		for _, stat in ipairs(self.stats) do
			if data[stat.Name] then
				stat.Value = data[stat.Name]
			end
		end
	else
		if not success then
			warn("data failed/refused to load data for "..self.player.Name)
		end
	end
end

return module
