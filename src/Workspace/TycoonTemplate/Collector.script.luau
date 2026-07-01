-- Collector Script
local collector = script.Parent
local tycoon = collector.Parent
local ownerValue = tycoon:FindFirstChild("Owner")

local function onTouch(hit)
	local parentModel = hit.Parent
	if not parentModel or not parentModel:IsA("Model") then
		return
	end

	local cashValue = parentModel:FindFirstChild("CashValue")

	if cashValue then
		local owner = ownerValue.Value
		if owner then
			local leaderstats = owner:FindFirstChild("leaderstats")
			local cash = leaderstats and leaderstats:FindFirstChild("Cash")

			if cash then
				cash.Value = cash.Value + cashValue.Value
				parentModel:Destroy()
			end
		end
	end
end

collector.Touched:Connect(onTouch)