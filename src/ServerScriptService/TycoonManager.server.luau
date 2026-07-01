-- TycoonManager — главный управляющий тайкунами
-- Что делает: выдаёт тайкун игроку, восстанавливает при выходе, настраивает улучшения

local Players = game:GetService("Players")
local TycoonsFolder = game.Workspace:FindFirstChild("Tycoons")
local ServerStorage = game:GetService("ServerStorage")

if not TycoonsFolder then return end

-- Кешируем слепки тайкунов (все детки кроме Owner и IncomeMultiplier)
-- чтобы при перезаходе восстановить тайкун в исходное состояние
local tycoonTemplates = {}
for _, tycoon in ipairs(TycoonsFolder:GetChildren()) do
	if tycoon:IsA("Model") then
		local template = {}
		for _, child in ipairs(tycoon:GetChildren()) do
			if child.Name ~= "Owner" and child.Name ~= "IncomeMultiplier" then
				template[child.Name] = child:Clone()
			end
		end
		tycoonTemplates[tycoon.Name] = template
	end
end

-- Сброс тайкуна в исходное состояние (когда игрок выходит)
local function restoreTycoon(tycoon)
	local template = tycoonTemplates[tycoon.Name]
	if not template then return end

	tycoon.Owner.Value = nil                    -- тайкун снова свободен
	tycoon.IncomeMultiplier.Value = 1           -- доход сбрасывается на 1

	-- Удаляем дроппер (монетницу), если он есть
	local dropper = tycoon:FindFirstChild("Dropper")
	if dropper then dropper:Destroy() end

	-- Восстанавливаем все удалённые объекты (кнопки, таблички и т.д.)
	for name, clonedPart in template do
		if not tycoon:FindFirstChild(name) then
			clonedPart:Clone().Parent = tycoon
		end
	end

	-- Прячем кнопку улучшения дохода и отключаем её скрипт
	local upgradeBtn = tycoon:FindFirstChild("UpgradeIncomeButton")
	if upgradeBtn then
		upgradeBtn.Transparency = 1
		local btnScript = upgradeBtn:FindFirstChildOfClass("Script")
		if btnScript then btnScript.Disabled = true end
	end

	-- Прячем табличку улучшения (она станет видна только при входе с прогрессом)
	local upgradeDisp = tycoon:FindFirstChild("UpgradePriceDisplay")
	if upgradeDisp then upgradeDisp.Transparency = 1 end
end

-- Настройка тайкуна для конкретного игрока (выдаётся при заходе)
local function setupTycoonForPlayer(tycoon, player)
	local tycoonData = player:WaitForChild("TycoonData")
	local incomeLevel = tycoonData:WaitForChild("IncomeLevel")

	tycoon.Owner.Value = player
	-- Множитель дохода: 1 + уровень * 100 (1 = $1 за монетку, 101 = $101 за монетку)
	tycoon.IncomeMultiplier.Value = 1 + (incomeLevel.Value * 100)

	-- Если у игрока уже был прогресс (покупал дроппер)
	if incomeLevel.Value > 0 then
		-- Создаём дроппер из шаблона в ServerStorage
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

		-- Убираем старые объекты первой покупки (они больше не нужны)
		if tycoon:FindFirstChild("BuyDropperButton") then tycoon.BuyDropperButton:Destroy() end
		if tycoon:FindFirstChild("DropperSpawnLocation") then tycoon.DropperSpawnLocation:Destroy() end
		if tycoon:FindFirstChild("PriceDisplay") then tycoon.PriceDisplay:Destroy() end

		-- Показываем кнопку улучшения дохода
		local upgradeBtn = tycoon:FindFirstChild("UpgradeIncomeButton")
		if upgradeBtn then
			upgradeBtn.Transparency = 0
			local btnScript = upgradeBtn:FindFirstChildOfClass("Script")
			if btnScript then btnScript.Disabled = false end
			-- Цена улучшения: 500 + уровень * 100 (500, 600, 700...)
			local priceVal = upgradeBtn:FindFirstChild("Price")
			if priceVal then priceVal.Value = 500 + (incomeLevel.Value * 100) end
		end

		-- Табличка улучшения остаётся прозрачной — виден только текст на ней
	end
end

-- Когда игрок заходит — ищем его тайкун (или свободный) и настраиваем
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		task.wait(2)

		-- Сначала ищем тайкун где этот игрок уже был
		for _, tycoon in ipairs(TycoonsFolder:GetChildren()) do
			if tycoon.Owner.Value == player then
				setupTycoonForPlayer(tycoon, player)
				return
			end
		end

		-- Если своего нет — берём свободный
		for _, tycoon in ipairs(TycoonsFolder:GetChildren()) do
			if not tycoon.Owner.Value then
				setupTycoonForPlayer(tycoon, player)
				return
			end
		end
	end)
end)

-- Когда игрок выходит — возвращаем тайкун в исходное состояние
Players.PlayerRemoving:Connect(function(player)
	for _, tycoon in ipairs(TycoonsFolder:GetChildren()) do
		if tycoon:IsA("Model") then
			local ownerValue = tycoon:FindFirstChild("Owner")
			if ownerValue and ownerValue.Value == player then
				restoreTycoon(tycoon)
				break
			end
		end
	end
end)
