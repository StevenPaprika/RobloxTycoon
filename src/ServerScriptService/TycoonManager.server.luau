-- TycoonManager
local Players = game:GetService("Players")
local TycoonsFolder = game.Workspace:FindFirstChild("Tycoons")
local ServerStorage = game:GetService("ServerStorage")

if not TycoonsFolder then return end

local tycoonTemplates = {}
for _, tycoon in ipairs(TycoonsFolder:GetChildren()) do
	if tycoon:IsA("Model") then
		local template = {}
		for _, child in ipairs(tycoon:GetChildren()) do
			if child.Name ~= "Owner" and child.Name ~= "IncomeMultiplier" then
				template[child.Name] = child:Clone()
			end
		end
		tycoonTemplates[tycoon.Name] = template
	end
end

local function restoreTycoon(tycoon)
	local template = tycoonTemplates[tycoon.Name]
	if not template then return end

	tycoon.Owner.Value = nil
	tycoon.IncomeMultiplier.Value = 1

	local dropper = tycoon:FindFirstChild("Dropper")
	if dropper then dropper:Destroy() end

	for name, clonedPart in template do
		if not tycoon:FindFirstChild(name) then
			clonedPart:Clone().Parent = tycoon
		end
	end

	local upgradeBtn = tycoon:FindFirstChild("UpgradeIncomeButton")
	if upgradeBtn then
		upgradeBtn.Transparency = 1
		local btnScript = upgradeBtn:FindFirstChildOfClass("Script")
		if btnScript then btnScript.Disabled = true end
	end

	local upgradeDisp = tycoon:FindFirstChild("UpgradePriceDisplay")
	if upgradeDisp then upgradeDisp.Transparency = 1 end
end

local function setupTycoonForPlayer(tycoon, player)
	local tycoonData = player:WaitForChild("TycoonData")
	local incomeLevel = tycoonData:WaitForChild("IncomeLevel")

	tycoon.Owner.Value = player
	tycoon.IncomeMultiplier.Value = 1 + (incomeLevel.Value * 100)

	if incomeLevel.Value > 0 then
		if not tycoon:FindFirstChild("Dropper") then
			local template = ServerStorage:FindFirstChild("Dropper")
			local spawnLoc = tycoon:FindFirstChild("DropperSpawnLocation")
			if template and spawnLoc then
				local newDropper = template:Clone()
				newDropper.Parent = tycoon
				newDropper.DropperScript.Disabled = false
				newDropper:SetPrimaryPartCFrame(spawnLoc.CFrame)
			end
		end

		if tycoon:FindFirstChild("BuyDropperButton") then tycoon.BuyDropperButton:Destroy() end
		if tycoon:FindFirstChild("DropperSpawnLocation") then tycoon.DropperSpawnLocation:Destroy() end
		if tycoon:FindFirstChild("PriceDisplay") then tycoon.PriceDisplay:Destroy() end

		local upgradeBtn = tycoon:FindFirstChild("UpgradeIncomeButton")
		if upgradeBtn then
			upgradeBtn.Transparency = 0
			local btnScript = upgradeBtn:FindFirstChildOfClass("Script")
			if btnScript then btnScript.Disabled = false end
			local priceVal = upgradeBtn:FindFirstChild("Price")
			if priceVal then priceVal.Value = 500 + (incomeLevel.Value * 100) end
		end

		local upgradeDisp = tycoon:FindFirstChild("UpgradePriceDisplay")
		if upgradeDisp then upgradeDisp.Transparency = 0 end
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		task.wait(2)

		for _, tycoon in ipairs(TycoonsFolder:GetChildren()) do
			if tycoon.Owner.Value == player then
				setupTycoonForPlayer(tycoon, player)
				return
			end
		end

		for _, tycoon in ipairs(TycoonsFolder:GetChildren()) do
			if not tycoon.Owner.Value then
				setupTycoonForPlayer(tycoon, player)
				return
			end
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	for _, tycoon in ipairs(TycoonsFolder:GetChildren()) do
		if tycoon:IsA("Model") then
			local ownerValue = tycoon:FindFirstChild("Owner")
			if ownerValue and ownerValue.Value == player then
				restoreTycoon(tycoon)
				break
			end
		end
	end
end)