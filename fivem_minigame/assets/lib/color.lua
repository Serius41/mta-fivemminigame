function getColor(group, index, alpha)
    local group = colors[group]

    if not group then
        return tocolor(0, 0, 0, alpha)
    end

    if not group[index] then
        return tocolor(255, 255, 255, alpha)
    end

    local r, g, b = getColorFromString(group[index])

    return tocolor(r, g, b, alpha)
end

function fromColor(color)
    if color then
        local blue = bitExtract(color, 0, 8)
        local green = bitExtract(color, 8, 8)
        local red = bitExtract(color, 16, 8)
        local alpha = bitExtract(color, 24, 8)

        return red, green, blue, alpha
    end
end