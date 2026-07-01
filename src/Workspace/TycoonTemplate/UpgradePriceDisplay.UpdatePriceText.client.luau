local surfaceGui = script.Parent
local tycoon = surfaceGui.Parent.Parent

local upgradeButton = tycoon:FindFirstChild("UpgradeIncomeButton")
local priceValue = upgradeButton and upgradeButton:FindFirstChild("Price")
local incomeMultiplier = tycoon:FindFirstChild("IncomeMultiplier")
local textLabel = surfaceGui:FindFirstChild("SignFrame"):FindFirstChild("PriceLabel")

local function updateDisplay()
	if not priceValue or not textLabel then return end
	local mult = incomeMultiplier and incomeMultiplier.Value or 1
	textLabel.Text = string.format("UPGRADE  $%d\nINCOME   +$%d", priceValue.Value, mult)
end

if priceValue then
	priceValue.Changed:Connect(updateDisplay)
end
if incomeMultiplier then
	incomeMultiplier.Changed:Connect(updateDisplay)
end

updateDisplay()