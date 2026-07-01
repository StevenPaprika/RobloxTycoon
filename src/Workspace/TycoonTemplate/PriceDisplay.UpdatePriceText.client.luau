-- UpdatePriceText for Dropper Button
local surfaceGui = script.Parent
local tycoon = surfaceGui.Parent.Parent

local priceValue = tycoon:FindFirstChild("BuyDropperButton"):FindFirstChild("Price")
local textLabel = surfaceGui:FindFirstChild("SignFrame"):FindFirstChild("PriceLabel")

if priceValue and textLabel then
	textLabel.Text = "$ " .. priceValue.Value
end

script:Destroy()