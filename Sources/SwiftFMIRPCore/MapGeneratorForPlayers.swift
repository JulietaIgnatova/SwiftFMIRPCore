struct MapGeneratorImpl: MapGenerator {
    func generate(players: [Player]) -> Map {
        return RandomizedMap(players: players)
    }
}

class MapTileImpl: MapTile {
    var type: MapTileType
    var state: String

    init(type: MapTileType) {
        self.type = type
        state = ""
    }
}

class MapTileForPlayerImpl: MapTile {
    var type: MapTileType
    var state: String

    init(type: MapTileType) {
        self.type = type
        state = ""
    }
}

struct Coordinates: Equatable {
    let x: Int
    let y: Int
}

class RandomizedMap: Map {
    var players: [Player]
    let multiplier = 3
    var maze: [[MapTile]]

    // var positionOfPlayers : [(Int: x, Int: y)]
    // var teleportPositions :  [(Int: x, Int: y)]

    required init(players: [Player]) {
        self.players = players
        var dimensionOfMap = players.count * multiplier
        maze = Array(repeating: Array(repeating: MapTileImpl(type: .empty), count: dimensionOfMap), count: dimensionOfMap)

        initializeMap(dimensionOfMap)
        // razpredeli igrachi vyrhu karatta
        var positionListOfPlayers: [(Int, Int)] = []

        for player in players {
            var i,j:Int
            repeat {
                i = Int.random(in:0..<dimensionOfMap)
                j = Int.random(in:0..<dimensionOfMap)
            } while (checkIfPositionOfPlayerIsRepeated(list: positionListOfPlayers, current: (i,j)))

            positionListOfPlayers.append((i,j))
            //self.playersPositions[player.name] = Position(x:i,y:j)
            player.currentPosition.0 = i
            player.currentPosition.1 = j

            maze[i][j].type = .player
            maze[i][j].state = player.hero.race
        }
    }

    private func checkIfPositionOfPlayerIsRepeated(list: [(Int,Int)], current: (Int, Int)) -> Bool{
        for el in list {
            if (current.0 == el.0 && current.1 == el.1){
                return true
            }
        }
        return false
    }

    func initializeMap(_ dimensionOfMap: Int) {
        let wallProbability = 0.05
        let chestProbability = 0.05
        let rockProbability = 0.05
        let teleportProbability = 0.05
        let emptyProbability = 0.8

        for i in 0 ..< dimensionOfMap {
            for j in 0 ..< dimensionOfMap {
                var tile: MapTileImpl
                var randomIndex = randomNumber(probabilities: [wallProbability, chestProbability, rockProbability, teleportProbability, emptyProbability])
                switch randomIndex {
                case 0: tile = MapTileImpl(type: .wall)
                case 1: tile = MapTileImpl(type: .chest)
                case 2: tile = MapTileImpl(type: .rock)
                case 3: tile = MapTileImpl(type: .teleport)
                default: tile = MapTileImpl(type: .empty)
                }
                maze[i][j] = tile
            }
        }
    }

    // func isValidPosition(x:Int, y:Int,map: Map)-> Bool {
    //     return x>=0 && x < map.maze.count && y>=0 && y < map.maze.count && maze[x][y].type != .wall
    // }

    func randomNumber(probabilities: [Double]) -> Int {
        // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
        let sum = probabilities.reduce(0, +)
        // Random number in the range 0.0 <= rnd < sum :
        let rnd = Double.random(in: 0.0 ..< sum)
        // Find the first interval of accumulated probabilities into which `rnd` falls:
        var accum = 0.0
        for (i, p) in probabilities.enumerated() {
            accum += p
            if rnd < accum {
                return i
            }
        }
        // This point might be reached due to floating point inaccuracies:
        return (probabilities.count - 1)
    }

    func availableMoves(player: Player) -> [PlayerMove] {
        var availableMoves: [PlayerMove] = [PlayerMove]()

        if player.currentPosition.0 - 1 >= 0, maze[player.currentPosition.0 - 1][player.currentPosition.1].type != .wall {
            availableMoves.append(StandartPlayerMove(direction: .up))
        }
        if player.currentPosition.0 + 1 < maze.count, maze[player.currentPosition.0 + 1][player.currentPosition.1].type != .wall {
            availableMoves.append(StandartPlayerMove(direction: .down))
        }
        if player.currentPosition.1 + 1 < maze[0].count, maze[player.currentPosition.0][player.currentPosition.1 + 1].type != .wall {
            availableMoves.append(StandartPlayerMove(direction: .right))
        }
        if player.currentPosition.1 - 1 >= 0, maze[player.currentPosition.0][player.currentPosition.1 - 1].type != .wall {
            availableMoves.append(StandartPlayerMove(direction: .left))
        }

        return availableMoves
    }

    func move(player: inout Player, move: PlayerMove) {
        // reduce the energy with 1
        player.reduceEnergy()

        var coordX = player.currentPosition.0
        var coordY = player.currentPosition.1

        maze[coordX][coordY].type = .empty
        maze[coordX][coordY].state = "empty"

        if move.direction == .up {
            coordX = coordX - 1
            maze[coordX][coordY].type = .player
            maze[coordX][coordY].state = player.hero.race

        } else if move.direction == .down {
            coordX = coordX + 1
            maze[coordX][coordY].type = .player
            maze[coordX][coordY].state = player.hero.race

        } else if move.direction == .right {
            coordY = coordY + 1
            maze[coordX][coordY].type = .player
            maze[coordX][coordY].state = player.hero.race

        } else if move.direction == .left {
            coordY = coordY - 1
            maze[coordX][coordY].type = .player
            maze[coordX][coordY].state = player.hero.race
        }
        player.currentPosition.0 = coordX
        player.currentPosition.1 = coordY

        // TODO:
        // fightIfTheTileIsOccupied()
    }
}
