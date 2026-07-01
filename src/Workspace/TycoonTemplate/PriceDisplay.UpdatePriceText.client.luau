-- PriceDisplay — обновление текста на табличке покупки дроппера
-- Что делает: показывает цену дроппера (берётся из BuyDropperButton.Price)

local surfaceGui = script.Parent
local tycoon = surfaceGui.Parent.Parent

local priceValue = tycoon:FindFirstChild("BuyDropperButton"):FindFirstChild("Price")
local textLabel = surfaceGui:FindFirstChild("SignFrame"):FindFirstChild("PriceLabel")

if priceValue and textLabel then
	textLabel.Text = "$ " .. priceValue.Value
end

-- Скрипт одноразовый — удаляем после выполнения
script:Destroy()
