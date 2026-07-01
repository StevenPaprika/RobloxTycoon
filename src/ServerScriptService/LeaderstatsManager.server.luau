-- LeaderstatsManager
local DataStoreService = game:GetService("DataStoreService")
local myDataStore = DataStoreService:GetDataStore("MyTycoonDataStore_v2")

game.Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"

	local cash = Instance.new("IntValue", leaderstats)
	cash.Name = "Cash"

	local tycoonData = Instance.new("Folder", player)
	tycoonData.Name = "TycoonData"

	local incomeLevel = Instance.new("IntValue", tycoonData)
	incomeLevel.Name = "IncomeLevel"
	incomeLevel.Value = 0

	-- ЗАГРУЗКА ДАННЫХ
	local playerUserId = "Player_" .. player.UserId
	local data
	local success, err = pcall(function() data = myDataStore:GetAsync(playerUserId) end)

	if success and data then
		cash.Value = data.Cash or 200
		incomeLevel.Value = data.IncomeLevel or 0
	else
		cash.Value = 200
		incomeLevel.Value = 0
	end
end)

game.Players.PlayerRemoving:Connect(function(player)
	if not player.leaderstats or not player.TycoonData then return end
	local dataToSave = {
		Cash = player.leaderstats.Cash.Value,
		IncomeLevel = player.TycoonData.IncomeLevel.Value
	}
	pcall(function() myDataStore:SetAsync("Player_" .. player.UserId, dataToSave) end)
end)