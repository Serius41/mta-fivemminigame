loadstring(exports.fivem_minigame:loadMiniGameFunctions())()

addCommandHandler("minigameserver", function(player)
    startMiniGame(player, "fishing:game.server", 1, 1)
end)


addEvent('fishing:game.server',true)
addEventHandler('fishing:game.server',root,function(state, player, msg)
    if not client then 
        return 
    end
    
    if player ~= client then return end

    if state then 
        outputChatBox("Game completed successfully, you caught the fish!",player,0,255,0)
    else 
        if msg == "leavearea" then 
            outputChatBox("Unfortunately you failed the game, the line went outside the circle!",player,255,0,0,true)
        elseif msg == "differentkeyboard" then 
            outputChatBox("Unfortunately you failed the game, you pressed the wrong key!",player,255,0,0,true)
        elseif msg == "desync_detected" then
            kickPlayer(player, "HACK DETECTED IN MINIGAME!")
        else 
            outputChatBox("Unfortunately you failed the game, the line went outside the circle!",player,255,0,0,true)
        end
    end
end)