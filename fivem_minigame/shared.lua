
if localPlayer then 
   width,height = respcX(132),respcY(132)

   colors = {
        ui = {
            cricle = "#2b322b",
            area = "#05916e",
            detectedline = "#39d0a7",
            white = "#ffffff",
        }
   }
end

keys = {
    [1] = {"1","2","3","4","5","6","7","8","9","0"},
    [2] = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"},
}    

function getRandomStartPosition(areaAngle, areaAngleRange)
    local startAngle
    repeat
        startAngle = math.random(0, 360)
        local angleDiff = math.abs(startAngle - areaAngle)
        if angleDiff > 180 then
            angleDiff = 360 - angleDiff
        end
    until angleDiff > (areaAngleRange / 2)
    return startAngle
end

function isLineInArea(areaAngleRange, rotation, random)
    local lineAngle = rotation % 360
    local areaAngle = random % 360
    local half = areaAngleRange / 2

    local startAngle = (areaAngle - half + 360) % 360
    local endAngle   = (areaAngle + half) % 360 + 65

    local function isBetween(a, s, e)
        if s <= e then
            return a >= s and a <= e
        else
            return a >= s or a <= e
        end
    end

    local inside = isBetween(lineAngle, startAngle, endAngle)

    if localPlayer then
        currentAngleDiff = lineAngle
        currentLimit = startAngle .. " - " .. endAngle
    end

    return inside,currentLimit,currentAngleDiff,startAngle,endAngle
end

function isCorrectKey(pressedKey, targetKey)
    if not pressedKey or not targetKey then return false end
    
    local target = string.lower(tostring(targetKey))
    local pressed = string.lower(tostring(pressedKey))
    
    if pressed == target then return true end
    
    local numpadMap = {
        ["num_1"]="1",["num_2"]="2",["num_3"]="3",["num_4"]="4",["num_5"]="5",
        ["num_6"]="6",["num_7"]="7",["num_8"]="8",["num_9"]="9",["num_0"]="0"
    }
    
    return numpadMap[pressedKey] == target
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end
