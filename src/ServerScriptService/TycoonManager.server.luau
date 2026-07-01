-- TycoonManager
local Players = game:GetService("Players")
local TycoonsFolder = game.Workspace:FindFirstChild("Tycoons")
local ServerStorage = game:GetService("ServerStorage")

if not TycoonsFolder then return end

-- Функция для постройки или улучшения
local function setupTycoonForPlayer(tycoon, player)
	local tycoonData = player:WaitForChild("TycoonData")
	local incomeLevel = tycoonData:WaitForChild("IncomeLevel")

	tycoon.Owner.Value = player
	tycoon.IncomeMultiplier.Value = 1 + (incomeLevel.Value * 100)

	if incomeLevel.Value > 0 then
		if not tycoon:FindFirstChild("Dropper") then
			local template = ServerStorage:FindFirstChild("Dropper")
			local spawnLoc = tycoon:FindFirstChild("DropperSpawnLocation")
			if template and spawnLoc then
				local newDropper = template:Clone()
				newDropper.Parent = tycoon
				newDropper.DropperScript.Disabled = false
				newDropper:SetPrimaryPartCFrame(spawnLoc.CFrame)
			end
		end

		if tycoon:FindFirstChild("BuyDropperButton") then tycoon.BuyDropperButton:Destroy() end
		if tycoon:FindFirstChild("DropperSpawnLocation") then tycoon.DropperSpawnLocation:Destroy() end
		if tycoon:FindFirstChild("PriceDisplay") then tycoon.PriceDisplay:Destroy() end
		if tycoon:FindFirstChild("UpgradeIncomeButton") then tycoon.UpgradeIncomeButton:Destroy() end
		if tycoon:FindFirstChild("UpgradePriceDisplay") then tycoon.UpgradePriceDisplay:Destroy() end
	end
end

-- Назначаем тайкун
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		task.wait(2)

		for _, tycoon in ipairs(TycoonsFolder:GetChildren()) do
			if tycoon.Owner.Value == player then
				setupTycoonForPlayer(tycoon, player)
				return
			end
		end

		for _, tycoon in ipairs(TycoonsFolder:GetChildren()) do
			if not tycoon.Owner.Value then
				setupTycoonForPlayer(tycoon, player)
				return
			end
		end
	end)
end)

-- Освобождаем тайкун при выходе
Players.PlayerRemoving:Connect(function(player)
	for _, tycoon in ipairs(TycoonsFolder:GetChildren()) do
		if tycoon:IsA("Model") then
			local ownerValue = tycoon:FindFirstChild("Owner")
			if ownerValue and ownerValue.Value == player then
				tycoon.Owner.Value = nil
				tycoon.IncomeMultiplier.Value = 1
				break
			end
		end
	end
end)

-- Настройка PriceDisplay
for _, display in ipairs(tycoon:GetDescendants()) do
	if display.Name == "PriceDisplay" or display.Name == "UpgradePriceDisplay" then
		local gui = display:FindFirstChildOfClass("SurfaceGui")
		if gui then
			gui.Adornee = display
			gui.AlwaysOnTop = true
			local label = gui:FindFirstChildOfClass("TextLabel")
			if label then
				label.BackgroundTransparency = 1
				label.BorderSizePixel = 0
			end
		end
	end
end