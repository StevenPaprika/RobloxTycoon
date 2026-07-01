-- UpdatePriceText for Upgrade Button
local billboardGui = script.Parent
local tycoon = billboardGui.Parent.Parent

local buttonToCheck = tycoon:FindFirstChild("UpgradeIncomeButton")
local textLabel = billboardGui:FindFirstChild("SignFrame2"):FindFirstChild("PriceLabel2")

if buttonToCheck and textLabel then
	local priceValue = buttonToCheck:FindFirstChild("Price")
	if priceValue then
		textLabel.Text = "$ " .. priceValue.Value
	end
end

script:Destroy()