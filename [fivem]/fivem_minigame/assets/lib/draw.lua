local svgRectangles = {}

function drawRoundedRectangle(x, y, w, h, color, radius, rotation, ...)
    if (not svgRectangles[w]) then
        svgRectangles[w] = {}
    end

    if (not svgRectangles[w][h]) then
        svgRectangles[w][h] = {}
    end

    if (not svgRectangles[w][h][radius]) then
        local raw = [[
            <svg width=']]..w..[[' height=']]..h..[[' fill='none'>
                <mask id='path_inside' fill='white' >
                    <rect width=']]..w..[[' height=']]..h..[[' rx=']]..radius..[[' />
                </mask>
                <rect width=']]..w..[[' height=']]..h..[[' rx=']]..radius..[[' fill='white' mask='url(#path_inside)'/>
            </svg>
        ]]

        svgRectangles[w][h][radius] = svgCreate(w, h, raw, function(e)
            if (not e or not isElement(e)) then 
                return
            end
            dxSetTextureEdge(e, "mirror")
            dxSetTextureEdge(e, 'border')
        end)
    end

    if (svgRectangles[w][h][radius]) then
        dxDrawImage(x, y, w, h, svgRectangles[w][h][radius], (rotation or 0), 0, 0, color, ...)
    end
end

local svgCacheTextures = {} 
function dxDrawSvgImage(x, y, w, h, svgData, rotation, color, postgui)
    local key = string.format("%d%d%s", w, h, svgData)
    if not svgCacheTextures[key] then
        svgCacheTextures[key] = svgCreate(w, h, svgData)
    end

    if svgCacheTextures[key] then
        dxSetBlendMode ('modulate_add');
            dxDrawImage(x, y, w, h, svgCacheTextures[key], rotation or 0, 0, 0, color or tocolor(255, 255, 255), postgui or false)
            dxSetTextureEdge(svgCacheTextures[key], "mirror")
        dxSetBlendMode ('blend');
    end
end

function destroyAllTextures()

    for w, ht in pairs(svgRectangles) do
        for h, rt in pairs(ht) do
            for radius, tex in pairs(rt) do
                if isElement(tex) then
                    destroyElement(tex)
                end
                svgRectangles[w][h][radius] = nil
            end
            svgRectangles[w][h] = nil
        end
        svgRectangles[w] = nil
    end

    for key, tex in pairs(svgCacheTextures) do
        if isElement(tex) then
            destroyElement(tex)
        end
        svgCacheTextures[key] = nil
    end

end