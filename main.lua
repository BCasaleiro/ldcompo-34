
function startGame()
    -- basic objects
    map = {
        matrix = { },
        emptySpots = 0,
        size = 0
    }

    player = {
        savingCounter = 2
    }

    initiateMap()

end

function love.load()
    startGame()

    cellImage = love.graphics.newImage("cell.png")
    infectedCellImage = love.graphics.newImage("infected-cell.png")
    protectedCellImage = love.graphics.newImage("protected-cell.png")

    coolFont = love.graphics.newFont("ProggySquareTT.ttf", 50)
    love.graphics.setFont(coolFont)

end

function love.update(dt)
    local won = hasWon()

    if map.emptySpots <= 0 then
        print("you fucked up")
    elseif won then
        print("you won a fucking easy game")
    end

    if love.mouse.isDown("l") then
        protectCell(love.mouse.getX(), love.mouse.getY())
    end

    if love.mouse.isDown("r") then
        saveCell(love.mouse.getX(), love.mouse.getY())
    end

    if math.random() < 0.02 then
        expandVirus()
    end

end

function love.draw()

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
                        sound:play()
                        return
                    end

                elseif i + 1 <= #map.matrix and map.matrix[i+1][j] == 0 then

                    if random == 1 then
                        map.emptySpots = map.emptySpots - 1
                        map.matrix[i+1][j] = 1
                        sound:play()
                        return
                    end

                elseif j - 1 > 0 and map.matrix[i][j-1] == 0  then

                    if random == 2 then
                        map.emptySpots = map.emptySpots - 1
                        map.matrix[i][j-1] = 1
                        sound:play()
                        return
                    end

                elseif j + 1 <= #map.matrix[i] and map.matrix[i][j+1] == 0 then

                    if random == 3 then
                        map.emptySpots = map.emptySpots - 1
                        map.matrix[i][j+1] = 1
                        sound:play()
                        return
                    end

                end

            end
        end
    end
end

function hasWon()

    for i=1,#map.matrix do
        for j=1,#map.matrix[i] do

            if  (i - 1 > 0 and map.matrix[i-1][j] == 0) or
                (i + 1 <= #map.matrix and map.matrix[i+1][j] == 0) or
                (j - 1 > 0 and map.matrix[i][j-1] == 0) or
                (j + 1 <= #map.matrix[i] and map.matrix[i][j+1] == 0)
            then
                return false
            end

        end
    end

    return true
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
                if map.matrix[i][j] == 0 then
                    map.emptySpots = map.emptySpots - 1
                    map.matrix[i][j] = 2
                    sound:play()
                end
            end

        end
    end

end

function saveCell(mouseX, mouseY)
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
                end
            end

        end
    end

end
