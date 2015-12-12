
function startGame()
    -- basic objects
    map = {
        matrix = { },
        emptySpots = 0,
        size = 0
    }

    player = {
        availablePlays = 0,
        timer = 0,
        savingCounter = 2
    }

    initiateMap()

end

function love.load()
    startGame()

    cellImage = love.graphics.newImage("cell.png")
    infectedCellImage = love.graphics.newImage("infected-cell.png")
    protectedCellImage = love.graphics.newImage("protected-cell.png")

end

function love.update(dt)

    if love.mouse.isDown("l") then
        selectProtectCell(love.mouse.getX(), love.mouse.getY())
    end

    if love.mouse.isDown("r") then
        selectSaveCell(love.mouse.getX(), love.mouse.getY())
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
    local columns = love.window.getHeight()/50
    local rows = math.ceil(love.window.getWidth() /88)
    for i=1, columns do
        local row = { }
        for i=1, rows do
            table.insert(row, 0)
        end
        table.insert(row, 0)
        table.insert(map.matrix, row)
    end
end

function selectProtectCell(mouseX, mouseY)
    for i=1,#map.matrix do
        for j=1,#map.matrix[i] do
            local minX = (88 * j) - (88 + ( 44 * (i % 2) ) )
            local maxX = (88 * j) - (88 + ( 44 * (i % 2) ) ) + cellImage:getWidth()
            local minY = (100 * i) - (150 + 25 * (i - 1)) + 10
            local maxY = (100 * i) - (150 + 25 * (i - 1)) + cellImage:getHeight() - 10

            if maxX > mouseX and mouseX > minX and maxY > mouseY and mouseY > minY then
                map.matrix[i][j] = 2
            end

        end
    end

end

function selectSaveCell(mouseX, mouseY)
    for i=1,#map.matrix do
        for j=1,#map.matrix[i] do
            local minX = (88 * j) - (88 + ( 44 * (i % 2) ) )
            local maxX = (88 * j) - (88 + ( 44 * (i % 2) ) ) + cellImage:getWidth()
            local minY = (100 * i) - (150 + 25 * (i - 1)) + 10
            local maxY = (100 * i) - (150 + 25 * (i - 1)) + cellImage:getHeight() - 10

            if maxX > mouseX and mouseX > minX and maxY > mouseY and mouseY > minY then
                if map.matrix[i][j] == 1 then
                    player.savingCounter = player.savingCounter - 1;
                    map.matrix[i][j] = 2
                end
            end

        end
    end

end
