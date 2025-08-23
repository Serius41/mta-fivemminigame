local activeGames = {}

function startMiniGame(player, event, speed, maxRights, keys, extraArgs, targetEvents)
    if not isElement(player) then return end
    
    local gameId = tostring(player) .. "_" .. getTickCount()
    activeGames[player] = {
        gameId = gameId,
        event = event,
        speed = speed or 1,
        maxRights = maxRights or 3,
        keys = keys,
        correctCount = 0,
        currentRandom = math.random(0, 360),
        currentRotation = getRandomStartPosition(math.random(0, 360), 52),
        startTime = getTickCount(),
        lastKeyTime = 0,
        randomKey = math.random(1, 2),
        gameActive = true
    }
    
    local onKey = keys  or {{"1", "2", "3", "4"}, {"1", "2", "3", "4"}}
    local selectedKeyGroup = onKey[activeGames[player].randomKey]
    activeGames[player].keyboard = selectedKeyGroup[math.random(#selectedKeyGroup)]
    
    triggerClientEvent(player, "onClientStartMiniGame", player, {
        gameId = gameId,
        event = event,
        speed = speed,
        maxRights = maxRights,
        random = activeGames[player].currentRandom,
        rotation = activeGames[player].currentRotation,
        keyboard = activeGames[player].keyboard,
        extraArgs = extraArgs,
        targetEvents = targetEvents
    })
end 

function stopMiniGame(player)
    if not isElement(player) then return end
    activeGames[player] = nil
    triggerClientEvent(player,"onClientStopMiniGame",player)
end

function validateKeyPress(player, key, clientRotation, clientRandom)
    local gameState = activeGames[player]
    if not gameState or not gameState.gameActive then 
        return false, "no_active_game"
    end
    
    local currentTime = getTickCount()
    gameState.lastKeyTime = currentTime
    
    if key ~= gameState.keyboard then
        return false, "wrong_key"
    end
    
    if math.abs(clientRandom - gameState.currentRandom) > 5 then
        return false, "desync_detected"
    end
    
    local clientInArea = isLineInArea(52, clientRotation, clientRandom)
    
    if not clientInArea then
        return false, "not_in_area"
    end
    
    gameState.correctCount = gameState.correctCount + 1
    
    if gameState.correctCount >= gameState.maxRights then
        activeGames[player] = nil
        return true, "completed"
    else
        gameState.currentRandom = math.random(0, 360)
        gameState.currentRotation = getRandomStartPosition(gameState.currentRandom, 52)
        gameState.randomKey = math.random(1, 2)
        
        local onKey = keys or {{"1", "2", "3", "4"}, {"1", "2", "3", "4"}}
        local selectedKeyGroup = onKey[gameState.randomKey]
        gameState.keyboard = selectedKeyGroup[math.random(#selectedKeyGroup)]
        
        return true, "continue", {
            random = gameState.currentRandom,
            rotation = gameState.currentRotation,
            correctCount = gameState.correctCount,
            keyboard = gameState.keyboard
        }
    end
end

addEvent("onServerValidateKey", true)
addEventHandler("onServerValidateKey", root, function(key, clientRotation, clientRandom)
    local success, reason, data = validateKeyPress(client, key, clientRotation, clientRandom)
    triggerClientEvent(client, "onClientKeyValidated", client, success, reason, data)
end)

addEventHandler("onPlayerQuit", root, function()
    if activeGames[source] then
        activeGames[source] = nil
    end
end)