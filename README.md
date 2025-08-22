

````markdown
# FiveM-Style Minigame for MTA:SA

This resource is designed for **Multi Theft Auto (MTA:SA)** and brings a modern **FiveM-style minigame system** into the game.  
It replaces the classic circle-based games with a more dynamic, flexible, and fun system.  

## Features
- Works on both **Client** and **Server** side.  
- Easy-to-use `startMiniGame` function.  
- Supports event-based logic with three return parameters:  
  - `state` → success or failure  
  - `player` → the player involved in the minigame  
  - `msg` → failure reason (e.g., wrong key, leaving the area, desync detection)  
- Can be triggered via commands, markers, or colshape areas.  
- Anti-cheat detection (`desync_detected` → kicks/ban logic).  

---

## Usage

### Server-Side Example

loadstring(exports.fivem_minigame:loadMiniGameFunctions())()

addCommandHandler("minigameserver", function(player)
    startMiniGame(player, "fishing:game.server", 1, 1)
end)

addEvent("fishing:game.server", true)
addEventHandler("fishing:game.server", root, function(state, player, msg)
    if not client or player ~= client then return end

    if state then
        outputChatBox("Game completed successfully, you caught the fish!", player, 0, 255, 0)
    else
        if msg == "leavearea" then
            outputChatBox("You failed! The line went outside the circle!", player, 255, 0, 0, true)
        elseif msg == "differentkeyboard" then
            outputChatBox("You failed! Wrong key pressed!", player, 255, 0, 0, true)
        elseif msg == "desync_detected" then
            kickPlayer(player, "HACK DETECTED IN MINIGAME!")
        else
            outputChatBox("You failed! The line went outside the circle!", player, 255, 0, 0, true)
        end
    end
end)

---

### Client-Side Example

loadstring(exports.fivem_minigame:loadMiniGameFunctions())()

addCommandHandler("minigameclient", function()
    startMiniGame("fishing:game.client", 1, 1)
end)

addEvent("fishing:game.client", true)
addEventHandler("fishing:game.client", root, function(state, player, msg)
    if state then
        outputChatBox("Game completed successfully, you caught the fish!", 0, 255, 0)
    else
        if msg == "leavearea" then
            outputChatBox("You failed! The line went outside the circle!", 255, 0, 0, true)
        elseif msg == "differentkeyboard" then
            outputChatBox("You failed! Wrong key pressed!", 255, 0, 0, true)
        elseif msg == "desync_detected" then
            outputChatBox("You failed! Cheating detected!", 255, 0, 0, true)
            -- You can trigger a ban event here
        else
            outputChatBox("You failed! The line went outside the circle!", 255, 0, 0, true)
        end
    end
end)

---

## Example Scenarios

* Start the minigame when a player enters a marker.
* Trigger the game inside a **colshape** area.
* Use it for fishing, lockpicking, hacking, or any interactive gameplay feature.

---

## 📽️ Demo

Video Preview: [Click Here](https://streamable.com/iniy8q)


