-- Conveyor — лента конвейера
-- Что делает: толкает монетки от дроппера к коллектору
-- Скорость: 20 по оси X (можно поменять, если монетки едут слишком медленно/быстро)

local conveyor = script.Parent
local moveSpeed = Vector3.new(20, 0, 0)
conveyor.AssemblyLinearVelocity = moveSpeed
script:Destroy()  -- скрипт одноразовый, скорость задана при старте
