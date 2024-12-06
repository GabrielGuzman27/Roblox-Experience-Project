local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local MarketplaceService = game:GetService("MarketplaceService")
local winsDataStore = DataStoreService:GetOrderedDataStore("Wins")
local pointsDataStore = DataStoreService:GetOrderedDataStore("Points")
local gemsDataStore = DataStoreService:GetDataStore("Gems")
local equipped = DataStoreService:GetDataStore("Equipped")
local DataStoreOptions = Instance.new("DataStoreOptions")
DataStoreOptions.AllScopes = true
local InventoryStore = DataStoreService:GetDataStore("Inventory", "", DataStoreOptions)
local awardPointsModule = require(game:GetService("ServerScriptService"):WaitForChild("AwardPoints"))



local function setupEffectsOnJoin(player)
	local effect = Instance.new("StringValue")
	local effects = {"Balloon Effect", "Fire Effect", "Ice Effect", "Ghost Effect"}
	local event = game.ReplicatedStorage.Events.EffectsEvent

	effect.Parent = player
	effect.Name = "Effect"


	for i, v in pairs(script.Parent:getChildren()) do
		if v:IsA("MeshPart") or v:IsA("Part") then
			v.CollisionGroup = "Characters"
		end
	end

	event.OnServerEvent:Connect(function(player, effect)
		player.Character:FindFirstChild("Effect").Value = effect
	end)
end

local function InventorySetup(player)
	
	local inventoryFolder = Instance.new("Folder")
	inventoryFolder.Name = "inventory"
	inventoryFolder.Parent = player
	
	local balloonBool = Instance.new("BoolValue", inventoryFolder)
	balloonBool.Name = "BalloonEffect"
	local fireBool = Instance.new("BoolValue", inventoryFolder)
	fireBool.Name = "FireEffect"
	local freezeBool = Instance.new("BoolValue", inventoryFolder)
	freezeBool.Name = "FreezeEffect"
	local ghostBool = Instance.new("BoolValue", inventoryFolder)
	ghostBool.Name = "GhostEffect"
	local vipBool = Instance.new("BoolValue", inventoryFolder)
	vipBool.Name = "VIP"
	local boomboxBool = Instance.new("BoolValue", inventoryFolder)
	boomboxBool.Name = "Boombox"
	local walkspeedBool = Instance.new("BoolValue", inventoryFolder)
	walkspeedBool.Name = "Walkspeed"
	local Effect = player:WaitForChild("Effect")
	
	if MarketplaceService:UserOwnsGamePassAsync(player.UserId, 171922466) then -- VIP
		vipBool.Value = true
	end
	
	if MarketplaceService:UserOwnsGamePassAsync(player.userId, 171922699) then -- Boombox 
		boomboxBool.Value = true
	end
	
	
	local playerUserId = "Player_" .. player.UserId
	
	local BalloonEffectStore -- Balloon Effect
	local FireEffectStore -- Fire Effect
	local FreezeEffectStore -- Freeze Effect
	local GhostEffectStore -- Ghost Effect
	local WalkspeedStore
	local eq = ""
	
	local success, err = pcall(function() -- Get store
		BalloonEffectStore = InventoryStore:GetAsync("Items/Balloon/" .. playerUserId)
		FireEffectStore =  InventoryStore:GetAsync("Items/Fire/" .. playerUserId)
		FreezeEffectStore =  InventoryStore:GetAsync("Items/Freeze/" .. playerUserId)
		GhostEffectStore =  InventoryStore:GetAsync("Items/Ghost/" .. playerUserId)
		WalkspeedStore = InventoryStore:GetAsync("Items/Walkspeed/" .. playerUserId)
		eq = equipped:GetAsync(playerUserId)
	end)
	
	if success then -- Load current store value
		balloonBool.Value = BalloonEffectStore
		fireBool.Value = FireEffectStore
		freezeBool.Value = FreezeEffectStore 
		ghostBool.Value = GhostEffectStore 
		walkspeedBool.Value = WalkspeedStore
		Effect.Value = eq
	else
		warn(err)
	end
	
end

local function leaderboardSetup(player) -- Set up Wins, Points, and Gems + leaderboard
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local Wins = Instance.new("IntValue")
	Wins.Name = "Wins"
	Wins.Parent = leaderstats
	
	local Points = Instance.new("IntValue")
	Points.Name = "Points"
	Points.Parent = leaderstats
	
	local Gems = Instance.new("IntValue")
	Gems.Name = "Gems"
	Gems.Parent = leaderstats
	
	local questsFolder = Instance.new("Folder")
	questsFolder.Name = "Quests"
	questsFolder.Parent = player
	
	local PlayerUserId = "Player_" .. player.UserId
	
	--Load data
	
	local data -- Wins
	local data2 -- Points
	local data3 -- Gems
	local success, err = pcall(function()
		data = winsDataStore:GetAsync(PlayerUserId)
		data2 = pointsDataStore:GetAsync(PlayerUserId)
		data3 = gemsDataStore:GetAsync(PlayerUserId)
	end)
	if success then
		if data and data2 and data3 then
			Wins.Value = data
			Points.Value = data2
			Gems.Value = data3
			print("Wins, Points, and Gems loaded successfully.")
		elseif data and data2 and not data3 then
			Wins.Value = data
			Points.Value = data2
			Gems.Value = 0
			print("Wins and Points found, but not gems setting to default of 0.")
		elseif data and not data2 and not data3 then
			Wins.Value = data
			Points.Value = 0
			Gems.Value = 0
			print("Wins found, but not points and gems setting to default of 0.")
		elseif not data and data2 and data3 then
			Wins.Value = 0
			Points.Value = data2
			Gems.Value = data3
		else
			Wins.Value = 0 
			Points.Value = 0
			Gems.Value = 0
			print("Defaulting all values to 0.")
		end
	else
		warn("Cannot access player data.")
	end
end




local function SaveOnExit(player) -- Save all data
	
	local PlayerUserId = "Player_" .. player.UserId
	
	
	
	local data = { -- This is the boolean values
		Wins = player.leaderstats.Wins.Value,
		Points = player.leaderstats.Points.Value,
		Gems = player.leaderstats.Gems.Value,
		BalloonEffect = player.inventory.BalloonEffect.Value,
		FireEffect = player.inventory.FireEffect.Value,
		FreezeEffect = player.inventory.FreezeEffect.Value,
		GhostEffect = player.inventory.GhostEffect.Value,
		Walkspeed = player.inventory.Walkspeed.Value,
		currentEffect = player.Effect.Value,
	}
	
	local success, err = pcall(function()
		winsDataStore:SetAsync(PlayerUserId, data["Wins"])
		print("Wins saved")
		pointsDataStore:SetAsync(PlayerUserId, data["Points"])
		print("Points saved")
		gemsDataStore:SetAsync(PlayerUserId, data["Gems"])
		print("Gems saved")
		InventoryStore:SetAsync("Items/Balloon/" .. PlayerUserId, data["BalloonEffect"])
		print("Balloon Effect saved.")
		InventoryStore:SetAsync("Items/Fire/" .. PlayerUserId, data["FireEffect"]) 
		print("Fire Effect saved")
		InventoryStore:SetAsync("Items/Freeze/" .. PlayerUserId, data["FreezeEffect"])
		print("Freeze Effect saved")
		InventoryStore:SetAsync("Items/Ghost/" .. PlayerUserId, data["GhostEffect"])
		print("Ghost Effect saved")
		InventoryStore:SetAsync("Items/Walkspeed/".. PlayerUserId, data["Walkspeed"])
		print("Walkspeed saved")
		equipped:SetAsync(PlayerUserId, data["currentEffect"])
		print(data["currentEffect"] .. " is currently equipped on leave")
	end)
	
	if success then
		print("Data successfully saved.")
	else
		print("There was an error.")
		warn(err)
	end
	
	print("testing ended")
	
end


Players.PlayerAdded:Connect(setupEffectsOnJoin)

Players.PlayerRemoving:Connect(SaveOnExit)

Players.PlayerAdded:Connect(leaderboardSetup)

Players.PlayerAdded:Connect(InventorySetup)
