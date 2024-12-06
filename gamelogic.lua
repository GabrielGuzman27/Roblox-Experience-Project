local MyMod = {}

MyMod.PlayerCount = function()
	while #game.Players:GetPlayers() < 2 do
		local status = game.ReplicatedStorage.Status
		status.Value = "Need at least two players to begin!"
		wait(1)
	end
end

MyMod.GameLogic = function()
	--Variables
	local MemoryStoreService = game:GetService("MemoryStoreService")
	local QueueModule = require(game.ServerScriptService.QueueModule)
	local status = game.ReplicatedStorage.Status
	local maps = game.ReplicatedStorage.Maps
	local IsIntermission = game.Workspace:WaitForChild("IsIntermission")
	local countdown = game.Workspace.GameMusic.Countdown
	--Modules
	local obbyModule = require(script.Parent.GameModes:WaitForChild("Obby"))
	local sfModule = require(script.Parent.GameModes:WaitForChild("Sword Fight"))
	local tsfModule = require(script.Parent.GameModes:WaitForChild("Team Sword Fight"))
	local spleefModule = require(script.Parent.GameModes:WaitForChild("Spleef"))
	local endzoneModule = require(script.Parent.GameModes:WaitForChild("Endzone"))
	local spinnerModule = require(script.Parent.GameModes:WaitForChild("Spinner"))
	local HexModule  = require(script.Parent.GameModes:WaitForChild("Hex"))
	local infectModule = require(script.Parent.GameModes:WaitForChild("Infection"))
	local FCModule = require(script.Parent.GameModes:WaitForChild("FourCorners"))
	local PunchoutModule = require(script.Parent.GameModes:WaitForChild("Punchout"))
	local FloodModule = require(script.Parent.GameModes:WaitForChild("FloodEscape"))
	local TimebombModule = require(script.Parent.GameModes:WaitForChild("Timebomb"))
	local RollerballModule = require(script.Parent.GameModes:WaitForChild("RollerBall"))
	local RollerballDerbyModule = require(script.Parent.GameModes:WaitForChild("RollerballDerby"))
	local DisappearingPlatformsModule = require(script.Parent.GameModes:WaitForChild("DisappearingPlatforms"))
	local CrusherModule = require(script.Parent.GameModes:WaitForChild("Crusher"))
	local DodgeballModule = require(script.Parent.GameModes:WaitForChild("Dodgeball"))
	local purchased = false
	
	while true do
		purchased = false
		IsIntermission.Value = true
		for i = 10, 0, -1 do
			status.Value = "Intermission: " .. i
			if #game.Players:GetPlayers() < 2 then
				MyMod.PlayerCount()
			end
			wait(1)
			if i == 4 then
				countdown:Play()
			end
		end
		
		local success, err = pcall(function()
			print("Attempting to read queue")
			local items, id = QueueModule.Queue:ReadAsync(1, false, 0)
			if #items > 0 then
				QueueModule.Queue:RemoveAsync(id)
				print("Removed from queue")
				purchased = true
				local map = maps:FindFirstChild(items[1]):Clone()
				map.Parent = workspace
				status.Value = "The next purchased game mode is " .. map.Name
				
			end
		end)
		
		if success then
			print("Successfully read chosen minigame from queue")
		else
			warn("Minigame not found in queue.")
		end
		
		if purchased == false then
			local rand = math.random(1, #maps:GetChildren()) -- randomize 1 though number of maps
			local map = maps:GetChildren()[rand]:Clone() -- 
			map.Parent = workspace -- set map in workspace
			status.Value = "The next game mode is " .. map.Name
		end	
	
		wait(2)
		IsIntermission.Value = false
		local success, err = pcall(function()
			if game.Workspace:FindFirstChild("Obby") and obbyModule then
				obbyModule.ObbyRules()
			elseif game.Workspace:FindFirstChild("Sword Fight") and sfModule then
				sfModule.SwordFight()
			elseif game.Workspace:FindFirstChild("Team Sword Fight") and tsfModule then
				tsfModule.GameRules()
			elseif game.Workspace:FindFirstChild("Spleef") and spleefModule then
				spleefModule.Spleef()
			elseif game.Workspace:FindFirstChild("Endzone") and endzoneModule then
				endzoneModule.Endzone()
			elseif game.Workspace:FindFirstChild("Spinner") and spinnerModule then
				spinnerModule.Spinner()
			elseif game.Workspace:FindFirstChild("Hex") and HexModule then
				HexModule.Hex()
			elseif game.Workspace:FindFirstChild("Infection") and infectModule then
				infectModule.Infection()
			elseif game.Workspace:FindFirstChild("Four Corners") and FCModule then
				FCModule.FourCorners()
			elseif game.Workspace:FindFirstChild("Punchout") and PunchoutModule then
				PunchoutModule.Punchout()
			elseif game.Workspace:FindFirstChild("Flood Escape") and FloodModule then
				FloodModule.Main()
			elseif game.Workspace:FindFirstChild("Timebomb") and TimebombModule then
				TimebombModule.Timebomb()
			elseif game.Workspace:FindFirstChild("Rollerball") and RollerballModule then
				RollerballModule.Rollerball()
			elseif game.Workspace:FindFirstChild("Rollerball Derby") and RollerballDerbyModule then
				RollerballDerbyModule.RollerballDerby()
			elseif game.Workspace:FindFirstChild("Disappearing Platforms") and DisappearingPlatformsModule then
				DisappearingPlatformsModule.DisappearingPlatforms()
			elseif game.Workspace:FindFirstChild("Crusher") and CrusherModule then
				CrusherModule.Crusher()
			elseif game.Workspace:FindFirstChild("Dodgeball") and DodgeballModule then
				DodgeballModule.Dodgeball()
			end
		end)
	end
end	
	
	
return MyMod
