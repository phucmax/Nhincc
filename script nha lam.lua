local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "PHUCMAX HUB",
    SubTitle = "Script Tổng Hợp ",
    TabWidth = 150,
    Size = UDim2.fromOffset(560, 360),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.End
})
-- Tạo ScreenGui chứa nút điều khiển
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ControlGUI"
screenGui.Parent = game.CoreGui

-- Tạo nút (ImageButton)
-- Tạo nút (ImageButton)
local toggleButton = Instance.new("ImageButton")
toggleButton.Size = UDim2.new(0, 45, 0, 45)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Image = "rbxassetid://114009263825021"
toggleButton.BackgroundTransparency = 1
toggleButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10) -- Bo góc, có thể chỉnh số pixel theo ý
corner.Parent = toggleButton

-- Biến lưu trạng thái hiển thị Fluent UI
local isFluentVisible = true

-- Di chuyển nút
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    toggleButton.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = toggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

-- Ẩn/Hiện Fluent UI khi nhấn nút
toggleButton.MouseButton1Click:Connect(function()
    isFluentVisible = not isFluentVisible

    if isFluentVisible then
        -- Hiện Fluent UI
        Window:Minimize(false) -- Mở lại cửa sổ
    else
        -- Ẩn Fluent UI
        Window:Minimize(true) -- Thu nhỏ cửa sổ
    end
end)

local MainTab = Window:AddTab({
    Title = "Script Tổng Hợp ngon",
    Icon = "package"
})


MainTab:AddParagraph({
    Title = "chú ý",
    Content = "không được dùng quá nhiều script cùng một lúc"
   
})


MainTab:AddButton({
    Title = "xero hub",
    Description = "nhấn để chạy script ",
    Callback = function()
        getgenv().Team = "Marines"
getgenv().Hide_Menu = false
getgenv().Auto_Execute = false
loadstring(game:HttpGet("https://raw.githubusercontent.com/Xero2409/XeroHub/refs/heads/main/main.lua"))()
    end
})
MainTab:AddButton({
    Title = "redz hub",
    Description = "nhấn để chạy script ",
    Callback = function()
    
loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.luau"))()
    end
})
MainTab:AddButton({
    Title = "hoho hub",
    Description = "nhấn để chạy script ",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()
    end
})
MainTab:AddButton({
    Title = "w-azure",
    Description = "nhấn để chạy script ",
    Callback = function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/3b2169cf53bc6104dabe8e19562e5cc2.lua"))()
    end
})
MainTab:AddButton({
    Title = "Turbo Lite",
    Description = "nhấn để chạy script ",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/Main.lua"))()
    end
})

MainTab:AddButton({
    Title = "tuấn anh IOS hub",
    Description = "nhấn để chạy script ",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/TuanAnhIOS/refs/heads/main/TuanAnhIOS-Piaa.lua"))()
    end
})


local MainTab = Window:AddTab({
    Title = "script auto bounty",
    Icon = "sword"
})
MainTab:AddButton({
    Title = "auto bounty",
    Description = "nhấn để chạy script ",
    Callback = function()
        repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Team = "Pirates"
getgenv().Config = {
    ["Safe Health"] = {50},
    ["Custom Y Run"] = {
        Enabled = true,
        ["Y Run"] = 5000
    },
    ["Hunt Method"] = {
        ["Use Move Predict"] = true,
        ["Hit and Run"] = true,
        ["Aimbot"] = true,
        ["ESP Player"] = true,
        ["Max Attack Time"] = 60
    },
    ["Shop"] = {
        ["Random Fruit"] = false,
        ["Store Fruit"] = true,
        ["Zoro Sword"] = false
    },
    ["Setting"] = {
        ["World"] = 3,
        ["White Screen"] = false,
        ["Click Delay"] = 0.1,
        ["Url"] = "Your_Webhook_Url",
        ["Chat"] = {
            Enabled = true,
            Wait = 350,
            Massage = {"Lion Hub On Top", "Get Best Script g g / lionhub"}
        }
    },
    ["Skip"] = {
        ["Avoid V4"] = false
    },
    ["Spam All Skill On V4"] = {
        Enabled = true,
        ["Weapons"] = {"Melee", "Sword", "Gun", "Blox Fruit"}
    },
    Items = {
        Use = {"Melee", "Sword"},
        Melee = {
            Enable = true,
            Delay = 0.6,
            Skills = {
                Z = {Enable = true, HoldTime = 0.3},
                X = {Enable = true, HoldTime = 0.2},
                C = {Enable = true, HoldTime = 0.5}
            }
        },
        Sword = {
            Enable = true,
            Delay = 0.5,
            Skills = {
                Z = {Enable = true, HoldTime = 1},
                X = {Enable = true, HoldTime = 0}
            }
        },
        Gun = {
            Enable = false,
            Delay = 0.2,
            Skills = {
                Z = {Enable = false, HoldTime = 0.1},
                X = {Enable = false, HoldTime = 0.1}
            }
        },
        ["Blox Fruit"] = {
            Enable = true,
            Delay = 0.4,
            Skills = {
                Z = {Enable = true, HoldTime = 0.1},
                X = {Enable = true, HoldTime = 0.1},
                C = {Enable = true, HoldTime = 0.15},
                V = {Enable = false, HoldTime = 0.2},
                F = {Enable = true, HoldTime = 0.1}
            }
        }
    }
}
loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/10f7f97cebba24a87808c36ebd345a97.lua"))()
    end
})
MainTab:AddButton({
    Title = "Lion Auto Bounty",
    Description = "nhấn để chạy script ",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/l1siGJS1/raw"))()
    end
})
local FixLagTab = Window:AddTab({
    Title = "Fix Lag nhà làm",
    Icon = "cpu"
})
FixLagTab:AddParagraph({
    Title = "chú ý",
    Content = " chú ý xử dụng x2 vs max để treo fram x3 để 
khôi phục lại map và fixlag nhẹ"
   
})

-- Fix Lag X2 - Giảm vừa
FixLagTab:AddButton({
    Title = "Fix Lag X1",
    Description = "50%",
    Callback = function()
        game.Lighting.GlobalShadows = false
        game.Lighting.FogEnd = 100000
        game.Lighting.Brightness = 1
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
    end
})

-- Fix Lag X3 - Giảm mạnh (80%)
FixLagTab:AddButton({
    Title = "Fix Lag X2",
    Description = "60%",
    Callback = function()
        game.Lighting.GlobalShadows = false
        game.Lighting.FogEnd = 100000
        game.Lighting.Brightness = 0
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
                v.Reflectance = 0
                v.Transparency = 0 -- Nếu bạn muốn trong suốt nhẹ có thể chỉnh 0.1 - 0.2
            elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") then
                v:Destroy()
            end
        end

        -- Xóa thêm skybox để giảm lag tối đa
        if game.Lighting:FindFirstChildOfClass("Sky") then
            game.Lighting:FindFirstChildOfClass("Sky"):Destroy()
        end
    end
})

-- Fix Lag Max - Tối ưu cực mạnh cho điện thoại
FixLagTab:AddButton({
    Title = "Fix Lag x3",
    Description = "70%",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        -- Tắt hiệu ứng ánh sáng
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        Lighting.Brightness = 0
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        -- Dọn map
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Beam") then
                v:Destroy()
            elseif v:IsA("SurfaceLight") or v:IsA("PointLight") or v:IsA("SpotLight") then
                v.Enabled = false
            elseif v:IsA("Shirt") or v:IsA("Pants") or v:IsA("Clothing") then
                v:Destroy()
            end
        end

        -- Xóa cây
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:lower():find("tree") then
                v:Destroy()
            end
        end

        -- Xóa các mô hình không cần thiết (giữ lại nhân vật/NPC)
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and not obj:FindFirstChildWhichIsA("Humanoid") and not obj:IsDescendantOf(Players) then
                local name = obj.Name:lower()
                if name:find("rock") or name:find("deco") or name:find("building") or name:find("house") or name:find("prop") or name:find("structure") then
                    obj:Destroy()
                end
            end
        end
    end
})
-- Fix Lag MAX (Giữ ánh sáng + Xóa nhà nhưng đứng được)
FixLagTab:AddButton({
    Title = "Fix Lag MAX",
    Description = "80% ",
    Callback = function()
        -- Remove Skybox Only
        local Lighting = game:GetService("Lighting")
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("Sky") then
                v:Destroy()
            end
        end

        -- Rendering Settings
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        pcall(function()
            settings().Rendering.VSync = false
        end)

        -- Workspace Optimization
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                -- Nếu vật thể là sàn nhà hoặc nền, giữ lại màu
                if obj.Position.Y < 5 then -- Tọa độ thấp => là mặt đất/sàn
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                    obj.CastShadow = false
                else
                    -- Là nhà, đồ vật, làm trong suốt
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                    obj.CastShadow = false
                    obj.Transparency = 1 -- Làm trong suốt nhưng vẫn đứng được
                    if obj:FindFirstChild("Texture") then
                        obj.Texture:Destroy()
                    end
                end
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj:Destroy()
            elseif obj:IsA("Mesh") then
                obj:Destroy()
            end
        end

        -- Clear Terrain Water
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 1
        end

        -- Clear Effects Folder
        if workspace:FindFirstChild("Effects") then
            workspace.Effects:Destroy()
        end
    end
})

local hopsevervipTab= Window:AddTab({
    Title = "hop sever full mon",
    Icon = "server"
})


hopsevervipTab:AddButton({
    Title = "script hop full mon",
    Description = "nhấn để chạy script",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhTuanDzai-Hub/ScriptHopBoss/refs/heads/main/HopFullMom.lua"))()
end
})
hopsevervipTab:AddButton({
    Title = "script hop boss",
    Description = "nhấn để chạy script",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/Min/refs/heads/main/MinHopBoss"))()
end
})
local fruitTab = Window:AddTab({
    Title = "script auto nhặt trái",
    Icon = "apple"
})


fruitTab:AddButton({
    Title = "Turbo Lite Nhặt Trái",
    Description = "nhấn để chạy script ",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/TraiCay.lua"))()
    end
})

local aimbotvipTab = Window:AddTab({
    Title = "aimbot vip",
    Icon = "crosshair"
})


aimbotvipTab:AddButton({
    Title = "aimbot Tuấn Anh IOS",
    Description = "nhấn để chạy script ",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhTuanDzai-Hub/AimBotSkibidi/refs/heads/main/TuanAnhIOS-AIMBOT.Lua"))()
    end
})

local lastNotificationTime = 0
local notificationCooldown = 10
local currentTime = tick()

if currentTime - lastNotificationTime >= notificationCooldown then
    game.StarterGui:SetCore("SendNotification", {
        Title = "phucmaxtonghop", 
        Text = "Đã Tải Xong",
        Duration = 1,
        Icon = "rbxassetid://114009263825021" -- Thay bằng ID logo bạn muốn
    })
    lastNotificationTime = currentTime
end
