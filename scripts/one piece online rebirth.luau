--	Opor nico robin feet script -- WIP

if not game:IsLoaded() then game.Loaded:Wait() end

local PlayerService = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local client:Player = PlayerService.LocalPlayer
local client_character:Model = client.Character or client.CharacterAdded:Wait()
local client_humanoid:Humanoid = client_character:WaitForChild("Humanoid")
local client_rootpart:Part = client_character:WaitForChild("HumanoidRootPart")
local client_camera:Camera = workspace.CurrentCamera

client.CharacterAdded:Connect(function(model)
	client_character = model
	client_humanoid = model:WaitForChild("Humanoid")
	client_rootpart = model:WaitForChild("HumanoidRootPart")
end)

local chestfolder = workspace.Chests
local actors = workspace.Players
local locations = loadstring(game:HttpGet("https://raw.githubusercontent.com/TaterZucks/opor/refs/heads/main/locationdata.luau"))()

local whitelisteditems = {
	"String String", "Dark Dark", "Rubber Rubber", "Shine Shine", "Flame Flame", "Magma Magma", "Thunder Thunder", "Quake Quake", "Venom Venom", "Buddha Buddha", "Magnet Magnet", "Operation Operation", "Phoenix Phoenix", "Leopard Leopard", "Combat", "Den Den Mushi", "CookBook",
}

local chestwhitelist = {"Chest_Golden", "Chest_Emerald"}

local admins = {
	"ImNotFatDad", "andrenyako", "NevermindAllen", "LoveMiraclez", "Flamingo60534", "Ampxtxte", "darbythedragon",
}

local fruits = {}
local chests = {}

local sea = "East Blue"
if workspace:FindFirstChild("OutfitShop") then
	sea = "Grand Line"
end

-- Initialize --

local ver = "1.1 (Rework)"
local Iris = loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/iris/refs/heads/main/Iris.luau"))()
local autoFarm = Iris.State(false)
local auto_Farm_Fruits = Iris.State(false)
local auto_Farm_Chests = Iris.State(false)
local auto_Farm_Npcs = Iris.State(false)
local auto_Farm_Quests = Iris.State(false)
local auto_Farm_ResetForKeys = Iris.State(false)
local auto_Farm_IgnoreFruitWhitelist = Iris.State(false)
local auto_Farm_IgnoreChestWhitelist = Iris.State(false)
local auto_Farm_PauseOnAdmin = Iris.State(true)
local auto_Farm_PauseOnCrystalSkull = Iris.State(true)
local auto_Farm_Delay = Iris.State(0.1)

local autoEat = Iris.State(true)

local notifyIfAdminJoins = Iris.State(true)
local notifyIfAdminLeaves = Iris.State(true)
local notifyIfFruitSpawned = Iris.State(true)

local stealth_Minimum_Range = Iris.State(200)
local keepNrfmOnTeleport = Iris.State(true)
local discordNotificationBot = Iris.State(false)

local selectedPlayer = Iris.State("")
local selectedFruit = Iris.State("")

local selectedTab = Iris.State(1)
local playerDataAllTreeShown = Iris.State(false)
local progress = Iris.State(0)

local eneldemonsetting = Iris.State("none")
local eneldemonslider = Iris.State(0.5)

local auto_Dodge_Macro_Selection = Iris.State(nil)
local auto_Dodge_Macro_Enabled = Iris.State(false)


local widgets = {}
local windowSize = Iris.State(Vector2.new(400, 400))

local ping = 0

local hui = gethui()

local nrfmfolder = hui:FindFirstChild("Nrfm")
if nrfmfolder then
	nrfmfolder:Destroy()
	print("destroyed")
end

nrfmfolder = Instance.new("Folder")
nrfmfolder.Name = "Nrfm"
nrfmfolder.Parent = hui
print(nrfmfolder.Parent.Name)

local function startTab(id, title)
	local tab = Iris.Tab({title})
	tab.Instance.Name = "Tab_" .. id
	widgets[id] = tab
	return tab.active()
end

local function formatMoney(amount:number)
	return tostring(amount):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local function teleportClient(cfr:CFrame)
	if client_rootpart and cfr then
		client_rootpart.CFrame = cfr
	end
end

local function getClientPosition()
	if client_rootpart then
		return client_rootpart.Position
	end
end

local function viewObject(object)
	if object and client_camera.CameraSubject ~= object then
		client_camera.CameraSubject = object
	else
		if client_humanoid then
			client_camera.CameraSubject = client_humanoid
		end
	end
end

local function getRootOfActor(actor:Model)
	return actor:FindFirstChild("HumanoidRootPart") or actor:FindFirstChild("RootPart")
end

local function getDistance(p1, p2)
	return (p1 - p2).Magnitude
end

client.OnTeleport:Connect(function()
	if keepNrfmOnTeleport.value == true then
		queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/TaterZucks/opor/refs/heads/main/src.luau'))()")
	end
end)

local notificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/xaxas-notification/src.lua"))();
local notifications = notificationLibrary.new({            
	NotificationLifetime = 10, 
	NotificationPosition = "Middle",

	TextFont = Enum.Font.Roboto,
	TextColor = Color3.fromRGB(255, 255, 255),
	TextSize = 15,

	TextStrokeTransparency = 0, 
	TextStrokeColor = Color3.fromRGB(0, 0, 0)
});

notifications:BuildNotificationUI();

local function startObjectSelection()
	local mouse = client:GetMouse()
	local islandpositions = workspace.IslandPositions
	local selected = nil

	local box = Instance.new("Highlight")
	box.FillColor = Color3.fromRGB(255, 255, 255)
	box.FillTransparency = 0.5
	box.OutlineColor = Color3.fromRGB(0, 255, 0)
	box.Parent = nrfmfolder
	
	notifications:Notify("Started selection")
	while selected == nil do
		local mouseTarget = mouse.Target
		local pos = mouse.Hit.Position
		if mouseTarget then
			
			local object = mouseTarget.Parent
			if islandpositions:FindFirstChild(object.Name) then
				object = nil
			end
			
			if object and object:IsA("Model") then
				
				box.Adornee = object
				mouse.Button1Down:Once(function()
					selected = object
				end)
			end
		end
		task.wait(0.01)
	end
	box:Destroy()
	notifications:Notify("Selected " .. selected.Name)
	return selected
end

local function getNearestIslandToPosition(pos:Vector3)
	local nearest = nil
	local nearestisland = nil
	local nearestDistance = math.huge
	for island,location:Vector3 in pairs(locations[sea]) do
		local distance = (location - pos).Magnitude
		if distance < nearestDistance then
			nearest = location
			nearestDistance = distance
			nearestisland = island
		end
	end
	return nearestisland
end

local function updateFruitList()
	table.clear(fruits)
	for _,v in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and not v:IsA("Tool") then
			
			local instaweld = v:FindFirstChild("InstaWeld")
			if instaweld then

				local fruit = nil
				for name,value in v:GetAttributes() do
					fruit = value
				end

				if v.Name ~= fruit and fruit ~= nil then
					v.Name = fruit

					local nearestisland = getNearestIslandToPosition(v:GetPivot().Position)
					notifications:Notify("Found " .. fruit .. " at " .. nearestisland .. "!");
				end

				table.insert(fruits, v)

			end 
		end
	end
end

local function getClientsKeys()
	local keys = {}
	for _, key in pairs(client.Backpack:GetChildren()) do
		if key.Name == "Key" then
			table.insert(keys, key)
		end
	end
	return keys
end

local function autoEatApple()
	local hunger = actors[client.Name].StomachV
	if hunger.Value < 140 then
		local function collectApple()
			local tree = nil
			if sea == "East Blue" then
				tree = workspace["Dawn Island"]:FindFirstChild("Apple Tree")
			else
				tree = workspace.Skypiea
			end

			for _, apple in tree:GetChildren() do
				if apple.Name == "Apple" and apple:FindFirstChild("ClickDetector") and apple.Transparency == 0 then
					fireclickdetector(apple:FindFirstChild("ClickDetector"))
					break
				end
			end
		end

		local apple = client.Backpack:FindFirstChild("Apple")

		if not apple then
			collectApple()
		end


		if client_character then
			if apple then
				client_humanoid:EquipTool(apple)
				task.wait(ping)
				while client_character:FindFirstChild("Apple") do
					local args = {
						"Eat"
					}
					game:GetService("Players").LocalPlayer.Character:WaitForChild("Apple"):WaitForChild("EatFoodItem"):FireServer(unpack(args))
					task.wait(1.5)	
				end

			end
		end
	end
end

local function getNearestPlayerToPosition(pos:Vector3, maxrange:number)
	local nearest = nil
	local nearestDistance = math.huge
	for _,v in pairs(game.Players:GetPlayers()) do
		if v ~= client then
			local character = v.Character
			if character and character:FindFirstChild("HumanoidRootPart") then
				local distance = (v.Character.HumanoidRootPart.Position - pos).Magnitude
				if distance < nearestDistance then
					nearest = v
					nearestDistance = distance
				end
			end
		end
	end
	if nearest and nearestDistance < stealth_Minimum_Range.value then
		return nearest
	end
	return nil
end

local function updateChestList()
	table.clear(chests)
	if #getClientsKeys() > 0 then
		table.insert(chestwhitelist, "Chest_Golden_Locked")
	end
	for _,v in pairs(chestfolder:GetChildren()) do
		if auto_Farm_IgnoreChestWhitelist.value == false then
			if table.find(chestwhitelist, v.Name) then
				local requiresstring = v:FindFirstChild("RequiresString")
				local cooldown = v:FindFirstChild("ClickCD")
				local active = v:FindFirstChild("Active").value
				if not cooldown and not requiresstring and active then
					table.insert(chests, v)
				end
			end
		else
			if v.Name:find("_Locked") == nil and not v:FindFirstChild("DirtPileChest") then
				table.insert(chests, v)
			else
				if v:FindFirstChild("DirtPileChest") then
					v:Destroy()
				end
			end
		end
	end
end

local function farmChests()
	local function collectChest(chest:Object)

		local pos = CFrame.new(chest:GetPivot().Position)
		
		local nearest = getNearestPlayerToPosition(chest:GetPivot().Position, stealth_Minimum_Range.value)
		if not nearest then
			local chestsToOpen = {}
			for _, c in chests do
				if not table.find(chestsToOpen, c) then
					if getDistance(pos.Position, c:GetPivot().Position) <= 5 then
						table.insert(chestsToOpen, c)
					end
				end
			end

			teleportClient(pos)
			task.wait(ping)
			local Main = chest:FindFirstChild("Main")
			if Main then
				local clickdetector = Main:FindFirstChild("ClickDetector")
				if clickdetector then
					local clickcd = chest:FindFirstChild("ClickCD")
					local active = chest:FindFirstChild("Active").value
					while not clickcd and active == true do
						task.wait(0.05)
						teleportClient(pos)
						
						if chest:FindFirstChild("Locked") then
							local keys = getClientsKeys()
							if #keys > 0 then
								local key = keys[1]
								local function unlock()
									client_humanoid:EquipTool(key)
									fireclickdetector(clickdetector)
									print("opened")
								end
								unlock()
								task.wait(0.1)
								fireclickdetector(clickdetector)
							end
						else
							fireclickdetector(clickdetector)
						end
						
						clickcd = chest:FindFirstChild("ClickCD")
						active = chest:FindFirstChild("Active").value
						table.remove(chests, table.find(chests, chest))

						for _, c in chestsToOpen do
							local Main = c:FindFirstChild("Main")
							local clickdetector = Main:FindFirstChildOfClass("ClickDetector")
							if clickdetector then
								fireclickdetector(clickdetector)
								clickcd = c:FindFirstChild("ClickCD")
								if clickcd then
									table.remove(chests, table.find(chests, c))
								end
							end
						end
					end
				end
			end
		end
	end
	
	local totalchests = #chests
	for _, chest in chests do
		collectChest(chest)
	end
end

local function farmFruits()
	local function collectFruit(fruit:Object)
		local pos = CFrame.new(fruit:GetPivot().Position)
		local nearest = getNearestPlayerToPosition(fruit:GetPivot().Position)
		if not nearest then
			teleportClient(pos)
			task.wait(ping)
			local handle = fruit:FindFirstChild("Handle")
			if handle then
				local clickdetector = handle:FindFirstChildOfClass("ClickDetector")
				if clickdetector then
					while handle and autoFarm.value do
						task.wait(0.01)
						teleportClient(pos) 
						fireclickdetector(clickdetector)
						handle = fruit:FindFirstChild("Handle")
					end
				end
			end
			local index = table.find(fruits, fruit)
			table.remove(fruits, index)
		end
	end

	for _, fruit in fruits do
		if not auto_Farm_IgnoreFruitWhitelist.value then
			if table.find(whitelisteditems, fruit.Name) then
				collectFruit(fruit)
			else
				collectFruit(fruit)
			end
		end
	end
end

function autoAttack(npc:Model)
	local humanoid:Humanoid = npc:FindFirstChild("Humanoid")

	while humanoid and humanoid.Health > 0 do

		task.wait(0.01)
		local pos = npc.HumanoidRootPart.Position
		local back = pos - (npc.HumanoidRootPart.CFrame.LookVector * 2)
		local finalpos = CFrame.new(back, pos)

		local combat = client_character:FindFirstChild("Combat")
		if not combat then
			combat = client.Backpack:FindFirstChild("Combat")	
			client_humanoid:EquipTool(combat)
		end

		if combat then
			local event = combat:FindFirstChild("CombatHandler"):FindFirstChild("M1")
			if event and client_rootpart then

				client_rootpart.CFrame = finalpos

				local partialinvincibility = npc:FindFirstChild("PartialInvincibility")
				if not partialinvincibility then
					local args = {
						"Combo",
						[3] = {
							HoldingRMB = false,
							DbgSeq = 29,
							DbgTime = 1794623696.744453
						}
					}
					event:FireServer(unpack(args))
				end
			end
		else
			print("no combat tool")
		end
	end
end

local function dropTool(tool:Tool)
	tool.Parent = client_character
	task.wait(0.05)
	tool.Parent = workspace
end

local function dropUnwantedTools()
	for _,v in pairs(client.Backpack:GetChildren()) do
		if not table.find(whitelisteditems, v.Name) then
			dropTool(v)
		end
	end
end

local function clickUIButton(button:TextButton)
	firesignal(button.MouseButton1Click)
end

local function buyKeys(amount:number)
	
	local disco = workspace.NPCs:FindFirstChild("Disco")
	local pos = CFrame.new(disco:GetPivot().Position)
	teleportClient(pos)
	task.wait(ping)
	
	local shop = nil
	
	local function openShop()
		local torso = disco:FindFirstChild("Torso")
		local prox = torso:FindFirstChild("ProximityPrompt")
		local button, dialogue = nil, nil
		while not shop do
			task.wait(0.01)
			
			if dialogue then
				button = dialogue.Background.DialogueOptionButton_Left
			else
				fireproximityprompt(prox)
				dialogue = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("DiscoDialogue")
			end
			if button then
				clickUIButton(button)
				shop = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Shop_Customizable")
			end
		end
	end
	
	local function buy()
		local keyButton = nil
		while not keyButton do
			task.wait(0.01)
			keyButton = shop.Scroll.ScrollingFrame:FindFirstChild("Key"):FindFirstChild("ClickButton")
		end
		print("found it")
		local objectName = shop.Main.ObjectName
		local buyButton = shop.Main.PURCHASE
		while objectName.Text ~= "Key" do
			task.wait(0.01)
			clickUIButton(keyButton)
			print("abc")
		end
		print("buy")
		for i = 1, amount do
			print("buying " .. i)
			task.wait(2)
			clickUIButton(buyButton)
		end
		
	end
	
	openShop()
	buy()
end

local function crashServer()
	local cd = {}
	local whitelist = {"Apple", "Corn", "DragonFruit"}
	for _, object in workspace:GetDescendants() do
		if object:IsA("ClickDetector") and table.find(whitelist, object.Parent.Name) then
			table.insert(cd, object)
		end
	end
	
	for _, cd in cd do
		fireclickdetector(cd)
		task.wait(0.01)
		dropUnwantedTools()
	end
end

local function renderFruitButtons(tbl)
	for _, fruitEntry in tbl do
		if Iris.Button(fruitEntry["name"] .. " (".. fruitEntry["nearestIsland"] .. ")").clicked() then
			teleportClient(CFrame.new(fruitEntry["instance"]:GetPivot().Position))
		end
	end
end

local function renderQuestFunctions()
	
	local function startQuest(npc:Model)
		local questFrame = client.PlayerGui.HUD.QuestFrame
		local dialogueAccept = nil
		
		local pos = CFrame.new(npc:GetPivot().Position)
		while questFrame.Visible == false do
			print("loop2")
			task.wait(0.01)
			local dialogue = client.PlayerGui:FindFirstChild("NPCDialogue")
			
			if dialogue then
				dialogueAccept = client.PlayerGui:FindFirstChild("NPCDialogue"):WaitForChild("Background"):WaitForChild("ButtonLeft")
			end

			if dialogueAccept then
				clickUIButton(dialogueAccept)
				if questFrame.Visible == true then
					print("started quest " .. npc.Name)
				end
			else
				teleportClient(pos)
				fireproximityprompt(npc.Torso.ProximityPrompt)
				task.wait(1)
			end

		end
		
		return true
	end
	
	local questFunctions = {
		["Shaman"] = function()
			local npc = workspace.NPCs.Shaman
			local island = workspace["Drago Island"]
			local crystalskull = workspace.DragoCrystalSkull
			local working = startQuest(npc)
			
			if working then
				local collected = 0
				while collected < 11 do
					print("loop")
					for _, tree in island:GetChildren() do
						if tree:IsA("Model") and tree.Name == "Dragon Fruit Tree" then
							for _, fruit in tree:GetChildren() do
								if fruit.Name == "DragonFruit" then
									local clickdetector = fruit:FindFirstChild("ClickDetector")
									if clickdetector then
										fireclickdetector(clickdetector)
										collected += 1
										task.wait(0.01)
									end
								end
							end
						end
					end
				end

				teleportClient(CFrame.new(crystalskull.Position))
				task.wait(ping)
				fireproximityprompt(crystalskull.ProximityPrompt)
				while actors:FindFirstChild("Tribesmen") do
					local npc = actors:FindFirstChild("Tribesmen")
					autoAttack(npc)
					task.wait(0.01)
				end
			end
			
		end,
		
		["Ryunosuke"] = function()
			local questnpc = workspace.NPCs.Ryunosuke
			local working = startQuest(questnpc)
			
			if working then
				local npc = actors:WaitForChild("Ryunosuke")
				autoAttack(npc)
			end
		end,
		
		["GoaKing"] = function()
			local questnpc = workspace.NPCs.GoaKing
			local target = workspace.NPCs:GetChildren()[98].Torso.ProximityPrompt
			local working = startQuest(questnpc)
			
			if working then
			
				local pos = CFrame.new(target.Parent.Position)
				teleportClient(pos)
				task.wait(ping)
				fireproximityprompt(target)
				
				local dialogue = client.PlayerGui:FindFirstChild("NPCDialogue")
				while not dialogue do
					fireproximityprompt(target)
					dialogue = client.PlayerGui:FindFirstChild("NPCDialogue")
					task.wait(0.1)
				end
				
				local dialogueAccept = dialogue.Background.ButtonLeft
				task.wait(3)
				clickUIButton(dialogueAccept)
			end
			
		end,
		
		["MarineSoldierJeremy"] = function()
			local questnpc = workspace.NPCs.MarineSoldierJeremy
			local working = startQuest(questnpc)
			
			if working then
				local function collectGarbage(garbage:Object)
					local prox = garbage:FindFirstChild("ProximityPrompt")
					local decal = garbage:FindFirstChild("Decal")
					local mop = client.Backpack:FindFirstChild("Mop")
					if mop then
						client_humanoid:EquipTool(mop)
					end

					teleportClient(CFrame.new(garbage.Position))
					task.wait(ping)

					while decal.Transparency == 0 do
						fireproximityprompt(prox)
						task.wait(0.01)
					end

				end

				for _, garbage in workspace:GetChildren() do
					if garbage.Name == "EwGarbage" then
						local decal = garbage:FindFirstChild("Decal")
						if decal and decal.Transparency == 0 then
							collectGarbage(garbage)
							task.wait(ping)
						end
					end
				end
			end
		end,
		
		
	}
	
	-- start quest
	local function completeQuest(quest)
		questFunctions[quest]()
		print("completed")
	end
	
	Iris.Tree({ "Auto Quest" })
	do
		for key, func in questFunctions do
			if Iris.Button({key}).clicked() then
				task.spawn(function()
					completeQuest(key)
				end)
			end
		end
	end
	Iris.End()
	
end

local function spawnEnelDemon(CF:CFrame, times:number, slider:number)
	for i = 1, times do
		local args = {
			"Forward",
			"Dash",
			CF,
			slider,
			false
		}
		game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Dash_Mobile"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
	end
end

local eneldemonFunctions = {
	["none"] = function() end,

	["mouse"] = function()
		local mouse = client:GetMouse()
		local pos = CFrame.new(mouse.Hit.Position)

		spawnEnelDemon(pos, 1, eneldemonslider.value)
	end,
	
	["epoic"] = function()
		local range = eneldemonslider.value
		local size = 16
		local startpos = CFrame.new(getClientPosition())
		for x = -range, range, size do
			for z = -range, range, size do
				local pos = CFrame.new(startpos.Position + Vector3.new(x, 0, z))
				spawnEnelDemon(pos, 1, eneldemonslider.value)
			end
		end
		task.wait(0.5)
	end,
	
	["all players"] = function()
		for _, player in game:GetService("Players"):GetPlayers() do
			local character = player.Character
			if character then
				local pos = CFrame.new(character:GetPivot().Position)
				local down = CFrame.new(pos.Position + Vector3.new(0, -20, 0))
				spawnEnelDemon(down, eneldemonslider.value, 100)
			end
		end
	end,
	
	["slenderman"] = function()
		local players = game:GetService("Players"):GetPlayers()
		local player = players[math.random(1, #players)]
		local character = player.Character
		if character then
			local lookvector = character:GetPivot().LookVector
			local pos = CFrame.new(character:GetPivot().Position + lookvector * 10)
			local randomized = CFrame.new(pos.Position + Vector3.new(math.random(-150, 150), 0, math.random(-150, 150))) 
			spawnEnelDemon(randomized, 1, eneldemonslider.value)
		end
		task.wait(1)
	end,
	
	["spawnbox"] = function()
		local pos = CFrame.new(11920.791015625, 37243.4375, 44496.36328125)
		spawnEnelDemon(pos, math.round(eneldemonslider.value), 100)
	end,
}

local function dodge()
	local args = {
		"Haki_Observation_Dodge",
		"Down",
		game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Haki"):WaitForChild("Haki_Local")
	}
	game:GetService("ReplicatedStorage"):WaitForChild("ActivateSkillClient"):FireServer(unpack(args))
end

local function loadmap()
	local a = locations[sea]
	local origin = CFrame.new(getClientPosition())
	for i, v:Vector3 in pairs(a) do

		local modif = 300
		if i == "UpperYard" then
			modif = 1100
		end
		task.wait(ping)
		teleportClient(CFrame.new(Vector3.new(v.X, v.Y - modif, v.Z)))
	end
	teleportClient(origin)
end

local mainLoop = true
Iris:Connect(function()
	ping = client:GetNetworkPing()
	Iris.Window({"NRFM By Drippleton " .. ver}, {size = windowSize})
	
	updateFruitList()
	updateChestList()
	
	Iris.TabBar({}, {index = selectedTab})
	do
		
		if startTab("self", "Self") then
			Iris.SameLine()
			do
				Iris.Text({"Ping: " .. math.round(ping * 1000) .. "ms"})
			end
			Iris.End()
			Iris.SeparatorText({"QoL"})
			Iris.SameLine()
			do
				if Iris.Button({"Reset"}).clicked() then
					if client_humanoid then
						client_humanoid.Health = 0
					end
				end
				if Iris.Button({"Drop unwanted tools"}).clicked() then
					task.spawn(function()
						dropUnwantedTools()
					end)
				end
				if Iris.Button( "Load map" ).clicked() then
					task.spawn(function()
						loadmap()
					end)
				end
			end
			Iris.End()
			
			Iris.Separator()
			Iris.Checkbox({"Auto Eat"}, {isChecked = autoEat})
			renderQuestFunctions()
			
			Iris.SeparatorText({"Teleporting"})
			Iris.Tree({ "Locations" })
			do
				for key, location in pairs(locations[sea]) do
					if Iris.Button({key}).clicked() then
						teleportClient(CFrame.new(location))
					end
				end
			end
			Iris.End()

			Iris.Tree({ "NPCs" })
			do
				for _, v in pairs(workspace.NPCs:GetChildren()) do
					if v:IsA("Model") then
						if Iris.Button({v.Name}).clicked() then
							teleportClient(CFrame.new(v:GetPivot().Position))
						end
					end
				end
			end
			Iris.End()
			Iris.Tree({ "Daily Quest NPCs" })
			do
				for _, v in pairs(workspace.NPCs:GetChildren()) do
					if v:IsA("Model") and v:FindFirstChild("Daily") then
						if Iris.Button({v.Name}).clicked() then
							teleportClient(CFrame.new(v:GetPivot().Position))
						end
					end
				end
			end
			Iris.End()
			
		end
		Iris.End()
		
		if startTab("farming", "Farming") then
			Iris.SeparatorText({"Toggles"})
			
			Iris.Text({"Auto Farm"})
			Iris.SameLine()
			do
				Iris.Checkbox({"Enabled"}, {isChecked = autoFarm})
				Iris.Checkbox({"Fruits"}, {isChecked = auto_Farm_Fruits})
				Iris.Checkbox({"Chests"}, {isChecked = auto_Farm_Chests})
				Iris.Checkbox({"NPCs"}, {isChecked = auto_Farm_Npcs})
				Iris.Checkbox({"Quests"}, {isChecked = auto_Farm_Quests})
			end
			Iris.End()
			
			Iris.SeparatorText({"Settings"})
			Iris.SameLine()
			do
				Iris.Checkbox({"Pause on admin"}, {isChecked = auto_Farm_PauseOnAdmin})
				Iris.Checkbox({"Pause on crystal skull"}, {isChecked = auto_Farm_PauseOnCrystalSkull})
			end
			Iris.End()
			
			Iris.SameLine()
			do
				Iris.Checkbox({"Ignore fruit whitelist"}, {isChecked = auto_Farm_IgnoreFruitWhitelist})
				Iris.Checkbox({"Ignore chest whitelist"}, {isChecked = auto_Farm_IgnoreChestWhitelist})
			end
			Iris.End()
			
			Iris.Checkbox({"Reset for keys"}, {isChecked = auto_Farm_ResetForKeys})
			Iris.SliderNum({"Stealth range", 1, 0, 500}, {number = stealth_Minimum_Range})
			
			local whitelistedfruits = {}
			local otherfruits = {}
			
			for _, fruit in fruits do
				local nearestIsland = getNearestIslandToPosition(fruit:GetPivot().Position)
				local fruitEntry = {["instance"] = fruit, ["name"] = fruit.Name, ["nearestIsland"] = nearestIsland}
				if table.find(whitelisteditems, fruit.Name) then
					table.insert(whitelistedfruits, fruitEntry)
				else
					table.insert(otherfruits, fruitEntry)
				end
			end
			
			Iris.SeparatorText({"Fruits"})

			Iris.Tree({ "Whitelisted" })
			renderFruitButtons(whitelistedfruits)
			Iris.End()
			
			Iris.Tree({ "All" })
			renderFruitButtons(otherfruits)
			Iris.End()
			
			Iris.SeparatorText({"Info"})
			Iris.Text({"Auto Farm"})
			Iris.ProgressBar({"Progress"}, {progress = progress})

			Iris.Separator() 
			Iris.Text({"Data"})
			Iris.Text({"Fruits: "..#fruits})
			Iris.Text({"Chests: "..#chests})
			
			Iris.SeparatorText({"Haki Farming"})
			Iris.Checkbox({"Dodge macro"}, {isChecked = auto_Dodge_Macro_Enabled})
			if Iris.Button({"Select marine"}).clicked() then
				task.spawn(function()
					local marine = startObjectSelection()
					if marine and marine.Name == "MarineSoldier" then
						auto_Dodge_Macro_Selection:set(marine)
						print("selected marine")
					end
				end)
			end
		end
		Iris.End()
		
		if startTab("players", "Players") then
			
			local function getAllPlayerNames()
				local names = {}
				for _, player in pairs(PlayerService:GetPlayers()) do
					table.insert(names, player.Name)
				end
				return names
			end
			
			Iris.SeparatorText({"Selection"})
			Iris.ComboArray({"Selected Player"}, {index = selectedPlayer}, getAllPlayerNames())
			local plr = game.Players:FindFirstChild(selectedPlayer.value)
			if plr and plr.Character then
				local root = getRootOfActor(actors:FindFirstChild(plr.Name))
				local nearestlocation, distance = "Unknown", "Unknown"
				if root then
					nearestlocation = getNearestIslandToPosition( root.Position )
					distance = getDistance(root.Position, getClientPosition())
				end
				Iris.Text({"Location: "..nearestlocation.. " | Distance: ".. math.round(distance)})
				
				Iris.SeparatorText({"Functions"})

				Iris.SameLine()
				do
					if Iris.Button({"Teleport"}).clicked() then
						if root then
							local cf = root.CFrame
							teleportClient(cf)
						end
					end
					
					if Iris.Button({"Teleport unanchored item"}).clicked() then
						print("placeholder")
					end

					if Iris.Button({"View"}).clicked() then
						local c = actors:FindFirstChild(plr.Name)
						if c then
							local humanoid = c:FindFirstChild("Humanoid")
							if humanoid then
								viewObject(humanoid)
							end
						end
					end
					
					if Iris.Button({"Attack"}).clicked() then
						task.spawn(function()
							autoAttack(actors:FindFirstChild(selectedPlayer.value))
						end)
					end
				end
				Iris.End()

				local function getPlayerData(plr:Player, only_targeted:boolean)
					if plr then
						local data = {}
						local targeted_data = {"PlayTime", "CurrentInventoryVal", "Style", "InCombat", "Sequence", "Role", "Faction", "CrewName", "DFType"}
						local character = actors:FindFirstChild(plr.Name)
						
						local rep = plr:FindFirstChild("Reputation")
						rep = formatMoney(rep.Value)
						table.insert(data, {"Reputation", rep})
						
						for i, v in pairs(plr:GetDescendants()) do
							if v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("StringValue") or v:IsA("BoolValue") then
								if only_targeted then
									if table.find(targeted_data, v.Name) then
										if v.Value ~= "" and v.Value ~= "nil" then
											table.insert(data, {v.Name, v.Value})
										end
									end
								else
									table.insert(data, {v.Name, v.Value})
								end
							end
						end

						if character and character:FindFirstChild("Humanoid") then
							for _, v in pairs(character:GetDescendants()) do
								if v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("StringValue") or v:IsA("BoolValue") then
									if only_targeted then
										if table.find(targeted_data, v.Name) then
											table.insert(data, {v.Name, v.Value})
										end
									else
										table.insert(data, {v.Name, v.Value})
									end
								end
							end
							table.insert(data, {"Health", character.Humanoid.Health})
						else
							table.insert(data, {"Load character for more data", ""})
						end
						return data
					end
				end
				
				Iris.SeparatorText({"Player data"})
				Iris.Indent()
				do
					Iris.Table( { 3, Iris.State(false), Iris.State(false), Iris.State(true), Iris.State(true) })
					do
						for _, data in pairs(getPlayerData(plr, true)) do
							Iris.TextWrapped({ data[1]..": "..tostring(data[2]) })
							Iris.NextColumn()
						end 

						Iris.Tree({ "All" }, {isUncollapsed = playerDataAllTreeShown})
						if playerDataAllTreeShown.value then
							for _, data in pairs(getPlayerData(plr, false)) do
								Iris.TextWrapped({ data[1]..": "..tostring(data[2]) })
							end
						end
						Iris.End()
					end
					Iris.End()
				end
				Iris.End()
			end
		end
		Iris.End()
		
		if startTab("trolling", "Trolling") then
			Iris.SeparatorText({"Epic"})
			local eneldemonsettings = {}
			for key, _ in pairs(eneldemonFunctions) do
				table.insert(eneldemonsettings, key)
			end
			Iris.ComboArray({"Selected Player"}, {index = eneldemonsetting}, eneldemonsettings)
			Iris.SliderNum({"Slider", 1, 0.5, 1000}, {number = eneldemonslider})
			Iris.SeparatorText({"Crashing"})
			
		end
		Iris.End()
		
		if startTab("settings", "Settings") then
			Iris.SeparatorText({"Preferences"})
		end
		Iris.End()
	end
	Iris.End()

	Iris.End()
	
	-- Main loop
	if mainLoop == true then
		mainLoop = false
		
		local mainLoopThread = task.spawn(function()
			-- Misc
			
			eneldemonFunctions[eneldemonsetting.value]()
			if eneldemonsetting.value ~= "none" then
				local del = workspace:FindFirstChild("TargetFilter")
				local del3 = client.PlayerScripts:FindFirstChild("SecondaryClientEffects")
				if client_character then
					local del2 = client_character:FindFirstChild("Animate")
					if del2 then
						del2:Destroy()
					end
				end
				if del then
					del:Destroy()
				end
				if del3 then
					del3:Destroy()
				end
			end
			
			if autoEat.value == true then
				autoEatApple()
			end
			
			while auto_Dodge_Macro_Enabled.value == true do
				if auto_Dodge_Macro_Selection.value ~= nil then
					local cache = auto_Dodge_Macro_Selection.value:FindFirstChild("Cache")
					local fireGun = cache:FindFirstChild("FireGun")
					if fireGun then
						dodge()
					end
				end
				task.wait(0.01)
			end
			
			-- Auto farm loop
			
			local admin = nil
			if auto_Farm_PauseOnAdmin.value then
				for _, plr in PlayerService:GetChildren() do
					if table.find(admins, plr.Name) then
						admin = plr
						print("admin in server")
						notifications:Notify("Admin in server, cheats paused")
					end
				end
			end
			
			if autoFarm.value == true and not admin then
				local origin = getClientPosition()
				if auto_Farm_Chests.value then
					farmChests()
				end
				
				if auto_Farm_Fruits.value then
					farmFruits()
				end
				teleportClient(CFrame.new(origin))
			end
			
			if auto_Farm_Npcs.value then				
				local bandit = actors:FindFirstChild("Bandit")
				if bandit then
					local humanoid = bandit:FindFirstChild("Humanoid")
					if humanoid.Health <= 0 then
						bandit:Destroy()
					else
						if bandit then
							autoAttack(bandit)
						end
					end
				end
			end
			
			if admin then
				mainLoop = false
				while PlayerService:FindFirstChild(admin) do
					task.wait(1)
				end
				notifications:Notify("Admin left, resuming cheats") 
				print("admin left")
			end
			mainLoop = true
		end)
		
	end
end)
