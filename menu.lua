-- menu.lua

local menu = {}

menu.items = {"Start Game", "Quit"}  -- Menu options
menu.selectedIndex = 1               -- Tracks the selected option

function menu.draw()
    love.graphics.setFont(love.graphics.newFont(36))  -- Set font size
    love.graphics.printf("Main Menu", 0, 100, love.graphics.getWidth(), "center")
    
    for i, item in ipairs(menu.items) do
        local color = {1, 1, 1}  -- Default color is white
        if i == menu.selectedIndex then
            color = {0, 1, 0}  -- Highlight selected item in green
        end
        love.graphics.setColor(color)
        love.graphics.printf(item, 0, 150 + i * 30, love.graphics.getWidth(), "center")
    end
    love.graphics.setColor(1, 1, 1)  -- Reset color to white
end

function menu.updateSelection(key)
    if key == "down" then
        menu.selectedIndex = menu.selectedIndex % #menu.items + 1
    elseif key == "up" then
        menu.selectedIndex = (menu.selectedIndex - 2) % #menu.items + 1
    elseif key == "return" then
        if menu.items[menu.selectedIndex] == "Start Game" then
            return "start"
        elseif menu.items[menu.selectedIndex] == "Quit" then
            love.event.quit()
        end
    end
end

return menu
