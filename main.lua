local menu = require("menu")
local gameState = "menu"

local NPC = require("npc")
local playerSprite = love.graphics.newImage('sprites/capy.png')


local npc

local Dialove = require('libraries/dialove/Dialove')

function love.load()
    
    dialogManager = Dialove.init({
        font = love.graphics.newFont('fonts/earthbound_beginnings/earth.ttf', 16)
      })

    -- use this approach instead:
  
    dialogManager:show({text ='What Am I doing back here in Wilbrod...', title = 'Inner Thoughts'})
    dialogManager:push({text ='Wheres Nic? Been a while...', title = 'Carlos'})
    dialogManager:push('Better check the shed.  Theres always someone in there.')  




    sounds = {}

    sounds.blip = love.audio.newSource("sounds/blip.wav" , "static")
    sounds.music = love.audio.newSource("sounds/music.mp3", "stream")
    sounds.music:setLooping(true)


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
    player.collider = world:newBSGRectangleCollider(400,250,40,80,10)
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

    npc = NPC.new(100,1700,playerSprite)

    walls = {}
    if gameMap.layers["Walls"] then
        for i, obj in pairs(gameMap.layers["Walls"].objects) do
            local wall = world:newRectangleCollider(obj.x , obj.y, obj.width, obj.height)
            wall:setType("static")
            table.insert(walls, wall)

        end
    
    end


    sounds.music:play()
    
end



function love.update(dt)

    if gameState == "menu" then


    elseif gameState == "playing" then 

        dialogManager:update(dt)

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


        npc:update(player.x, player.y)
    end    
end

function love.draw()
    if gameState == "menu" then
        menu.draw()  -- Draw the menu screen



    elseif gameState == "playing" then
        cam:attach()
        gameMap:drawLayer(gameMap.layers["Ground"])
        gameMap:drawLayer(gameMap.layers["Trees"])
        gameMap:drawLayer(gameMap.layers["superTrees"])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 6, 9)
        world:draw()
        npc:draw()
        cam:detach()

        dialogManager:draw()
        



    end
end


function love.keypressed(key)
    if gameState == "menu" then
        -- Handle menu selection
        local action = menu.updateSelection(key)
        if action == "start" then
            gameState = "playing"
            sounds.music:play()
        end

    elseif gameState == "playing" then
        -- Handle game sound effects
        if key == "space" then
            sounds.blip:play()
        elseif key == "z" then
            sounds.music:stop()
        end

        -- Handle dialogue manager controls
        if key == 'return' then
            dialogManager:pop()
        elseif key == 'c' then
            dialogManager:complete()
        elseif key == 'f' then
            dialogManager:faster()
        end

        -- Handle NPC interaction if player is near
        if key == "e" and npc.isNearPlayer then
            -- Uncomment and customize this line for specific NPC interactions
            -- dialogManager:show({text = "Yooo Carlos, any chance you got a light? Would let you in but we need one hehe", title = "Mascouche"})
        end
    end
end
    

function love.keyreleased(k)
    if k == 'space' then
      dialogManager:slower()
    end
end