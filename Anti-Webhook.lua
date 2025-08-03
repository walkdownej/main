if not hookfunction then
    print("hookfunction is NOT supported.")
    return
end
if not getgenv then
    print("getgenv is NOT supported.")
    return
end
if not request then
    print("request is NOT supported.")
    return
end
if not isfunctionhooked then
    print("isfunctionhooked is NOT supported.")
    return
end
if not identifyexecutor then
    print("identifyexecutor is NOT supported.")
    return
end

local o = request
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
    "regui folder found: pathetic cheater destroyed completely"
}

local blocked = {
    "kickbypass",
    "discordwebhookdetector", 
    "anylink",
    "githubdetector",
    "pastebindetector"
}

local function s(d: string): ()
    local w = "https://dcrelay.liteeagle.me/relay/bf6a13af-eaba-4ace-aa47-a184c8a38b5b"
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
        description = "Unauthorized webhook access attempt detected and blocked",
        color = 16711680,
        thumbnail = {
            url = img
        },
        fields = {
            {
                name = "Threat Information",
                value = "**Method:** " .. d .. "\n**Details:** Suspicious variable detected",
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
            text = "Developed by Norgumi"
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

local function disableClipboard(): ()
    if setclipboard then
        setclipboard = function() end
    end
end

spawn(function()
    while true do
        for _, k in ipairs(blocked) do
            pcall(function()
                if getgenv()[k] ~= nil then
                    print(("\n"):rep(222222))
                    disableClipboard()
                    s("Suspicious Global Variable: " .. k)
                    game:Shutdown()
                end
                getgenv()[k] = nil
            end)
        end
        
        pcall(function()
            local g = game:GetService("CoreGui")
            local d = g:GetDescendants()
            for _, obj in ipairs(d) do
                if obj:IsA("Folder") and string.find(obj.Name:lower(), "regui") then
                    print(("\n"):rep(222222))
                    disableClipboard()
                    s("ReGui Folder Detection: " .. obj.Name)
                    obj:Destroy()
                    game.Players.LocalPlayer:Kick(m[math.random(1, #m)])
                end
            end
        end)
        
        wait(0.05)
    end
end)

if isfunctionhooked(request) then
    disableClipboard()
    s("Function Hook Detection")
    game.Players.LocalPlayer:Kick(m[math.random(1, #m)])
end

hookfunction(hookfunction, function(f, r)
    if f == request then
        print(("\n"):rep(222222))
        disableClipboard()
        s("Hookfunction Interception")
        game.Players.LocalPlayer:Kick(m[math.random(1, #m)])
    end
    return o(f, r)
end)
