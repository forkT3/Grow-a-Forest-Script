local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})
local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Sell")
local Button = Tab:CreateButton({
    Name = "Sell all Fruit",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        local originalCFrame = humanoidRootPart.CFrame

        local sellPosition = CFrame.new(Vector3.new(-13, 25, -600))

        humanoidRootPart.CFrame = sellPosition

        task.wait(0.3)

        game:GetService("ReplicatedStorage"):WaitForChild("Gameplay"):WaitForChild("Remotes"):WaitForChild("sellInventory"):FireServer()

        task.wait(0.3)

        humanoidRootPart.CFrame = originalCFrame
    end,
})
local autoSell = false
local sellLoop = nil

local Toggle = Tab:CreateToggle({
    Name = "Auto Sell all Fruits",
    Default = false,
    Callback = function(state)
        autoSell = state

        if autoSell then
            -- Start the loop
            sellLoop = task.spawn(function()
                while autoSell do
                    local player = game.Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

                    -- Save original position
                    local originalCFrame = humanoidRootPart.CFrame

                    -- Target sell location
                    local sellPosition = CFrame.new(Vector3.new(-13, 25, -600))
                    
                    -- Teleport to sell zone
                    humanoidRootPart.CFrame = sellPosition
                    task.wait(0.3)

                    -- Fire sell remote
                    game:GetService("ReplicatedStorage")
                        :WaitForChild("Gameplay")
                        :WaitForChild("Remotes")
                        :WaitForChild("sellInventory")
                        :FireServer()

                    task.wait(0.3)

                    -- Return to original position
                    humanoidRootPart.CFrame = originalCFrame

                    task.wait(1.5) -- Delay before next sell cycle (adjust as needed)
                end
            end)
        else
            -- Stop the loop
            autoSell = false
        end
    end
})
local Section = Tab:CreateSection("Buy Seeds")
local fruits = {
    "Apple",
    "Orange",
    "Peach",
    "Banana",
    "Pear",
    "Cherry",
    "Coconut",
    "Lemon",
    "Mango",
    "Dragon"
}

-- Create a variable to track the selected fruit
local selectedFruit = "Apple"  -- Default selection is Apple

-- Dropdown for selecting fruit seed
local Dropdown = Tab:CreateDropdown({
   Name = "Select Fruit Seed",
   Options = fruits,  -- List of fruits for the dropdown options
   CurrentOption = {selectedFruit},  -- Default selected option
   MultipleOptions = false,  -- Allow only one option to be selected at a time
   Flag = "FruitSeedDropdown",  -- Unique identifier for configuration
   Callback = function(Options)
       -- Update the selected fruit when a new option is selected
       selectedFruit = Options[1]
   end,
})

-- Function to buy seed for selected fruit
local function buySelectedSeed()
    local args = { selectedFruit }

    -- Call the buySeed function
    game:GetService("ReplicatedStorage")
        :WaitForChild("Gameplay")
        :WaitForChild("Remotes")
        :WaitForChild("buySeed")
        :FireServer(unpack(args))

    -- Optionally, show a confirmation message or log it
    print("Bought seed for: " .. selectedFruit)
end

-- Create a button to buy the selected seed
local buyButton = Tab:CreateButton({
    Name = "Buy Selected Seed",
    Callback = function()
        buySelectedSeed()  -- Trigger the buySeed function when button is pressed
    end,
})
local fruits = {
    "Apple",
    "Orange",
    "Peach",
    "Banana",
    "Pear",
    "Cherry",
    "Coconut",
    "Lemon",
    "Mango",
    "Dragon"
}

-- Create a variable to track toggled states for each fruit
local toggledFruits = {}

-- Variable to track the auto-buy toggle state
local autoBuyEnabled = false

-- Function to buy seed for the selected fruit
local function buySeed(fruit)
    local args = { fruit }

    game:GetService("ReplicatedStorage")
        :WaitForChild("Gameplay")
        :WaitForChild("Remotes")
        :WaitForChild("buySeed")
        :FireServer(unpack(args))

    -- Optionally, show a confirmation message or log it
    print("Bought seed for: " .. fruit)
end

-- Create Dropdown with 10 Toggle Buttons for Fruits
local Dropdown = Tab:CreateDropdown({
   Name = "Select Fruit Seeds (Auto Buy)",
   Options = fruits,  -- List of fruits for the dropdown options
   CurrentOption = {fruits[1]},  -- Default selected option
   MultipleOptions = true,  -- Allow multiple toggles at once
   Flag = "FruitSeedsToggle",  -- Unique identifier for configuration
   Callback = function(Options)
       -- Update toggled states for each fruit
       for _, fruit in ipairs(fruits) do
           toggledFruits[fruit] = false  -- Set all toggles to off initially
       end

       -- Toggle the selected fruits
       for _, fruit in ipairs(Options) do
           toggledFruits[fruit] = true
       end
   end,
})

-- Automatically buy seed when toggled on with a delay using wait()
local function autoBuySeeds()
    if autoBuyEnabled then
        for fruit, toggled in pairs(toggledFruits) do
            if toggled then
                buySeed(fruit)  -- Automatically buy seed if toggled on
                wait(0.5)  -- Add a 0.5 second delay between each purchase
            end
        end
    end
end

-- Create Toggle to enable/disable Auto Buy
local autoBuyToggle = Tab:CreateToggle({
    Name = "Auto Buy Selected Seeds",
    Default = false,  -- Default state is off
    Flag = "AutoBuyToggle",  -- Unique identifier for configuration
    Callback = function(state)
        autoBuyEnabled = state  -- Toggle the auto-buy functionality on or off
        while autoBuyEnabled do
            autoBuySeeds()  -- Start auto-buying when the toggle is on
            wait(0.4)  -- Wait for 1 second before checking again (you can adjust this delay)
        end
    end,
})
local Section = Tab:CreateSection("Upgrades")
-- Function to upgrade luck
local function upgradeLuck()
    game:GetService("ReplicatedStorage"):WaitForChild("Gameplay"):WaitForChild("Remotes"):WaitForChild("UpgradeLuckMult"):FireServer()
end

-- Function to upgrade growth speed
local function upgradeGrowthSpeed()
    game:GetService("ReplicatedStorage"):WaitForChild("Gameplay"):WaitForChild("Remotes"):WaitForChild("UpgradeGrowthSpeed"):FireServer()
end

-- Function to upgrade money multiplier
local function upgradeMoneyMult()
    game:GetService("ReplicatedStorage"):WaitForChild("Gameplay"):WaitForChild("Remotes"):WaitForChild("UpgradeMoneyMult"):FireServer()
end

-- Variable to track the auto-upgrade toggle state for each upgrade type
local autoUpgradeLuckEnabled = false
local autoUpgradeGrowthEnabled = false
local autoUpgradeMoneyEnabled = false

-- Create Toggle for Auto Upgrade Luck
local autoUpgradeLuckToggle = Tab:CreateToggle({
    Name = "Enable Auto Upgrade Luck",
    Default = false,  -- Default state is off
    Flag = "AutoUpgradeLuckToggle",  -- Unique identifier for configuration
    Callback = function(state)
        autoUpgradeLuckEnabled = state  -- Toggle the auto-upgrade functionality for luck on or off
        while autoUpgradeLuckEnabled do
            upgradeLuck()  -- Automatically upgrade luck when the toggle is on
            wait(1)  -- Wait for 1 second before upgrading again (you can adjust this delay)
        end
    end,
})

-- Create Toggle for Auto Upgrade Growth Speed
local autoUpgradeGrowthToggle = Tab:CreateToggle({
    Name = "Enable Auto Upgrade Growth Speed",
    Default = false,  -- Default state is off
    Flag = "AutoUpgradeGrowthToggle",  -- Unique identifier for configuration
    Callback = function(state)
        autoUpgradeGrowthEnabled = state  -- Toggle the auto-upgrade functionality for growth speed on or off
        while autoUpgradeGrowthEnabled do
            upgradeGrowthSpeed()  -- Automatically upgrade growth speed when the toggle is on
            wait(1)  -- Wait for 1 second before upgrading again (you can adjust this delay)
        end
    end,
})

-- Create Toggle for Auto Upgrade Money Multiplier
local autoUpgradeMoneyToggle = Tab:CreateToggle({
    Name = "Enable Auto Upgrade Money Multiplier",
    Default = false,  -- Default state is off
    Flag = "AutoUpgradeMoneyToggle",  -- Unique identifier for configuration
    Callback = function(state)
        autoUpgradeMoneyEnabled = state  -- Toggle the auto-upgrade functionality for money multiplier on or off
        while autoUpgradeMoneyEnabled do
            upgradeMoneyMult()  -- Automatically upgrade money multiplier when the toggle is on
            wait(1)  -- Wait for 1 second before upgrading again (you can adjust this delay)
        end
    end,
})
