local width, height = term.getSize()

local success, theme = ui.theme.load("main.lua")
---@type uiManager
local manager = ui.uiManager.new(1, 1, width, height)
manager.recalculate = function()
    local index
    for i = 1, width * height do
        if i <= width then
            manager.buffer.text[i] = " "
            manager.buffer.textColor[i] = colors.lime
            manager.buffer.textBackgroundColor[i] = colors.lime
        else
            manager.buffer.text[i] = " "
            manager.buffer.textColor[i] = colors.white
            manager.buffer.textBackgroundColor[i] = colors.white
        end
    end
end
manager.recalculate()

---@type style.button

local exitButton =
    ui.button.new(
    manager,
    "x",
    function()
    end,
    theme.exitButton,
    width - 2,
    1,
    3,
    1
)

local downloadButton =
    ui.button.new(
    manager,
    "download",
    function()
    end,
    theme.menuButton,
    2,
    1,
    10,
    1
)

manager.draw()
manager.execute()
