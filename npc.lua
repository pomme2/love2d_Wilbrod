-- npc.lua

local npc = {}

function npc.new(x, y, sprite)
    local self = {}
    self.x = x
    self.y = y
    self.sprite = sprite  -- Load the same sprite used for the player
    self.dialogue = "Hello! I'm an NPC."
    self.isNearPlayer = false  -- Tracks if player is close for interaction

    function self:draw()
        -- Draw the NPC sprite
        --love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
        love.graphics.draw(self.sprite, self.x, self.y, 0, 0.2, 0.2, 1, 1)

    end

    function self:update(playerX, playerY)
        -- Check distance between player and NPC
        local dx = playerX - self.x
        local dy = playerY - self.y
        local distance = math.sqrt(dx * dx + dy * dy)

        -- Set proximity flag for interaction
        self.isNearPlayer = distance < 200
    end

    function self:interact()
        -- Trigger dialogue when interacting
        if self.isNearPlayer then
            return self.dialogue
        end
    end

    return self
end

return npc
