function love.load()
    wf = require "libraries/windfield/windfield"

    world = wf.newWorld(0,0)

    --test = world:newRectangleCollider(350,100,80,80)
    --ground = world:newRectangleCollider(100,400,600,100)

   -- ground:setType("static")


    camera = require 'libraries/camera'
    cam = camera()

    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")


    sti = require 'libraries/sti'
    gameMap = sti('maps/testMap.lua')


    player = {}
    player.collider = world:newBSGRectangleCollider(400,250,50,100,10)
    player.collider:setFixedRotation(true)
    player.x = 400
    player.y = 200
    player.speed = 300
    player.sprite = love.graphics.newImage('sprites/capy.png')
    player.spriteSheet = love.graphics.newImage('sprites/player-sheet.png')
    player.grid = anim8.newGrid(12,18,player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    

    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    player.animations.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

    player.anim = player.animations.left


    background = love.graphics.newImage('sprites/bg.jpg')

    walls = {}
    if gameMap.layers["Walls"] then
        for i, obj in pairs(gameMap.layers["Walls"].objects) do
            local wall = world:newRectangleCollider(obj.x , obj.y, obj.width, obj.height)
            wall:setType("static")
            table.insert(walls, wall)

        end
    
    end

    
end



function love.update(dt)
    local isMoving = false

    local vx = 0
    local vy = 0
    
    

    if love.keyboard.isDown("right") then
        vx = player.speed
        player.anim = player.animations.right
        isMoving = true
    end
    if love.keyboard.isDown("left") then
        vx = player.speed * -1
        player.anim = player.animations.left
        isMoving = true

    end
    if love.keyboard.isDown("down") then
        vy = player.speed
        player.anim = player.animations.down
        isMoving = true

    end
    if love.keyboard.isDown("up") then
        vy = player.speed * -1
        player.anim = player.animations.up
        isMoving = true
       -- test:applyLinearImpulse(0, -140)

    end

    player.collider:setLinearVelocity(vx,vy)
    
    if isMoving == false then
        player.anim:gotoFrame(2)
        
    end

    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()


    player.anim:update(dt)

    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if cam.x < w/2 then 
        cam.x = w/2
    end
    if cam.y < h/2 then 
        cam.y = h/2
    end


    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    --right border
    if cam.x > (mapW - w/2) then   
        cam.x = (mapW - w/2)
    end

    --bottom border
    if cam.y > (mapH - h/2) then
        cam.y = (mapH - h/2)
    end
end

function love.draw()
   
    cam:attach() 
        gameMap:drawLayer(gameMap.layers["Ground"])
        gameMap:drawLayer(gameMap.layers["Trees"])
        gameMap:drawLayer(gameMap.layers["superTrees"])
        player.anim:draw(player.spriteSheet, player.x , player.y , nil,6,nil,6,9)
        --remove world to remove hitbox
        --world:draw()
    cam:detach()

  
end