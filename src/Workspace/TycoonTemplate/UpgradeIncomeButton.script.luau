-- UpgradeIncomeButton
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

	if cash.Value >= priceValue.Value then
		cash.Value -= priceValue.Value

		local incomeLevel = player.TycoonData and player.TycoonData.IncomeLevel
		if incomeLevel then
			incomeLevel.Value += 1
			incomeMultiplier.Value = 1 + (incomeLevel.Value * 100)
		end

		local dropper = tycoon:FindFirstChild("Dropper")
		if dropper and dropper:FindFirstChild("DropperScript") then
			local incomeEvent = dropper.DropperScript:FindFirstChild("IncomeChanged")
			if incomeEvent then incomeEvent:Fire() end
		end

		priceValue.Value += 100
	end
end

button.Touched:Connect(onUpgrade)
