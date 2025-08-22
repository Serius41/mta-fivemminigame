Code for client use
```lua
loadstring(exports.fivem_minigame:loadMiniGameFunctions())()

addCommandHandler("minigameclient", function(player)
    startMiniGame("fishing:game.client", 1, 1)
end)


addEvent('fishing:game.client',true)
addEventHandler('fishing:game.client',root,function(state, player, msg)
    if state then 
        outputChatBox("Game completed successfully, you caught the fish!",0,255,0)
    else 
        if msg == "leavearea" then 
            outputChatBox("Unfortunately you failed the game, the line went outside the circle!",255,0,0,true)
        elseif msg == "differentkeyboard" then 
            outputChatBox("Unfortunately you failed the game, you pressed the wrong key!",255,0,0,true)
        elseif msg == "desync_detected" then
            outputChatBox("Unfortunately you failed the game, you cheated!",255,0,0,true)
            --ban event
        else 
            outputChatBox("Unfortunately you failed the game, the line went outside the circle!",255,0,0,true)
        end
    end
end)

