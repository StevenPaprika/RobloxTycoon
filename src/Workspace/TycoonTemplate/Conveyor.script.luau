-- Conveyor Script
local conveyor = script.Parent
local moveSpeed = Vector3.new(20, 0, 0)
conveyor.AssemblyLinearVelocity = moveSpeed
script:Destroy()