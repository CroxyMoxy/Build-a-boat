if not game.GameId == 210851291 then
    warn("This script is not for this game.")
end

local executeur = identifyexecutor()	

if not executeur then
	warn("Executor not found. Some features may not work.")
elseif not string.find(executeur, "Solara") then
	warn("This script is optimized for Solara executor. Some features may not work properly.")
end

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Character = player.Character or player.CharacterAdded:Wait()
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

local RunServiceValue

local AutoWinCanRun = true
local AutoWin = false
local AutoOpenBox = false

local ChestListe = {"Common Chest", "Uncommon Chest", "Rare Chest", "Epic Chest", "Legendary Chest",}
local ChestSelected = "Common Chest"
local ChestPrice = 5


local function Menu()
    local playerGui = player:WaitForChild("PlayerGui")

	local screenGui
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SilentMenu"
	screenGui.Parent = playerGui
	screenGui.ResetOnSpawn = false


	local Background = Instance.new("Frame")
	Background.Name = "Background"
	Background.Parent = screenGui
	Background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Background.Position = UDim2.new(0.5, -250, 0.5, -150)
	Background.Size = UDim2.new(0, 500, 0, 300)
	Background.ZIndex = 1
	Background.Visible = true

	local BackgroundCorner = Instance.new("UICorner")   
	BackgroundCorner.CornerRadius = UDim.new(0, 8)
	BackgroundCorner.Parent = Background

	local DragUi = Instance.new("UIDragDetector")
	DragUi.Parent = Background


	local Title = Instance.new("TextLabel")
	Title.Parent = Background
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.Size = UDim2.new(0, 200, 0, 40)
	Title.Text = "Silent Ghost | Build a boat | OPEN SOURCE"
	Title.TextColor3 = Color3.fromRGB(255, 0, 0)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 18


	local CloseButton = Instance.new("TextButton")
	CloseButton.Parent = Background
	CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	CloseButton.Position = UDim2.new(1, -35, 0, 5)
	CloseButton.Size = UDim2.new(0, 30, 0, 30)
	CloseButton.Text = "X"
	CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.Font = Enum.Font.GothamBold

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 6)
	CloseCorner.Parent = CloseButton


	local SideMenu = Instance.new("Frame")
	SideMenu.Name = "SideMenu"
	SideMenu.Parent = Background
	SideMenu.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	SideMenu.Position = UDim2.new(0, 10, 0, 50)
	SideMenu.Size = UDim2.new(0, 120, 0, 240)

	local MenuCorner = Instance.new("UICorner")
	MenuCorner.CornerRadius = UDim.new(0, 6)
	MenuCorner.Parent = SideMenu

	local MenuLayout = Instance.new("UIListLayout")
	MenuLayout.Parent = SideMenu
	MenuLayout.Padding = UDim.new(0, 5)
	MenuLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local PagesContainer = Instance.new("Frame")
	PagesContainer.Name = "PagesContainer"
	PagesContainer.Parent = Background
	PagesContainer.BackgroundTransparency = 1
	PagesContainer.Position = UDim2.new(0, 140, 0, 50)
	PagesContainer.Size = UDim2.new(0, 350, 0, 240)

	local function UpdateButtonText(button, baseText, state)
		if state then
			button.Text = baseText .. " (ON)"
			button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		else
			button.Text = baseText .. " (OFF)"
			button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		end
	end

	local function CreatePage(pageName, scroll)
		local Page = Instance.new("ScrollingFrame")
		Page.Name = pageName
		Page.Parent = PagesContainer
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.ScrollBarThickness = 6
		Page.Visible = false
		Page.CanvasSize = UDim2.new(0, 0, scroll, 0)

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Parent = Page
		PageLayout.Padding = UDim.new(0, 5)
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local PagePadding = Instance.new("UIPadding")
		PagePadding.Parent = Page
		PagePadding.PaddingTop = UDim.new(0, 5)
		PagePadding.PaddingLeft = UDim.new(0, 5)
		PagePadding.PaddingRight = UDim.new(0, 5)

		return Page
	end

	local function SwitchToPage(pageFrame)
		for _, child in pairs(PagesContainer:GetChildren()) do
			if child:IsA("ScrollingFrame") then
				child.Visible = false
			end
		end
		pageFrame.Visible = true
	end

	local function CreateMenuButton(text, linkedPage)
		local Btn = Instance.new("TextButton")
		Btn.Parent = SideMenu
		Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		Btn.Size = UDim2.new(1, 0, 0, 35)
		Btn.Text = text
		Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		Btn.Font = Enum.Font.Gotham
		Btn.TextSize = 14

		local BtnCorner = Instance.new("UICorner")
		BtnCorner.CornerRadius = UDim.new(0, 6)
		BtnCorner.Parent = Btn
		Btn.MouseButton1Click:Connect(function()
			SwitchToPage(linkedPage)
		end)
	end

	local function AddSectionTitle(parentPage, text, color)
		if not color then
			color = Color3.fromRGB(255, 100, 100)
		
		elseif color == "text" then
			color = Color3.fromRGB(200, 200, 200)
		end

		local TitleLabel = Instance.new("TextLabel")
		TitleLabel.Name = "SectionTitle"
		TitleLabel.Parent = parentPage
		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Size = UDim2.new(1, 0, 0, 25)
		TitleLabel.Text = text
		TitleLabel.TextColor3 = color
		TitleLabel.Font = Enum.Font.GothamBold
		TitleLabel.TextSize = 16
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	end

	local function AddSimpleOptionButton(parentPage, text, callback)
		local OptBtn = Instance.new("TextButton")
		OptBtn.Parent = parentPage
		OptBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		OptBtn.Size = UDim2.new(1, 0, 0, 40)
		OptBtn.Text = text
		OptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		OptBtn.Font = Enum.Font.Gotham
		OptBtn.TextSize = 14
		OptBtn.TextWrapped = true

		local OptCorner = Instance.new("UICorner")
		OptCorner.CornerRadius = UDim.new(0, 4)
		OptCorner.Parent = OptBtn

		OptBtn.MouseButton1Click:Connect(callback)
	end

	local function AddToggleButton(parentPage, baseText, initialState, onToggle)
		local OptBtn = Instance.new("TextButton")
		OptBtn.Parent = parentPage
		OptBtn.Size = UDim2.new(1, 0, 0, 40)
		OptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		OptBtn.Font = Enum.Font.Gotham
		OptBtn.TextSize = 14

		local OptCorner = Instance.new("UICorner")
		OptCorner.CornerRadius = UDim.new(0, 4)
		OptCorner.Parent = OptBtn

	
		local state = initialState
		local function toggle()
			state = not state
			UpdateButtonText(OptBtn, baseText, state)
			onToggle(state)
		end


		UpdateButtonText(OptBtn, baseText, state)

		OptBtn.MouseButton1Click:Connect(toggle)
	end
	
	local function AddTextBoxOption(parentPage, labelText, initialText, onTextConfirmed)
		local Container = Instance.new("Frame")
		Container.Name = "TextBoxContainer"
		Container.Parent = parentPage
		Container.BackgroundTransparency = 1
		Container.Size = UDim2.new(1, 0, 0, 55)


		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 4)
		Corner.Parent = Container


		local Label = Instance.new("TextLabel")
		Label.Name = "Label"
		Label.Parent = Container
		Label.BackgroundTransparency = 1
		Label.Size = UDim2.new(1, 0, 0, 15)
		Label.Position = UDim2.new(0, 0, 0, 0)
		Label.Text = labelText
		Label.TextColor3 = Color3.fromRGB(200, 200, 200)
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.Font = Enum.Font.Gotham
		Label.TextSize = 14

		local TextBox = Instance.new("TextBox")
		TextBox.Name = "InputBox"
		TextBox.Parent = Container
		TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40) 
		TextBox.BorderColor3 = Color3.fromRGB(60, 60, 60)
		TextBox.BorderSizePixel = 1
		TextBox.Size = UDim2.new(1, 0, 0, 30)
		TextBox.Position = UDim2.new(0, 0, 0, 20) 
		TextBox.Text = initialText or ""
		TextBox.PlaceholderText = "Type here..."
		TextBox.Font = Enum.Font.Gotham
		TextBox.TextSize = 14
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)


		TextBox.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				onTextConfirmed(TextBox.Text)
			end
		end)

		return TextBox 
	end


    local function AddDropdown(parentPage, labelText, options, defaultOption, callback)

        local Container = Instance.new("Frame")
        Container.Name = "DropdownContainer"
        Container.Parent = parentPage
        Container.BackgroundTransparency = 1
        Container.Size = UDim2.new(1, 0, 0, 60)
        Container.ClipsDescendants = true

        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Parent = Container
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, 0, 0, 15)
        Label.Position = UDim2.new(0, 0, 0, 0)
        Label.Text = labelText
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14

        local MainButton = Instance.new("TextButton")
        MainButton.Name = "MainButton"
        MainButton.Parent = Container
        MainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        MainButton.Position = UDim2.new(0, 0, 0, 20)
        MainButton.Size = UDim2.new(1, 0, 0, 35)
        MainButton.Text = defaultOption or "Sélectionner..."
        MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        MainButton.Font = Enum.Font.GothamBold
        MainButton.TextSize = 14
        
        local Arrow = Instance.new("TextLabel")
        Arrow.Parent = MainButton
        Arrow.BackgroundTransparency = 1
        Arrow.Size = UDim2.new(0, 30, 1, 0)
        Arrow.Position = UDim2.new(1, -30, 0, 0)
        Arrow.Text = "v"
        Arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
        Arrow.Font = Enum.Font.GothamBold
        Arrow.TextSize = 14

        local MainCorner = Instance.new("UICorner")
        MainCorner.CornerRadius = UDim.new(0, 4)
        MainCorner.Parent = MainButton

        local OptionList = Instance.new("Frame")
        OptionList.Name = "OptionList"
        OptionList.Parent = Container
        OptionList.BackgroundTransparency = 1
        OptionList.Position = UDim2.new(0, 0, 0, 60)
        OptionList.Size = UDim2.new(1, 0, 0, 0)
        OptionList.Visible = false

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Parent = OptionList
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Padding = UDim.new(0, 2)

        local isOpen = false
        local optionHeight = 30 

        MainButton.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            
            OptionList.Visible = isOpen
            
            if isOpen then
                Arrow.Text = "^"
                local contentHeight = #options * (optionHeight + 2)
                Container.Size = UDim2.new(1, 0, 0, 60 + contentHeight)
                OptionList.Size = UDim2.new(1, 0, 0, contentHeight)
            else
                Arrow.Text = "v"
                Container.Size = UDim2.new(1, 0, 0, 60)
            end
        end)

        for _, optionName in ipairs(options) do
            local OptBtn = Instance.new("TextButton")
            OptBtn.Parent = OptionList
            OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            OptBtn.Size = UDim2.new(1, 0, 0, optionHeight)
            OptBtn.Text = optionName
            OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            OptBtn.Font = Enum.Font.Gotham
            OptBtn.TextSize = 13
            
            local OptCorner = Instance.new("UICorner")
            OptCorner.CornerRadius = UDim.new(0, 4)
            OptCorner.Parent = OptBtn

            OptBtn.MouseButton1Click:Connect(function()
                MainButton.Text = optionName
                callback(optionName) 

                isOpen = false
                Arrow.Text = "v"
                OptionList.Visible = false
                Container.Size = UDim2.new(1, 0, 0, 60)
            end)
        end
    end

    local HomePage = CreatePage("HomePage", 1.5)
    local SettingsPage = CreatePage("SettingsPage", 1.5)

    CreateMenuButton("Home", HomePage)	
    CreateMenuButton("Settings", SettingsPage)

	SwitchToPage(HomePage)

    AddSectionTitle(HomePage, "Automation", nil)

    AddToggleButton(HomePage, "Auto cash", AutoWin, function(state)  
        AutoWin = state
    end)

    AddToggleButton(HomePage, "Auto open chest", AutoOpenBox, function(state)  
        AutoOpenBox = state
    end)

	AddDropdown(HomePage, "Choisir le Matériau", ChestListe, "Common Chest", function(selection)
		ChestSelected = selection
		if ChestSelected == "Common Chest" then
			ChestPrice = 5
		elseif ChestSelected == "Uncommon Chest" then
			ChestPrice = 15
		elseif ChestSelected == "Rare Chest" then
			ChestPrice = 45
		elseif ChestSelected == "Epic Chest" then
			ChestPrice = 135
		elseif ChestSelected == "Legendary Chest" then
			ChestPrice = 405
		end
	end)   

    AddSectionTitle(SettingsPage, "Joins ur discord server", nil)

    AddSimpleOptionButton(SettingsPage, "Discord Invite", function()
        setclipboard("https://discord.gg/XD2uFWJqU3")
    end)

    AddSectionTitle(SettingsPage, "❗ DANGEROUS ❗", nil)

    AddSimpleOptionButton(SettingsPage, "Nuke Menu", function()
		screenGui:destroy()
		RunServiceValue:Disconnect()
		script:Destroy()
	end)

    CloseButton.MouseButton1Click:Connect(function()
		Background.Visible = false
	end)

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.KeyCode == Enum.KeyCode.J and not gameProcessed then
			Background.Visible = not Background.Visible
		end
	end)
end

RunServiceValue = RunService.Heartbeat:Connect(function()
    local success, result = pcall(function()
    	Character = player.Character or player.CharacterAdded:Wait()
    	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	end)

    if AutoWin and AutoWinCanRun then
        AutoWinCanRun = false

       	HumanoidRootPart.CFrame = CFrame.new(-55, 23, 1151)

		task.wait(1)

		HumanoidRootPart.CFrame = CFrame.new(-55, 23, 1385)

		task.wait(2)

        AutoWinCanRun = true
    end

	if AutoOpenBox then
		local goldAmountString = game.Players.LocalPlayer.PlayerGui.GoldGui.Frame.Amount.Text
		local currentGold = tonumber(goldAmountString)
		
		if not currentGold then
			warn("Could not retrieve current gold amount.")
			return
		end

		if currentGold >= ChestPrice then

			AutoWin = false

			task.wait(5)

			local BuyTime = currentGold / ChestPrice
			
			for i = 1, BuyTime do
				firesignal(game:GetService("Players").LocalPlayer.PlayerGui.ShopGui.MainFrame.TabFrame.ShopFrame.ScrollingFrameChests.Frame_001[ChestSelected].MouseButton1Click)
				firesignal(game:GetService("Players").LocalPlayer.PlayerGui.ShopGui.MainFrame.TabFrame.ShopFrame.SelectedFrame.BuyFrame.BuyButton.MouseButton1Click)
			end

			firesignal(game:GetService("Players").LocalPlayer.PlayerGui.OpenChestAnimation.Close.MouseButton1Click)

			AutoWin = true
		end
	end
end)

print("Welcome to Silent Ghost | Build a boat | OPEN SOURCE")
print("Started by ghostymoxy (on discord)")

print("If you close the menu, tap J to open it again")
Menu()
