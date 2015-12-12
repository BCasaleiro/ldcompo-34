
function startGame()
    -- basic objects
    map = {
        matrix = { },
        emptySpots = 0,
        virusContained = 500,
        size = 0
    }

    player = {
        playCounter = 10,
        playTimer = 200,
        savingCounter = 2,
        won = false
    }

    initiateMap()

    currentState = "intro"
end

function love.load()
    startGame()

    backgroundSound = love.audio.newSource("background.mp3")
    backgroundSound:play()

    cellImage = love.graphics.newImage("cell.png")
    infectedCellImage = love.graphics.newImage("infected-cell.png")
    protectedCellImage = love.graphics.newImage("protected-cell.png")

    coolFont = love.graphics.newFont("ProggySquareTT.ttf", 50)
    love.graphics.setFont(coolFont)

end

function love.update(dt)
    if currentState == "game" then

        player.playTimer = player.playTimer - 1
        map.virusContained = map.virusContained - 1

        if map.virusContained == 0 then
            player.won = true
            currentState = "endgame"
        end

        if map.emptySpots <= 0 then
            currentState = "endgame"
        end

        if player.playTimer <= 0 then
            player.playCounter = player.playCounter + 1
            player.playTimer = 200
        end



        if love.mouse.isDown("l") then
            protectCell(love.mouse.getX(), love.mouse.getY())
        end

        if love.mouse.isDown("r") then
            saveCell(love.mouse.getX(), love.mouse.getY())
        end

        if math.random() < 0.015 then
            expandVirus()
        end

    elseif currentState == "endgame" then

        if love.keyboard.isDown("1") then
            startGame()
        end

    elseif currentState == "intro" then

        if love.keyboard.isDown("2") then
            currentState = "game"
        end

    end
end

function love.draw()

    if currentState == "game" then

        for i=1,#map.matrix do
            for j=1,#map.matrix[i] do
                if map.matrix[i][j] == 0 then
                    love.graphics.draw(cellImage, (88 * j) - (88 + ( 44 * (i % 2) ) ), (100 * i) - (150 + 25 * (i - 1)) )
                elseif map.matrix[i][j] == 1 then
                    love.graphics.draw(infectedCellImage, (88 * j) - (88 + ( 44 * (i % 2) ) ), (100 * i) - (150 + 25 * (i - 1)) )
                else
                    love.graphics.draw(protectedCellImage, (88 * j) - (88 + ( 44 * (i % 2) ) ), (100 * i) - (150 + 25 * (i - 1)) )
                end
            end
        end

        love.graphics.print(player.playCounter, 20, 20)
        love.graphics.print(map.emptySpots, 1100, 20)

    elseif currentState == "intro" then

        love.graphics.print("Contain the virus. Don't let him keep growing!", (love.window.getWidth()/2) - 500, (love.window.getHeight()/2) - 150 )

        love.graphics.print("Left click to block the virus.", (love.window.getWidth()/2) - 350, (love.window.getHeight()/2) - 100 )
        love.graphics.print("You have limited moves to block him.", (love.window.getWidth()/2) - 350, (love.window.getHeight()/2) - 50 )
        love.graphics.print("Right click to save a cell.", (love.window.getWidth()/2) - 300, (love.window.getHeight()/2) )
        love.graphics.print("Be carefull you can save only two cells!!", (love.window.getWidth()/2) - 425, (love.window.getHeight()/2) +50 )

        love.graphics.print("Press '2' button to get started", (love.window.getWidth()/2) - 350, (love.window.getHeight()/2)  + 150)

    elseif currentState == "endgame" then

        if player.won then
            love.graphics.print("You got " .. map.emptySpots .. " points", (love.window.getWidth()/2) - 200, (love.window.getHeight()/2) - 50 )
            love.graphics.print("Better luck next time", (love.window.getWidth()/2) - 200, (love.window.getHeight()/2) )
            love.graphics.print("Press '1´ button to get back to menu", (love.window.getWidth()/2) - 325, (love.window.getHeight()/2) + 50 )
        else
            love.graphics.print("Well, you really fucked up this time!", (love.window.getWidth()/2) - 200, (love.window.getHeight()/2) - 50 )
            love.graphics.print("Press '1´ button to get out of this disaster", (love.window.getWidth()/2) - 300, (love.window.getHeight()/2) )
        end



    end


end

function initiateMap()
    local columns = math.floor(love.window.getHeight()/50) - 3
    local rows = math.floor(love.window.getWidth() /88) + 1

    map.emptySpots = columns * rows
    map.size = columns * rows

    for i=1, columns do
        local row = { }
        for i=1, rows do
            if math.random() < 0.025 then
                table.insert(row, 1)
                map.emptySpots = map.emptySpots - 1
            else
                table.insert(row, 0)
            end
        end
        table.insert(row, 0)
        table.insert(map.matrix, row)
    end
end

function expandVirus()
    local sound = love.audio.newSource("virus.wav", "static")
    for i=1,#map.matrix do
        for j=1,#map.matrix[i] do

            if map.matrix[i][j] == 1 then
                local random = math.abs(math.random(0, 4));
                if i - 1 > 0 and map.matrix[i-1][j] == 0 then

                    if random == 0 then
                        map.emptySpots = map.emptySpots - 1
                        map.matrix[i-1][j] = 1
                        map.virusContained = 500
                        sound:play()
                        return
                    end

                elseif i + 1 <= #map.matrix and map.matrix[i+1][j] == 0 then

                    if random == 1 then
                        map.emptySpots = map.emptySpots - 1
                        map.matrix[i+1][j] = 1
                        map.virusContained = 500
                        sound:play()
                        return
                    end

                elseif j - 1 > 0 and map.matrix[i][j-1] == 0  then

                    if random == 2 then
                        map.emptySpots = map.emptySpots - 1
                        map.matrix[i][j-1] = 1
                        map.virusContained = 500
                        sound:play()
                        return
                    end

                elseif j + 1 <= #map.matrix[i] and map.matrix[i][j+1] == 0 then

                    if random == 3 then
                        map.emptySpots = map.emptySpots - 1
                        map.matrix[i][j+1] = 1
                        map.virusContained = 500
                        sound:play()
                        return
                    end

                end

            end
        end
    end
end

function protectCell(mouseX, mouseY)
    local sound = love.audio.newSource("wall.wav", "static")
    for i=1,#map.matrix do
        for j=1,#map.matrix[i] do
            local minX = (88 * j) - (88 + ( 44 * (i % 2) ) )
            local maxX = (88 * j) - (88 + ( 44 * (i % 2) ) ) + cellImage:getWidth()
            local minY = (100 * i) - (150 + 25 * (i - 1)) + 10
            local maxY = (100 * i) - (150 + 25 * (i - 1)) + cellImage:getHeight() - 10

            if maxX > mouseX and mouseX > minX and maxY > mouseY and mouseY > minY then
                if map.matrix[i][j] == 0 and player.playCounter > 0 then
                    player.playCounter = player.playCounter - 1

                    map.emptySpots = map.emptySpots - 1
                    map.matrix[i][j] = 2
                    sound:play()
                end
            end

        end
    end

end

function saveCell(mouseX, mouseY)
    local sound = love.audio.newSource("saving.wav", "static")
    for i=1,#map.matrix do
        for j=1,#map.matrix[i] do
            local minX = (88 * j) - (88 + ( 44 * (i % 2) ) )
            local maxX = (88 * j) - (88 + ( 44 * (i % 2) ) ) + cellImage:getWidth()
            local minY = (100 * i) - (150 + 25 * (i - 1)) + 10
            local maxY = (100 * i) - (150 + 25 * (i - 1)) + cellImage:getHeight() - 10

            if maxX > mouseX and mouseX > minX and maxY > mouseY and mouseY > minY then
                if map.matrix[i][j] == 1 and player.savingCounter > 0 then
                    player.savingCounter = player.savingCounter - 1;
                    map.matrix[i][j] = 2
                    sound:play()
                end
            end

        end
    end

end
