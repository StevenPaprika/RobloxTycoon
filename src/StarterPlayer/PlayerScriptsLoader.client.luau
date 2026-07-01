-- PlayerScriptsLoader — загрузчик стандартных скриптов игрока
-- Что делает: запускает PlayerModule (встроенный модуль Roblox для управления персонажем)
-- Не трогать — системный файл

require(script.Parent:WaitForChild("PlayerModule"))
