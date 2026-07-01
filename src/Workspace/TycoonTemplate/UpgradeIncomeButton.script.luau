-- UpgradeIncomeButton — кнопка улучшения дохода
-- Что делает: тратит деньги игрока, повышает множитель дохода на +100 за каждый уровень
-- Цена растёт: 500 → 600 → 700 → ... (+100 за каждый апгрейд)

local button = script.Parent
local tycoon = button.Parent
local ownerValue = tycoon:FindFirstChild("Owner")
local priceValue = button:FindFirstChild("Price")
local incomeMultiplier = tycoon:FindFirstChild("IncomeMultiplier")

local function onUpgrade(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if not player or ownerValue.Value ~= player then return end

	local cash = player.leaderstats and player.leaderstats.Cash
	if not cash or not priceValue or not incomeMultiplier then return end

	-- Проверяем, хватает ли денег
	if cash.Value >= priceValue.Value then
		cash.Value -= priceValue.Value  -- списываем цену улучшения

		-- Повышаем уровень дохода
		local incomeLevel = player.TycoonData and player.TycoonData.IncomeLevel
		if incomeLevel then
			incomeLevel.Value += 1
			-- Множитель = 1 + уровень * 100
			-- На 1 уровне: +100 к каждой монетке
			-- На 2 уровне: +200 к каждой монетке
			incomeMultiplier.Value = 1 + (incomeLevel.Value * 100)
		end

		-- Сообщаем дропперу, что доход изменился (монетки начнут падать с новой суммой)
		local dropper = tycoon:FindFirstChild("Dropper")
		if dropper and dropper:FindFirstChild("DropperScript") then
			local incomeEvent = dropper.DropperScript:FindFirstChild("IncomeChanged")
			if incomeEvent then incomeEvent:Fire() end
		end

		-- Следующий апгрейд дороже на 100
		priceValue.Value += 100
	end
end

button.Touched:Connect(onUpgrade)
