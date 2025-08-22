local resourcename = getResourceName(getThisResource())

local functions = {
  "function startMiniGame(...) return exports." .. resourcename .. ":startMiniGame(...) end",
  "function stopMiniGame(...) return exports." .. resourcename .. ":stopMiniGame(...) end",
  "function getStateMiniGame(...) return exports." .. resourcename .. ":getStateMiniGame(...) end",
}

function loadMiniGameFunctions()
  local combined = ""
  for _, v in ipairs(functions) do
    combined = combined .. v .. "\n"
  end
  return combined
end
