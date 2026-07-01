-- BuyDropperButton — кнопка покупки первой монетницы (дроппера)
-- Что делает: тратит деньги, ставит дроппер в мир, убирает себя и открывает кнопку улучшения

local button = script.Parent
local tycoon = button.Parent
local ownerValue = tycoon:FindFirstChild("Owner")
local priceValue = button:FindFirstChild("Price")
local dropperTemplate = game.ServerStorage:FindFirstChild("Dropper")
local spawnLocation = tycoon:FindFirstChild("DropperSpawnLocation")
local myPriceDisplay = tycoon:FindFirstChild("PriceDisplay")
local nextButton = tycoon:FindFirstChild("UpgradeIncomeButton")
local nextPriceDisplay = tycoon:FindFirstChild("UpgradePriceDisplay")

local function onBuy(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if not player or ownerValue.Value ~= player then return end

	local cash = player.leaderstats and player.leaderstats.Cash
	if not cash or not priceValue then return end

	if cash.Value >= priceValue.Value then
		cash.Value -= priceValue.Value

		-- Создаём дроппер на месте спавна
		local newDropper = dropperTemplate:Clone()
		newDropper.Parent = tycoon
		newDropper:SetPrimaryPartCFrame(spawnLocation.CFrame)
		newDropper.DropperScript.Disabled = false

		-- Открываем кнопку улучшения дохода (становится видна)
		-- Табличка с ценой остаётся прозрачной — виден только текст
		nextButton.Transparency = 0
		nextButton.Script.Disabled = false

		-- Удаляем кнопку покупки, спавн и ценник (они больше не нужны)
		button:Destroy()
		spawnLocation:Destroy()
		myPriceDisplay:Destroy()
	end
end

button.Touched:Connect(onBuy)
