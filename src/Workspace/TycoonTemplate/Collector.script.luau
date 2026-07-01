-- Collector — сборщик монеток
-- Что делает: когда монетка касается коллектора, зачисляет деньги игроку и удаляет монетку

local collector = script.Parent
local tycoon = collector.Parent
local ownerValue = tycoon:FindFirstChild("Owner")

local function onTouch(hit)
	local parentModel = hit.Parent
	if not parentModel or not parentModel:IsA("Model") then
		return
	end

	-- Ищем у монетки значение CashValue (сколько денег она даёт)
	local cashValue = parentModel:FindFirstChild("CashValue")

	if cashValue then
		local owner = ownerValue.Value
		if owner then
			local leaderstats = owner:FindFirstChild("leaderstats")
			local cash = leaderstats and leaderstats:FindFirstChild("Cash")

			if cash then
				cash.Value = cash.Value + cashValue.Value  -- зачисляем деньги
				parentModel:Destroy()  -- удаляем монетку
			end
		end
	end
end

collector.Touched:Connect(onTouch)
