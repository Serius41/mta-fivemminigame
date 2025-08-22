function centerDrawRoundedText(x, y, w, h, text)
    drawRoundedRectangle(x, y, w, h, getColor("ui","area",255), scaleRadius(5), 0,false)
    dxDrawText(text, x, y, x+w, y+h, getColor("ui","white",255), respcY(2), "default-bold", "center", "center")
end
