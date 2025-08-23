# FiveM-Style Minigame for MTA:SA

This resource is designed for **Multi Theft Auto (MTA:SA)** and brings a modern **FiveM-style minigame system** into the game.  
It replaces the classic circle-based games with a more dynamic, flexible, and fun system.  

---

## Features
- Works on both **Client** and **Server** side.  
- Easy-to-use `startMiniGame` function with **client/server parameter**.  
- Supports event-based logic with three return parameters:  
  - `state` → success or failure  
  - `player` → the player involved in the minigame  
  - `msg` → failure reason (e.g., wrong key, leaving the area, desync detection)  
- Can be triggered via commands, markers, or colshape areas.  
- Anti-cheat detection (`desync_detected` → kicks/ban logic).  
- Fixed screen resolution issues (including **1366x768 screenfix bug**).  
- Key system updated:  
  - Only recognizes **1, 2, 3, 4** keys (like in FiveM).  
  - Wrong detection issue fixed.  
  - Each use now generates a **different random key** (no more repeating the same one).  

---

## 🔧 Usage

### Server → Client Example
```lua
startMiniGame(thePlayer, "fishing:game.client", 1, 3, nil, {"event params, e.g. item id"}, "client")
```

### Client → Server Example
```lua
startMiniGame("fishing:game.server", 1, 3, localPlayer, nil, false, {"event params, e.g. item id"}, "server")
```

### Client → Client Example
```lua
startMiniGame("fishing:game.client", 1, 3, localPlayer, nil, false, {"event params, e.g. item id"}, "client")
```

### Server → Server Example
```lua
startMiniGame(player, "fishing:game.server", 1, 3, nil, {"event params, e.g. item id"}, "server")
```

---

## Server-Side Example
```lua
loadstring(exports.fivem_minigame:loadMiniGameFunctions())()

addCommandHandler("minigameserver", function(player)
    startMiniGame(player, "fishing:game.server", 1, 1, nil, {"fish_id"}, "server")
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
            outputChatBox("You failed!", player, 255, 0, 0, true)
        end
    end
end)
```

---

## 🖥Client-Side Example
```lua
loadstring(exports.fivem_minigame:loadMiniGameFunctions())()

addCommandHandler("minigameclient", function()
    startMiniGame("fishing:game.client", 1, 1, localPlayer, nil, false, {"fish_id"}, "client")
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
            -- Optional: trigger a ban event here
        else
            outputChatBox("You failed!", 255, 0, 0, true)
        end
    end
end)
```

---

## Example Scenarios
* Start the minigame when a player enters a marker.  
* Trigger the game inside a **colshape** area.  
* Use it for **fishing, lockpicking, hacking, or any interactive gameplay feature**.  

---

## 📽️ Demo
Video Preview: [Click Here](https://streamable.com/gcafqu)
