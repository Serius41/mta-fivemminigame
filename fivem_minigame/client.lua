MiniGame = {}

function startMiniGame(event, speed, maxRights, player, key, fromServer, extraArgs, targetEvents)
    if not isEventHandlerAdded("onClientRender", root, render) then
        MiniGame.textures = {}
        MiniGame.textures.cricle = dxCreateTexture("assets/img/cricle.png")
        MiniGame.textures.area = dxCreateTexture("assets/img/detected_area.png")
        MiniGame.textures.detectedline = dxCreateTexture("assets/img/detected_line.png")

        MiniGame.speed = speed or 1
        MiniGame.state = true
        MiniGame.gameActive = true
        MiniGame.hasEnteredArea = false  
        MiniGame.previousInArea = nil    
        MiniGame.correctCount = 0       
        MiniGame.maxRights = maxRights or 3
        MiniGame.lastLeaveTime = 0         
        MiniGame.fromServer = fromServer or false
        MiniGame.waitingForValidation = false
        
        MiniGame.event = event
        MiniGame.extraArgs = extraArgs or nil

        if targetEvents == "client" or targetEvents == "server" then
            MiniGame.callbackTarget = targetEvents
        else
            MiniGame.callbackTarget = (MiniGame.fromServer and "client") or "server"
        end
        addEvent(MiniGame.event, true)

        MiniGame.player = player or localPlayer
        toggleAllControls(false)

        if not fromServer then
            MiniGame.random = math.random(0, 360)
            MiniGame.rotation = getRandomStartPosition(MiniGame.random, 52)
            local keyGroups = keys or {{"1", "2", "3", "4"}, {"1", "2", "3", "4"}}
            local selectedGroup = keyGroups[math.random(1, 2)]
            MiniGame.keyboard = selectedGroup[math.random(#selectedGroup)]
        else
            MiniGame.random = nil
            MiniGame.rotation = nil
            MiniGame.keyboard = key
        end 

        addEventHandler("onClientRender", root, render)
        addEventHandler("onClientKey", root, onKeyPress)
    end
end

function handleServerGameData(gameData)
    if not MiniGame then return end
    
    MiniGame.gameId = gameData.gameId
    MiniGame.random = gameData.random
    MiniGame.rotation = gameData.rotation
    MiniGame.keyboard = gameData.keyboard
    MiniGame.event = gameData.event
    MiniGame.speed = gameData.speed
    MiniGame.maxRights = gameData.maxRights
    MiniGame.extraArgs = gameData.extraArgs
end

function MiniGame.Status(state,msg)
    local extra = MiniGame.extraArgs or {}
    if MiniGame.callbackTarget == "client" then
        triggerEvent(MiniGame.event, resourceRoot, state, MiniGame.player, msg, unpack(extra))
    else
        triggerServerEvent(MiniGame.event, resourceRoot, state, MiniGame.player, msg, unpack(extra))
    end
end

function onKeyPress(key, press)
    if not press or not MiniGame or not MiniGame.gameActive or MiniGame.waitingForValidation then return end
    

    if not isCorrectKey(key, MiniGame.keyboard) then 
        MiniGame.Status(false,"differentkeyboard")
        stopMiniGame()
        return 
    end

    if isCorrectKey(key, MiniGame.keyboard) then
        if MiniGame.fromServer then
            MiniGame.waitingForValidation = true
            triggerServerEvent("onServerValidateKey", resourceRoot, key, MiniGame.rotation, MiniGame.random)
        else
            local isInArea = isLineInArea(52, MiniGame.rotation, MiniGame.random)
            if not isInArea then
                MiniGame.Status(false,"leavearea")
                stopMiniGame()
                return
            end
            
            MiniGame.correctCount = MiniGame.correctCount + 1
            
            if MiniGame.correctCount >= MiniGame.maxRights then
                MiniGame.Status(true)
                stopMiniGame()
            else
                MiniGame.random = math.random(0, 360)
                MiniGame.rotation = getRandomStartPosition(MiniGame.random, 52)
                local keyGroups = keys or {{"1", "2", "3", "4"}, {"1", "2", "3", "4"}}
                local selectedGroup = keyGroups[math.random(1, 2)]
                MiniGame.keyboard = selectedGroup[math.random(#selectedGroup)]
                MiniGame.hasEnteredArea = false
                MiniGame.previousInArea = nil
            end
        end
    end
end

addEvent("onClientKeyValidated", true)
addEventHandler("onClientKeyValidated", root, function(success, reason, data)
    if not MiniGame then return end
    
    MiniGame.waitingForValidation = false
    
    if success then
        if reason == "completed" then
            MiniGame.Status(true)
            stopMiniGame()
        elseif reason == "continue" and data then
            MiniGame.random = data.random
            MiniGame.rotation = data.rotation
            MiniGame.correctCount = data.correctCount
            MiniGame.keyboard = data.keyboard
            MiniGame.hasEnteredArea = false
            MiniGame.previousInArea = nil
        end
    else
        local errorMsg = reason
        if reason == "desync_detected" then
            errorMsg = "cheat_detected"
        elseif reason == "not_in_area" then
            errorMsg = "leavearea"
        elseif reason == "wrong_key" then
            errorMsg = "differentkeyboard"
        end
        
        MiniGame.Status(false, errorMsg)
        stopMiniGame()
    end
end)

function render()
    if not MiniGame or not MiniGame.textures or not MiniGame.gameActive or not MiniGame.random or not MiniGame.rotation then return end

    local isInArea,currentAngleDiff,currentLimit,startAngle,endAngle = isLineInArea(52, MiniGame.rotation, MiniGame.random)

    if MiniGame.previousInArea == nil then
        MiniGame.previousInArea = isInArea
    else
        if not MiniGame.hasEnteredArea and isInArea and not MiniGame.previousInArea then
            MiniGame.hasEnteredArea = true
        end
    
        if MiniGame.hasEnteredArea and not isInArea and MiniGame.previousInArea then
            local currentTime = getTickCount()
            if currentTime - MiniGame.lastLeaveTime > 300 then
                MiniGame.lastLeaveTime = currentTime
                MiniGame.Status(false,"leavearea")
                stopMiniGame()
            end
            return
        end
        
        MiniGame.previousInArea = isInArea
    end

    MiniGame.rotation = (MiniGame.rotation + (MiniGame.speed or 2)) % 360
       
    dxDrawImage(x, y, width, height, MiniGame.textures.cricle, 0,0,0,getColor("ui","cricle",255))
    dxDrawImage(x, y, width, height, MiniGame.textures.area, MiniGame.random, 0,0,getColor("ui","area",255))
    dxDrawImage(x, y, width, height, MiniGame.textures.detectedline, MiniGame.rotation, 0,0,getColor("ui","detectedline",255))

    if MiniGame.keyboard then
        centerDrawRoundedText(centerPosition(40), centerPosition(40, true), respcX(40), respcY(40), string.upper(tostring(MiniGame.keyboard)))
    end
end

function clearMiniGame()
    if MiniGame and MiniGame.textures then
        for _, v in pairs(MiniGame.textures) do
            if isElement(v) then destroyElement(v) end
        end
        MiniGame.textures = nil
        MiniGame.state = false
        MiniGame.gameActive = false

        removeEventHandler("onClientRender", root, render)
        if isEventHandlerAdded("onClientKey", root, onKeyPress) then
            removeEventHandler("onClientKey", root, onKeyPress)
        end
        setTimer(function() toggleAllControls(true) end, 500, 1)
    end
end

function stopMiniGame()
    clearMiniGame()
end

function getStateMiniGame()
    return MiniGame and MiniGame.state or false
end

addEvent("onClientStartMiniGame", true)
addEventHandler("onClientStartMiniGame", root, function(gameData)
    startMiniGame(gameData.event, gameData.speed, gameData.maxRights, localPlayer, gameData.keyboard, true, gameData.extraArgs, gameData.targetEvents)
    handleServerGameData(gameData)
end)

addEvent("onClientStopMiniGame", true)
addEventHandler("onClientStopMiniGame", root, function()
    MiniGame.Status(false)
    stopMiniGame()
end)
