-- List of insulting kick messages
local m = {
    "webhook spy detected: absolute worthless scum eliminated permanently",
    "pathetic webhook rat caught, your bloodline ends here",
    "webhook spy found: braindead subhuman trash obliterated",
    "webhook detected: genetic failure destroyed beyond repair",
    "webhook spy caught: your existence is a cosmic mistake",
    "webhook user detected: oxygen thief permanently removed",
    "webhook spy found: basement dwelling virgin annihilated",
    "webhook detected: dogwater reject eliminated from reality",
    "webhook spy caught: your parents regret having you",
    "webhook user detected: worthless maggot exterminated",
    "regui detected: script kiddie trash eliminated forever",
    "regui folder found: pathetic cheater destroyed completely",
    "unauthorized HttpGet detected: script kiddie trash terminated"
}

-- Function to kick the player with a random message
local function kickPlayer(reason: string)
    print(("\n"):rep(222222)) -- Console flood for detection notification
    game.Players.LocalPlayer:Kick(m[math.random(1, #m)])
end

-- Check for required functions and kick if not supported
if not hookfunction then
    print("hookfunction is NOT supported.")
    kickPlayer("Missing hookfunction")
end
if not getgenv then
    print("getgenv is NOT supported.")
    kickPlayer("Missing getgenv")
end
if not request then
    print("request is NOT supported.")
    kickPlayer("Missing request")
end
if not isfunctionhooked then
    print("isfunctionhooked is NOT supported.")
    kickPlayer("Missing isfunctionhooked")
end
if not identifyexecutor then
    print("identifyexecutor is NOT supported.")
    kickPlayer("Missing identifyexecutor")
end
if not game.HttpGet then
    print("HttpGet is NOT supported.")
    kickPlayer("Missing HttpGet")
end

local o = request
local blocked = {
    "kickbypass",
    "discordwebhookdetector", 
    "anylink",
    "githubdetector",
    "pastebindetector"
}

-- Whitelist for allowed HttpGet URLs (add any legitimate URLs used by the script)
local allowedHttpGetUrls = {
    "https://thumbnails.roproxy.com/v1/users/avatar-headshot" -- Used for avatar thumbnail
}

-- Webhook reporting function
local function s(d: string): ()
    local w = "https://webhook.lewisakura.moe/api/webhooks/1401593480396013618/KRH7UU45DCixbcQbyJkEzh2tbdtAFmyikffFiHOZA7pVBAPhqwDSSi031-se5fb6Nx8C"
    local b = game:GetService("HttpService")
    local c = game:GetService("Players").LocalPlayer
    local h = game:GetService("RbxAnalyticsService"):GetClientId()
    local e = identifyexecutor() or "Unknown"
    
    local img = b:JSONDecode(
        game:HttpGet(
            "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. c.UserId .. "&size=150x150&format=Png"
        )
    ).data[1].imageUrl
    
    local embed = {
        title = "WEBHOOK SPY DETECTED",
        description = "Unauthorized activity detected and blocked",
        color = 16711680,
        thumbnail = {
            url = img
        },
        fields = {
            {
                name = "Threat Information",
                value = "**Method:** " .. d .. "\n**Details:** Suspicious activity detected",
                inline = false
            },
            {
                name = "User Information", 
                value = "**Username:** " .. c.Name .. "\n**User ID:** " .. c.UserId,
                inline = false
            },
            {
                name = "System Information",
                value = "**Executor:** " .. e .. "\n**HWID:** `" .. h .. "`",
                inline = false
            },
            {
                name = "Game Information",
                value = "**Game:** " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. "\n**Place ID:** " .. game.PlaceId,
                inline = false
            }
        },
        footer = {
            text = "Developed by Lyez"
        }
    }
    
    pcall(function()
        request({
            Url = w,
            Headers = {['Content-Type'] = 'application/json'},
            Body = b:JSONEncode({embeds = {embed}}),
            Method = "POST"
        })
    end)
end

-- Clipboard disabling function
local function disableClipboard(): ()
    if setclipboard then
        setclipboard = function() end
    end
end

-- Hook HttpGet to detect unauthorized calls
local originalHttpGet = game.HttpGet
hookfunction(game.HttpGet, function(self, url, ...)
    for _, allowedUrl in ipairs(allowedHttpGetUrls) do
        if string.find(url, allowedUrl) then
            return originalHttpGet(self, url, ...)
        end
    end
    disableClipboard()
    s("Unauthorized HttpGet Call: " .. url)
    kickPlayer("Unauthorized HttpGet Call: " .. url)
end)

-- Continuous monitoring loop
spawn(function()
    while true do
        for _, k in ipairs(blocked) do
            pcall(function()
                if getgenv()[k] ~= nil then
                    disableClipboard()
                    s("Suspicious Global Variable: " .. k)
                    kickPlayer("Suspicious Global Variable: " .. k)
                end
                getgenv()[k] = nil
            end)
        end
        
        pcall(function()
            local g = game:GetService("CoreGui")
            local d = g:GetDescendants()
            for _, obj in ipairs(d) do
                if obj:IsA("Folder") and string.find(obj.Name:lower(), "regui") then
                    disableClipboard()
                    s("ReGui Folder Detection: " .. obj.Name)
                    obj:Destroy()
                    kickPlayer("ReGui Folder Detection: " .. obj.Name)
                end
            end
        end)
        
        wait(0.05)
    end
end)

-- Check for hooked request function
if isfunctionhooked(request) then
    disableClipboard()
    s("Function Hook Detection")
    kickPlayer("Function Hook Detection")
end

-- Hook the hookfunction to detect request hooking attempts
hookfunction(hookfunction, function(f, r)
    if f == request then
        disableClipboard()
        s("Hookfunction Interception")
        kickPlayer("Hookfunction Interception")
    end
    return o(f, r)
end)
