-- LeaderstatsManager — экономика игрока (деньги и прогресс)
-- Что делает: создаёт счётчик денег и уровень дохода, сохраняет/загружает из DataStore

local DataStoreService = game:GetService("DataStoreService")
local myDataStore = DataStoreService:GetDataStore("MyTycoonDataStore_v2")

game.Players.PlayerAdded:Connect(function(player)
	-- Папка leaderstats — Roblox сам показывает её содержимое в Leaderboard (Tab)
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"

	-- Cash — сколько денег у игрока. Начало: 200
	local cash = Instance.new("IntValue", leaderstats)
	cash.Name = "Cash"

	-- TycoonData — скрытые данные прогресса (не видны в Leaderboard)
	local tycoonData = Instance.new("Folder", player)
	tycoonData.Name = "TycoonData"

	-- IncomeLevel — сколько раз прокачал доход (0 = не покупал дроппер)
	local incomeLevel = Instance.new("IntValue", tycoonData)
	incomeLevel.Name = "IncomeLevel"
	incomeLevel.Value = 0

	-- ЗАГРУЗКА СОХРАНЕНИЙ
	local playerUserId = "Player_" .. player.UserId
	local data
	local success, err = pcall(function() data = myDataStore:GetAsync(playerUserId) end)

	if success and data then
		-- Если есть сохранение — восстанавливаем деньги и уровень
		cash.Value = data.Cash or 200
		incomeLevel.Value = data.IncomeLevel or 0
	else
		-- Новичку даём 200 монет
		cash.Value = 200
		incomeLevel.Value = 0
	end
end)

-- СОХРАНЕНИЕ ПРИ ВЫХОДЕ
game.Players.PlayerRemoving:Connect(function(player)
	if not player.leaderstats or not player.TycoonData then return end
	local dataToSave = {
		Cash = player.leaderstats.Cash.Value,
		IncomeLevel = player.TycoonData.IncomeLevel.Value
	}
	pcall(function() myDataStore:SetAsync("Player_" .. player.UserId, dataToSave) end)
end)
