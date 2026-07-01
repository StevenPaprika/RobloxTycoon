-- UpgradePriceDisplay — обновление текста на табличке улучшения
-- Что делает: показывает текущую цену апгрейда и сколько +$ даст следующий уровень

local surfaceGui = script.Parent
local tycoon = surfaceGui.Parent.Parent

local upgradeButton = tycoon:FindFirstChild("UpgradeIncomeButton")
local priceValue = upgradeButton and upgradeButton:FindFirstChild("Price")
local incomeMultiplier = tycoon:FindFirstChild("IncomeMultiplier")
local textLabel = surfaceGui:FindFirstChild("SignFrame"):FindFirstChild("PriceLabel")

local function updateDisplay()
	if not priceValue or not textLabel then return end
	local mult = incomeMultiplier and incomeMultiplier.Value or 1
	-- mult = 1 + level * 100 (сколько даёт одна монетка)
	textLabel.Text = string.format("UPGRADE  $%d\nINCOME   +$%d", priceValue.Value, mult)
end

-- Перерисовываем текст при изменении цены или множителя
if priceValue then
	priceValue.Changed:Connect(updateDisplay)
end
if incomeMultiplier then
	incomeMultiplier.Changed:Connect(updateDisplay)
end

updateDisplay()
