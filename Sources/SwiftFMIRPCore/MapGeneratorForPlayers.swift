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

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

class RandomizedMap: Map {
    var players: [Player]
    let multiplier = 3
    var maze: [[MapTile]]

    var positionOfPlayer: [String: Coordinates] = [:]

    required init(players: [Player]) {
        self.players = players
        var dimensionOfMap = players.count * multiplier
        maze = Array(repeating: Array(repeating: MapTileImpl(type: .empty), count: dimensionOfMap), count: dimensionOfMap)

        // initialize map
        initializeMap(dimensionOfMap)

        // distribution of players on the map
        var positionListOfPlayers: [(Int, Int)] = []

        for player in players {
            var i, j: Int
            repeat {
                i = Int.random(in: 0 ..< dimensionOfMap)
                j = Int.random(in: 0 ..< dimensionOfMap)
            } while checkIfPositionOfPlayerIsRepeated(list: positionListOfPlayers, current: (i, j))

            positionListOfPlayers.append((i, j))

            positionOfPlayer[player.name] = Coordinates(x: i, y: j)

            maze[i][j].type = .player
            maze[i][j].state = player.hero.race
        }
        print(positionOfPlayer)
    }

    private func checkIfPositionOfPlayerIsRepeated(list: [(Int, Int)], current: (Int, Int)) -> Bool {
        for el in list {
            if current.0 == el.0, current.1 == el.1 {
                return true
            }
        }
        return false
    }

    private func initializeMap(_ dimensionOfMap: Int) {
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
        let xCoord = positionOfPlayer[player.name]?.x ?? 0
        let yCoord = positionOfPlayer[player.name]?.y ?? 0

        if xCoord - 1 >= 0, maze[xCoord - 1][yCoord].type != .wall {
            availableMoves.append(StandartPlayerMove(direction: .up))
        }
        if xCoord + 1 < maze.count, maze[xCoord + 1][yCoord].type != .wall {
            availableMoves.append(StandartPlayerMove(direction: .down))
        }
        if yCoord + 1 < maze[0].count, maze[xCoord][yCoord + 1].type != .wall {
            availableMoves.append(StandartPlayerMove(direction: .right))
        }
        if yCoord - 1 >= 0, maze[xCoord][yCoord - 1].type != .wall {
            availableMoves.append(StandartPlayerMove(direction: .left))
        }

        return availableMoves
    }

    func move(player: inout Player, move: PlayerMove) {
        // reduce the energy with 1
        player.reduceEnergy()

        var coordX = positionOfPlayer[player.name]?.x ?? 0
        var coordY = positionOfPlayer[player.name]?.y ?? 0

        maze[coordX][coordY].type = .empty
        maze[coordX][coordY].state = "empty"

        if move.direction == .up {
            coordX = coordX - 1
        } else if move.direction == .down {
            coordX = coordX + 1
        } else if move.direction == .right {
            coordY = coordY + 1
        } else if move.direction == .left {
            coordY = coordY - 1
        }

        checkFuturePosition(coordX: &coordX, coordY: &coordY, player: &player)

        maze[coordX][coordY].type = .player
        maze[coordX][coordY].state = player.hero.race
        positionOfPlayer[player.name] = Coordinates(x: coordX, y: coordY)
    }

    private func checkFuturePosition(coordX: inout Int, coordY: inout Int, player: inout Player) {
        if maze[coordX][coordY].state != "empty", maze[coordX][coordY].type == MapTileType.player {
            print("You are going to fight with \(maze[coordX][coordY].state)")
        } else if maze[coordX][coordY].type == MapTileType.rock {
            print("Opss..You crashed into a rock! This will costs you one point energy!")
            print("Your energy was \(player.hero.energy)")
            player.reduceEnergy()
            print("Now your energy is \(player.hero.energy)")
        } else if maze[coordX][coordY].type == MapTileType.teleport {
            var dimensionOfMap = players.count * multiplier
            coordX = Int.random(in: 0 ..< dimensionOfMap)
            coordY = Int.random(in: 0 ..< dimensionOfMap)
            print("You have just teleported to -> \(coordX):\(coordY)!")

        } else if maze[coordX][coordY].type == MapTileType.chest {
            print("You just cаme across a treasure!")
            // TODO: giveTreasure()
        }
    }
}
