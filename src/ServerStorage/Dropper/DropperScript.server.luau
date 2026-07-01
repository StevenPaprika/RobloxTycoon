-- DropperScript
local dropper = script.Parent
local dropPartSpawnPoint = dropper:FindFirstChild("Сопло")
local ServerStorage = game:GetService("ServerStorage")
local moneyPartTemplate = ServerStorage:FindFirstChild("MoneyCoin")
local Debris = game:GetService("Debris")
local tycoon = dropper:FindFirstAncestorOfClass("Model")
local incomeChangedEvent = Instance.new("BindableEvent", script)
incomeChangedEvent.Name = "IncomeChanged"

if not dropPartSpawnPoint or not moneyPartTemplate or not tycoon then return end

local incomeMultiplier = tycoon:FindFirstChild("IncomeMultiplier")
local currentIncome = 1

local function updateIncome()
	if incomeMultiplier then currentIncome = incomeMultiplier.Value end
end

updateIncome()
incomeChangedEvent.Event:Connect(updateIncome)

while task.wait(1) do
	local newMoneyPart = moneyPartTemplate:Clone()
	newMoneyPart:SetPrimaryPartCFrame(dropPartSpawnPoint.CFrame)
	newMoneyPart.Parent = game.Workspace

	for _, part in ipairs(newMoneyPart:GetDescendants()) do
		if part:IsA("BasePart") then part:SetNetworkOwner(nil) end
	end

	local cashValue = Instance.new("IntValue", newMoneyPart)
	cashValue.Name = "CashValue"
	cashValue.Value = currentIncome
	Debris:AddItem(newMoneyPart, 30)
end