--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--[[
  Cry More xj3t_
  you cant even make optimization
]]

-- local HWIDTable = loadstring(game:HttpGet("https://raw.githubusercontent.com/CrismonPetrasion/HWID/main/Checker.lua"))()
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()

--// Services

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Variables

local Camera = workspace.CurrentCamera
local Weapons = ReplicatedStorage.Weapons
local Debris = workspace.Debris
local RayIgnore = workspace.Ray_Ignore
local LocalPlayer = Players.LocalPlayer

local CurrentCamera = Camera
local WorldToViewportPoint = CurrentCamera.WorldToViewportPoint

--// Aimbot Settings

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 1.5
FOVring.Radius = 150
FOVring.Transparency = 1
FOVring.Color = Color3.fromRGB(200, 200, 200)

local RageSettings = {
    Enabled = false,
    TeamCheck = true,
    Smoothing = 0,
}
local BackSettings = {
    Enabled = false,
}

local AimSettings = {
    Enabled = false,
    TeamCheck = false,
    Smoothing = 1,
    EnableFOV = false
}

local ESPSettings = {
    Enabled = false,
    UseTeamColor = false,
    ChamsColor = Color3.fromRGB(200,200,200)
}

local Damage = {
    NoFireDamageEnabled = false,
    NoFallDamageEnabled = false,
    NoExplodeDamageEnabled = false,
}

local Sounds = {
    KillSoundEnabled = false,
    HitSoundEnabled = false,
    KillSound = nil,
    HitSound = nil,
}

--// Library

local Library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// Window

local Window = Library:CreateWindow({
    Name = "Nocturne",
    LoadingTitle = "Loading Script",
    LoadingSubtitle = "Get nocturne, get good.",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "Nocturne", -- Create a custom folder for your hub/game
        FileName = "autocfg"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
        RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
        Title = "Key System",
        Subtitle = "Discord System",
        Note = "discord.gg/vZQTkyCXD8",
        FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
        SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
        GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
        Key = {"GalaxyHubIsBestSkiddersEver"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
})

local Home = Window:CreateTab("Home", 4483362458) -- Title, Image
local Combat = Window:CreateTab("Combat", 4483362458) -- Title, Image
local Misc = Window:CreateTab("Misc", 4483362458) -- Title, Image
local Visuals = Window:CreateTab("Visuals", 4483362458) -- Title, Image

--// Version

local Version = "1.0"

--// Game

if true then
    function GetClosestPlayer(CFrame)
        local Ray = Ray.new(CFrame.Position, CFrame.LookVector).Unit
    
        local Target = nil
        local Mag = math.huge
    
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Humanoid").Health > 0 and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v ~= LocalPlayer and (v.Team ~= LocalPlayer.Team or (not AimSettings.TeamCheck)) then
                local Position = v.Character.Head.Position
                local MagBuff = (Position - Ray:ClosestPoint(Position)).Magnitude
                if MagBuff < Mag then
                    Mag = MagBuff
                    Target = v
                end
            end
        end
    
        return Target
    end

    do
        --// Home

        Home:CreateLabel("Premium Version")
        Home:CreateLabel("Version: ".. Version)
    end

    do
        --// Combat

        Combat:CreateSection("Ragebot")
        Combat:CreateToggle({
            Name = "Ragebot",
            CurrentValue = false,
            Flag = "Ragebot",
            Callback = function(Value)
                RageSettings.Enabled = true
            end,
        })
        Combat:CreateToggle({
            Name = "BackTrack",
            CurrentValue = false,
            Flag = "BackTrack",
            Callback = function(Value)
                BackSettings.Enabled = true
            end,
        })

        Combat:CreateSection("Aimbot")
        Combat:CreateToggle({
            Name = "Aimbot",
            CurrentValue = false,
            Flag = "Aimbot",
            Callback = function(Value)
                AimSettings.Enabled = true
            end,
        })

        Combat:CreateSection("Settings")
        Combat:CreateSlider({
            Name = "FOV Radius",
            Range = {0, 2000},
            Increment = 1,
            CurrentValue = 150,
            Flag = "FOVRadius", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                FOVring.Radius = Value
            end,
        })

        Combat:CreateColorPicker({
            Name = "FOV Color",
            Color = Color3.fromRGB(200,200,200),
            Flag = "FOVColor", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                FOVring.Color = Value or Color3.fromRGB(200,200,200)
            end
        })

        Combat:CreateToggle({
            Name = "Use FOV",
            CurrentValue = false,
            Flag = "UseFOV",
            Callback = function(Value)
                AimSettings.EnableFOV = Value
            end,
        })

        Combat:CreateToggle({
            Name = "Team Check",
            CurrentValue = false,
            Flag = "TeamCheck",
            Callback = function(Value)
                AimSettings.TeamCheck = Value
            end,
        })

        Combat:CreateSection("Character")
        Combat:CreateToggle({
            Name = "AntiAim",
            CurrentValue = false,
            Flag = "AntiAim",
            Callback = function(Value)
                _G.AntiAim = Value
            end,
        })

        Combat:CreateSection("Settings")
        Combat:CreateSlider({
            Name = "Speed",
            Range = {0, 500},
            Increment = 1,
            CurrentValue = 150,
            Flag = "FOVRadius", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                _G.Speed = Value
            end,
        })
    end

    do
        --// Misc
        ---
        Misc:CreateSection("Guns")

        Misc:CreateButton({
            Name = "Full Auto",
            Callback = function()
                for _, Weapon in ipairs(Weapons:GetChildren()) do
                    if Weapon:FindFirstChild("Auto") then
                        Weapon:FindFirstChild("Auto").Value = true
                    end 
                end
            end,
        })

        Misc:CreateButton({
            Name = "No Fire Rate",
            Callback = function()
                for _, Weapon in ipairs(Weapons:GetChildren()) do
                    if Weapon:FindFirstChild("FireRate") then
                        Weapon:FindFirstChild("FireRate").Value = 0
                    end 
                end
            end,
        })
    
        Misc:CreateButton({
            Name = "No Spread",
            Callback = function()
                for _, Weapon in ipairs(Weapons:GetChildren()) do
                    if Weapon:FindFirstChild("Spread") then
                        Weapon:FindFirstChild("Spread").Value = 0
                        for _, Spread in ipairs(Weapon:FindFirstChild("Spread"):GetChildren()) do
                            Spread.Value = 0
                        end
                    end 
                end
            end,
        })

         Misc:CreateButton({
            Name = "Peneteration",
            Callback = function()
                for _, Weapon in ipairs(Weapons:GetChildren()) do
                    if Weapon:FindFirstChild("Penetration") then
                        Weapon:FindFirstChild("Penetration").Value = 999
                    end 
                end
            end,
        })

        Misc:CreateButton({
            Name = "Inf Range",
            Callback = function()
                for _, Weapon in ipairs(Weapons:GetChildren()) do
                    if Weapon:FindFirstChild("Range") then
                        Weapon:FindFirstChild("Range").Value = 999
                    end 
                end
            end,
        })

        Misc:CreateButton({
            Name = "Instant Reload Time",
            Callback = function()
                for _, Weapon in ipairs(Weapons:GetChildren()) do
                    if Weapon:FindFirstChild("ReloadTime") then
                        Weapon:FindFirstChild("ReloadTime").Value = 0.05
                    end 
                end
            end,
        })

        Misc:CreateButton({
            Name = "Instant Equip Time",
            Callback = function()
                for _, Weapon in ipairs(Weapons:GetChildren()) do
                    if Weapon:FindFirstChild("EquipTime") then
                        Weapon:FindFirstChild("EquipTime").Value = 0.05
                    end 
                end
            end,
        })
    
        Misc:CreateButton({
            Name = "Infinite Ammo",
            Callback = function()
                for _, Weapon in ipairs(Weapons:GetChildren()) do
                    if Weapon:FindFirstChild("Ammo") and Weapon:FindFirstChild("StoredAmmo") then
                        Weapon:FindFirstChild("Ammo").Value = 9999999999
                        Weapon:FindFirstChild("StoredAmmo").Value = 9999999999
                    end 
                end
            end,
        })

        Misc:CreateSection("Gnommode")
        Misc:CreateToggle({
            Name = "Gnommode",
            CurrentValue = false,
            Flag = "Gnommode",
            Callback = function(Value)
                _G.Gnommode = Value
            end,
        })
game:GetService("RunService").Heartbeat:Connect(function()
    if _G.Gnommode == true then
    game.ReplicatedStorage.Events.ControlTurn:FireServer(0/0, false) 
end
end)

        Misc:CreateSection("Damage")
        Misc:CreateToggle({
            Name = "NoDamage",
            CurrentValue = false,
            Flag = "NoDamage",
            Callback = function(Value)
                _G.NoFallDamageEnabled = Value
                _G.NoExplodeDamageEnabled = Value
                _G.NoFireDamageEnabled = Value
            end,
        })

        Misc:CreateSection("Sounds")
        Misc:CreateToggle({
            Name = "Hit Sound",
            CurrentValue = false,
            Flag = "HitSound", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                Sounds.HitSoundEnabled = Value
            end,
        })

        Misc:CreateToggle({
            Name = "Kill Sound",
            CurrentValue = false,
            Flag = "KillSound", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                Sounds.KillSoundEnabled = Value
            end,
        })

        Misc:CreateDropdown({
            Name = "Hit Sounds",
            Options = {'Bameware', 'Bell', 'Bubble', 'Pick', 'Pop', 'Rust', 'Skeet', 'Neverlose', 'Minecraft'},
            CurrentOption = {"Bubble"},
            MultipleOptions = false,
            Flag = "HitSounds", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Option)
                if Option == "Bameware" then
                    Sounds.HitSound = 3124331820
                elseif Option == "Bell" then
                    Sounds.HitSound = 6534947240
                elseif Option == "Bubble" then
                    Sounds.HitSound = 6534947588
                elseif Option == "Pick" then
                    Sounds.HitSound = 1347140027    
                elseif Option == "Pop" then
                    Sounds.HitSound = 198598793
                elseif Option == "Rust" then
                    Sounds.HitSound = 1255040462 
                elseif Option == "Skeet" then
                    Sounds.HitSound = 5633695679
                elseif Option == "Neverlose" then
                    Sounds.HitSound = 6534948092
                elseif Option == "Minecraft" then
                    Sounds.HitSound = 4018616850
                end
                print(Option)
                print(Sounds.HitSound)
            end,
        })

        Misc:CreateDropdown({
            Name = "Kill Sounds",
            Options = {'Bameware', 'Bell', 'Bubble', 'Pick', 'Pop', 'Rust', 'Skeet', 'Neverlose', 'Minecraft'},
            CurrentOption = {"Bubble"},
            MultipleOptions = false,
            Flag = "KillSounds", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Option)
                if Option == "Bameware" then
                    Sounds.KillSound = 3124331820
                elseif Option == "Bell" then
                    Sounds.KillSound = 6534947240
                elseif Option == "Bubble" then
                    Sounds.KillSound = 6534947588
                elseif Option == "Pick" then
                    Sounds.KillSound = 1347140027    
                elseif Option == "Pop" then
                    Sounds.KillSound = 198598793
                elseif Option == "Rust" then
                    Sounds.KillSound = 1255040462 
                elseif Option == "Skeet" then
                    Sounds.KillSound = 5633695679
                elseif Option == "Neverlose" then
                    Sounds.KillSound = 6534948092
                elseif Option == "Minecraft" then
                    Sounds.KillSound = 4018616850
                end
                print(Option)
                print(Sounds.KillSound)
            end,
        })

        Misc:CreateSection("Effects")
        Misc:CreateToggle({
            Name = "Remove Scope",
            CurrentValue = false,
            Flag = "RemoveScope",
            Callback = function(Value)
                _G.RemoveScope = Value
            end,
        })

        Misc:CreateToggle({
            Name = "Remove Flash",
            CurrentValue = false,
            Flag = "RemoveFlash",
            Callback = function(Value)
                _G.RemoveFlash = Value
            end,
        })

        Misc:CreateToggle({
            Name = "Remove Smoke",
            CurrentValue = false,
            Flag = "RemoveSmoke",
            Callback = function(Value)
                _G.RemoveSmoke = Value
            end,
        })

        Misc:CreateToggle({
            Name = "Remove Blood",
            CurrentValue = false,
            Flag = "RemoveBlood",
            Callback = function(Value)
                _G.RemoveBlood = Value
            end,
        })

        Misc:CreateToggle({
            Name = "Remove Bullets Holes",
            CurrentValue = false,
            Flag = "RemoveBulletsHoles",
            Callback = function(Value)
                _G.RemoveBulletsHoles = Value
            end,
        })

        Misc:CreateSection("Movement")
        Misc:CreateToggle({
            Name = "Auto Bhop",
            CurrentValue = false,
            Flag = "Bhop", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                _G.Bhop = Value
            end,
        })

        Misc:CreateSlider({
            Name = "Bhop Speed",
            Range = {0, 300},
            Increment = 1,
            CurrentValue = 100,
            Flag = "BhopSpeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                _G.BhopSpeed = Value
            end,
        })

        Misc:CreateSection("Character")
        Misc:CreateToggle({
            Name = "Fly",
            CurrentValue = false,
            Flag = "Fly", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                _G.Fly = Value
            end,
        })
    
        Misc:CreateToggle({
            Name = "Noclip",
            CurrentValue = false,
            Flag = "Noclip", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                _G.Noclip = Value
            end,
        })
        
        Misc:CreateSlider({
            Name = "Fly Speed",
            Range = {0, 120},
            Increment = 1,
            CurrentValue = 16,
            Flag = "FlySpeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                _G.FlySpeed = Value
            end,
        })

        Misc:CreateSection("Stuff")
        Misc:CreateButton({
            Name = "Infinite Cash",
            Callback = function()
                RunService.RenderStepped:Connect(function()
                    if LocalPlayer and LocalPlayer.Parent then
                        LocalPlayer.Cash.Value = 9550
                    end
                    task.wait()
                end)
            end,
        })
    end

    do
        --// Visuals

        Visuals:CreateSection("Camera")
        Visuals:CreateSlider({
            Name = "Field Of View",
            Range = {0, 120},
            Increment = 1,
            CurrentValue = 80,
            Flag = "BhopSpeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                _G.FieldOfView = Value
            end,
        })

        Visuals:CreateSection("Character")
        Visuals:CreateToggle({
            Name = "Third Person",
            CurrentValue = false,
            Flag = "ThirdPerson",
            Callback = function(Value)
                _G.ThirdPerson = Value
            end,
        })

        Visuals:CreateSlider({
            Name = "Third Person Distance",
            Range = {0, 50},
            Increment = 1,
            CurrentValue = 10,
            Flag = "ThirdPersonDistance", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                _G.ThirdPersonDistance = Value
            end,
        })

        Visuals:CreateSection("Players")
        Visuals:CreateToggle({
            Name = "Chams",
            CurrentValue = false,
            Flag = "Chams",
            Callback = function(Value)
                ESPSettings.Enabled = Value
            end,
        })

        Visuals:CreateToggle({
            Name = "Use Team Color",
            CurrentValue = false,
            Flag = "TeamCheckChams",
            Callback = function(Value)
                ESPSettings.UseTeamColor = Value
            end,
        })

        Visuals:CreateColorPicker({
            Name = "Chams Color",
            Color = Color3.fromRGB(200,200,200),
            Flag = "ChamsColor", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                ESPSettings.ChamsColor = Value
            end
        })

        Visuals:CreateSection("Arms")
        Visuals:CreateToggle({
            Name = "Arms Chams",
            CurrentValue = false,
            Flag = "ArmsChams",
            Callback = function(Value)
                _G.ArmsChams = Value
            end,
        })

        Visuals:CreateSection("Guns")
        Visuals:CreateToggle({
            Name = "Guns Chams",
            CurrentValue = false,
            Flag = "GunsChams",
            Callback = function(Value)
                _G.GunsChams = Value
            end,
        })

        Visuals:CreateColorPicker({
            Name = "Guns Chams Color",
            Color = Color3.fromRGB(200,200,200),
            Flag = "GunsChamsColor", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                _G.ChamsColor = Value
            end
        })
    end

end

RunService.RenderStepped:Connect(function()
    if _G.NoExplodeDamage == true then
        game:GetService("ReplicatedStorage").Events.Explode:Destroy()
    else
       
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if _G.NoFallDamage == true then
        game:GetService("ReplicatedStorage").Events.FallDamage:Destroy()
    else
       
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if _G.NoFireDamage == true then
        game:GetService("ReplicatedStorage").Events.BURNME:Destroy()
    else
       
    end
    task.wait()
end)

LocalPlayer.Additionals.TotalDamage.Changed:Connect(function(Value)
    if Sounds.HitSoundEnabled == true and Value ~= 0 then
        local HitSound = Instance.new("Sound")
		HitSound.Parent = game:GetService("SoundService")
		HitSound.SoundId = 'rbxassetid://'..Sounds.HitSound
		HitSound.Volume = 3
		HitSound:Play()
    end
end)

LocalPlayer.Status.Kills.Changed:Connect(function(Value)
    if Sounds.KillSoundEnabled == true and Value ~= 0 then
        local KillSound = Instance.new("Sound")
		KillSound.Parent = game:GetService("SoundService")
		KillSound.SoundId = 'rbxassetid://'..Sounds.KillSound
		KillSound.Volume = 3
		KillSound:Play()
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.RemoveScope == true then
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.ImageTransparency = 1
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.ImageTransparency = 1
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Size = UDim2.new(2,0,2,0)
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Position = UDim2.new(-0.5,0,-0.5,0)
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Blur.ImageTransparency = 1
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Blur.Blur.ImageTransparency = 1
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame1.Transparency = 1
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame2.Transparency = 1
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame3.Transparency = 1
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame4.Transparency = 1
    else
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.ImageTransparency = 0
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.ImageTransparency = 0
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Size = UDim2.new(1,0,1,0)
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Position = UDim2.new(0,0,0,0)
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Blur.ImageTransparency = 0
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Blur.Blur.ImageTransparency = 0
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame1.Transparency = 0
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame2.Transparency = 0
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame3.Transparency = 0
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame4.Transparency = 0
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if _G.RemoveFlash == true then
        LocalPlayer.PlayerGui.Blnd.Enabled = false
    else
        LocalPlayer.PlayerGui.Blnd.Enabled = true
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if _G.RemoveBulletsHoles == true then
        for i,v in pairs(Debris:GetChildren()) do
            if v.Name == "Bullet" then
                v:Remove()
            end
        end
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if _G.RemoveSmoke == true then
        for i,v in pairs(RayIgnore.Smokes:GetChildren()) do
            if v.Name == "Smoke" then
                v:Remove()
            end
        end
    end                    
    task.wait()
end)
RunService.RenderStepped:Connect(function()
    if _G.RemoveBlood == true then
        for i,v in pairs(Debris:GetChildren()) do
            if v.Name == "SurfaceGui" then
                v:Remove()
            end
        end
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if _G.Noclip == true then
        if LocalPlayer.Character then
        for _, Instance in pairs(LocalPlayer.Character:GetChildren()) do
            if Instance:IsA("BasePart") and Instance.CanCollide == true then
                Instance.CanCollide = false
            end
        end
    end
    else
if LocalPlayer.Character then
    for _, Instance in pairs(LocalPlayer.Character:GetChildren()) do
        if Instance:IsA("BasePart") and Instance.CanCollide == true then
            Instance.CanCollide = true
        end
    end
end

    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if _G.Fly == true then
        if LocalPlayer.Character ~= nil then
            local Speed = _G.FlySpeed or 16
            local Velocity = Vector3.new(0, 1, 0)
    
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                Velocity = Velocity + (Camera.CoordinateFrame.lookVector * Speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                Velocity = Velocity + (Camera.CoordinateFrame.rightVector * -Speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                Velocity = Velocity + (Camera.CoordinateFrame.lookVector * -Speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                Velocity = Velocity + (Camera.CoordinateFrame.rightVector * Speed)
            end
    
            LocalPlayer.Character.HumanoidRootPart.Velocity = Velocity
            LocalPlayer.Character.Humanoid.PlatformStand = true
        end
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if _G.Bhop == true then
        if LocalPlayer.Character ~= nil and UserInputService:IsKeyDown(Enum.KeyCode.Space) and LocalPlayer.PlayerGui.GUI.Main.GlobalChat.Visible == false then
            LocalPlayer.Character.Humanoid.Jump = true
            local Speed = _G.BhopSpeed or 100
            local Dir = Camera.CFrame.LookVector * Vector3.new(1,0,1)
            local Move = Vector3.new()

            Move = UserInputService:IsKeyDown(Enum.KeyCode.W) and Move + Dir or Move
            Move = UserInputService:IsKeyDown(Enum.KeyCode.S) and Move - Dir or Move
            Move = UserInputService:IsKeyDown(Enum.KeyCode.D) and Move + Vector3.new(-Dir.Z,0,Dir.X) or Move
            Move = UserInputService:IsKeyDown(Enum.KeyCode.A) and Move + Vector3.new(Dir.Z,0,-Dir.X) or Move
            if Move.Unit.X == Move.Unit.X then
                Move = Move.Unit
                LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(Move.X * Speed, LocalPlayer.Character.HumanoidRootPart.Velocity.Y, Move.Z * Speed)
            end
        end
    end
    task.wait()
end)


local BacktrackData = {} -- Таблица для хранения прошлых позиций игроков
local MaxBacktrackTime = 0.2 -- Максимальное время бектрека (200 миллисекунд)

-- Обновление позиций игроков для бектрека
RunService.RenderStepped:Connect(function()
    if BackSettings.Enabled == true then -- Проверяем, включен ли бектрек
        for _, Player in ipairs(Players:GetPlayers()) do
            if Player.Character and Player.Character:FindFirstChild("Head") then
                local HeadPosition = Player.Character.Head.Position
                if not BacktrackData[Player] then
                    BacktrackData[Player] = {}
                end

                -- Сохраняем текущую позицию вместе с меткой времени
                table.insert(BacktrackData[Player], {position = HeadPosition, time = tick()})

                -- Удаление старых позиций
                for i = #BacktrackData[Player], 1, -1 do
                    if tick() - BacktrackData[Player][i].time > MaxBacktrackTime then
                        table.remove(BacktrackData[Player], i)
                    end
                end
            end
        end
    end
end)

-- Функция для получения последней доступной позиции из бектрека
function GetBacktrackPosition(Player)
    if BackSettings.Enabled == true and BacktrackData[Player] then -- Проверка, включён ли бектрек
        for i = #BacktrackData[Player], 1, -1 do
            local Data = BacktrackData[Player][i]
            if tick() - Data.time <= MaxBacktrackTime then
                return Data.position
            end
        end
    end
    return nil
end

-- Основной цикл для рейджбота с бектрекингом
RunService.RenderStepped:Connect(function()
    if RageSettings.Enabled == true then
        local LocalPlayer = Players.LocalPlayer
        local Camera = workspace.CurrentCamera
        local ClosestTarget = nil
        local ClosestDistance = math.huge

        for _, Player in ipairs(Players:GetPlayers()) do
            if Player.Character and Player ~= LocalPlayer and Player.Team ~= LocalPlayer.Team then
                local Character = Player.Character
                local Head = Character:FindFirstChild("Head")
                local Humanoid = Character:FindFirstChild("Humanoid")
                
                -- Проверка, жив ли игрок
                if Head and Humanoid and Humanoid.Health > 0 then
                    -- Расчёт направления и расстояния до игрока
                    local Direction = (Head.Position - Camera.CFrame.Position).unit
                    local Distance = (Head.Position - Camera.CFrame.Position).Magnitude

                    local RaycastParams = RaycastParams.new()
                    RaycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                    -- Проверка наличия препятствия перед текущей позицией
                    local RaycastResult = workspace:Raycast(Camera.CFrame.Position, Direction * 500, RaycastParams)

                    -- Если текущая позиция игрока за стеной, проверяем бектрек
                    if RaycastResult and not RaycastResult.Instance:IsDescendantOf(Player.Character) then
                        if BackSettings.Enabled == true then -- Проверка состояния бектрека
                            local BacktrackPosition = GetBacktrackPosition(Player)
                            if BacktrackPosition then
                                local BacktrackDirection = (BacktrackPosition - Camera.CFrame.Position).unit
                                local BacktrackRaycastResult = workspace:Raycast(Camera.CFrame.Position, BacktrackDirection * 500, RaycastParams)

                                -- Если бектрек не за стеной, стреляем по позиции из бектрека
                                if BacktrackRaycastResult and BacktrackRaycastResult.Instance:IsDescendantOf(Player.Character) then
                                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, BacktrackPosition)
                                    mouse1press()
                                    task.wait(0.05)
                                    mouse1release()
                                end
                            end
                        end
                    else
                        -- Если игрок не за стеной, стреляем по текущей позиции
                        if Distance < ClosestDistance then
                            ClosestDistance = Distance
                            ClosestTarget = Player
                        end
                    end
                end
            end
        end

        -- Если найдена ближайшая цель, наводимся на неё
        if RageSettings.Enabled and ClosestTarget and ClosestTarget.Character and ClosestTarget.Character:FindFirstChild("Head") then
            local Head = ClosestTarget.Character.Head
            -- Наводимся на голову
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Head.Position)
            -- Стреляем по цели
            mouse1press()
            task.wait(0.1)  -- Увеличено время задержки для надёжной стрельбы
            mouse1release()
        end
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if AimSettings.Enabled == true then            
        local Pressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        if Pressed then
            local CurrentTarget = GetClosestPlayer(Camera.CFrame)
            if CurrentTarget ~= nil then
                local SSHeadPoint = Camera:WorldToScreenPoint(CurrentTarget.Character.Head.Position)
                SSHeadPoint = Vector2.new(SSHeadPoint.X, SSHeadPoint.Y)
                if (SSHeadPoint - FOVring.Position).Magnitude < FOVring.Radius then
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, CurrentTarget.Character.Head.Position), AimSettings.Smoothing)
                end
            end
        end
    end

    if AimSettings.EnableFOV then
        FOVring.Visible = true
        FOVring.Position = workspace.CurrentCamera.ViewportSize/2
    else
        FOVring.Visible = false
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character ~= nil and LocalPlayer.Character.Humanoid.Health > 0 then
        if _G.AntiAim then
            LocalPlayer.Character.Humanoid.AutoRotate = false
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(_G.Speed or 50), 0)
        else
            LocalPlayer.Character.Humanoid.AutoRotate = true
        end
    end
    task.wait()
end)

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end

    return closestPlayer
end

local function aimAt(target)
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local targetPosition = target.Character.HumanoidRootPart.Position
        local direction = (targetPosition - humanoidRootPart.Position).Unit
        local lookAtPosition = Vector3.new(targetPosition.X, humanoidRootPart.Position.Y, targetPosition.Z)
        humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, lookAtPosition)
    end
end

local FOV1 = 100

RunService.RenderStepped:Connect(function()
    if _G.ThirdPerson == true then
        if LocalPlayer.CameraMinZoomDistance ~= _G.ThirdPersonDistance or 10 then
            LocalPlayer.CameraMinZoomDistance = _G.ThirdPersonDistance or 10
            LocalPlayer.CameraMaxZoomDistance = _G.ThirdPersonDistance or 10
            workspace.ThirdPerson.Value = true
        end
    else
        if LocalPlayer.Character ~= nil then
            LocalPlayer.CameraMinZoomDistance = 0
            LocalPlayer.CameraMaxZoomDistance = 0
            workspace.ThirdPerson.Value = false
        end
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    Camera.FieldOfView = _G.FieldOfView or 80
    task.wait()
end)


RunService.RenderStepped:Connect(function()
    if _G.GunsChams == true then
        for _, Stuff in ipairs(workspace.Camera:GetChildren()) do
            if Stuff:IsA("Model") and Stuff.Name == "Arms" then
                for _, AnotherStuff in ipairs(Stuff:GetChildren()) do
                    if AnotherStuff:IsA("MeshPart") or AnotherStuff:IsA("BasePart") then
                        AnotherStuff.Color = _G.ChamsColor or Color3.fromRGB(200,200,200)
                        AnotherStuff.Material = Enum.Material.ForceField
                    end
                end
            end
        end
    else
        for _, Stuff in ipairs(workspace.Camera:GetChildren()) do
            if Stuff:IsA("Model") and Stuff.Name == "Arms" then
                for _, AnotherStuff in ipairs(Stuff:GetChildren()) do
                    if AnotherStuff:IsA("MeshPart") or AnotherStuff:IsA("BasePart") then
                        AnotherStuff.Color = Color3.fromRGB(200,200,200)
                        AnotherStuff.Material = Enum.Material.Plastic
                    end
                end
            end
        end            
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if _G.ArmsChams == true then
        for _, Stuff in ipairs(workspace.Camera:GetChildren()) do
            if Stuff:IsA("Model") and Stuff.Name == "Arms" then
                for _, AnotherStuff in ipairs(Stuff:GetChildren()) do
                    if AnotherStuff:IsA("Model") and AnotherStuff.Name ~= "AnimSaves" then
                        for _, Arm in ipairs(AnotherStuff:GetChildren()) do
                            if Arm:IsA("BasePart") then
                                Arm.Transparency = 1
                                for _, StuffInArm in ipairs(Arm:GetChildren()) do
                                    if StuffInArm:IsA("BasePart") then
                                        StuffInArm.Material = Enum.Material.ForceField
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        for _, Stuff in ipairs(workspace.Camera:GetChildren()) do
            if Stuff:IsA("Model") and Stuff.Name == "Arms" then
                for _, AnotherStuff in ipairs(Stuff:GetChildren()) do
                    if AnotherStuff:IsA("Model") and AnotherStuff.Name ~= "AnimSaves" then
                        for _, Arm in ipairs(AnotherStuff:GetChildren()) do
                            if Arm:IsA("BasePart") then
                                Arm.Transparency = 0
                                for _, StuffInArm in ipairs(Arm:GetChildren()) do
                                    if StuffInArm:IsA("BasePart") then
                                        StuffInArm.Material = Enum.Material.Plastic
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    for _, Player in ipairs(Players:GetChildren()) do
        if Player.Character and Player ~= LocalPlayer then
            local Character = Player.Character
            local Highlight = Character:FindFirstChild("Highlight") or Instance.new("Highlight", Character)

            if ESPSettings.Enabled then
                local Head = Character:FindFirstChild("Head")
                if Head then
                    if Player.Team == LocalPlayer.Team then
                        Highlight.FillColor = Player.TeamColor.Color
                    else
                        local Direction = (Head.Position - Camera.CFrame.Position).unit
                        local RaycastParams = RaycastParams.new()
                        RaycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                        RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        
                        local RaycastResult = workspace:Raycast(Camera.CFrame.Position, Direction * 500, RaycastParams)

                        if RaycastResult and RaycastResult.Instance:IsDescendantOf(Player.Character) then
                            Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        else
                            Highlight.FillColor = Player.TeamColor.Color
                        end
                    end
                end
            else
                if Highlight then
                    Highlight:Destroy()
                end
            end
        end
    end
    task.wait()
end)
