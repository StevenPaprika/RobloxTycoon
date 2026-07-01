-- DropperScript — автомат по печати денег
-- Что делает: раз в 1 секунду создаёт монетку, которая летит по конвейеру
-- Сумма денег на монетке = множитель дохода (1 + уровень * 100)

local dropper = script.Parent
local dropPartSpawnPoint = dropper:FindFirstChild("Сопло")          -- откуда вылетают монетки
local ServerStorage = game:GetService("ServerStorage")
local moneyPartTemplate = ServerStorage:FindFirstChild("MoneyCoin")  -- шаблон монетки
local Debris = game:GetService("Debris")
local tycoon = dropper:FindFirstAncestorOfClass("Model")
local incomeChangedEvent = Instance.new("BindableEvent", script)
incomeChangedEvent.Name = "IncomeChanged"

if not dropPartSpawnPoint or not moneyPartTemplate or not tycoon then return end

local incomeMultiplier = tycoon:FindFirstChild("IncomeMultiplier")
local currentIncome = 1  -- сколько денег даёт одна монетка

-- Обновляем сумму монетки при апгрейде дохода
local function updateIncome()
	if incomeMultiplier then currentIncome = incomeMultiplier.Value end
end

updateIncome()
incomeChangedEvent.Event:Connect(updateIncome)

-- Каждую секунду создаём монетку с текущим доходом
while task.wait(1) do
	local newMoneyPart = moneyPartTemplate:Clone()
	newMoneyPart:SetPrimaryPartCFrame(dropPartSpawnPoint.CFrame)
	newMoneyPart.Parent = game.Workspace

	for _, part in ipairs(newMoneyPart:GetDescendants()) do
		if part:IsA("BasePart") then part:SetNetworkOwner(nil) end
	end

	-- CashValue — сколько денег получит игрок, когда монетка упадёт в Collector
	local cashValue = Instance.new("IntValue", newMoneyPart)
	cashValue.Name = "CashValue"
	cashValue.Value = currentIncome
	Debris:AddItem(newMoneyPart, 30)  -- удалить монетку через 30 сек, чтоб не засоряла мир
end
