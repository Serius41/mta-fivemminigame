screenX,screenY = guiGetScreenSize()
panelWidth, panelHeight = 1920, 1080
scaleX, scaleY = screenX/panelWidth, screenY/panelHeight

function respcX(val)
    return val * scaleX
end

function respcY(val)
    return val * scaleY
end

function centerPosition(val,y)
    if y then 
        return (screenY - respcY(val)) / 2
    else
         return (screenX - respcX(val)) / 2
    end
end

function centerPositionParent(val,y,parentW,parentH)
    if y then 
        return (parentH - val) / 2
    else
         return (parentW - val) / 2
    end
end

local scale = math.min(math.max(0.8, math.min(screenX / 1920, screenY / 1080)), 1)

function getFontScale()
    return scale
end

function scaleRadius(val)
    return val * scale
end