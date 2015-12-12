
function startGame()
    -- basic objects
    map = {
        matrix = { },
        emptySpots = 0
    }

    player = {
        availablePlays = 0,
        timer = 0
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

end

function love.draw()

    for i=1,#map.matrix do
        for j=1,#map.matrix[i] do
            if i % 2 == 0 then
                love.graphics.draw(cellImage, (88 * j) - 88, (100 * i) - (150 + 25 * (i - 1)) )
            else
                love.graphics.draw(cellImage, (88 * j) - 132, (100 * i) - (150 + 25 * (i - 1)) )
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
