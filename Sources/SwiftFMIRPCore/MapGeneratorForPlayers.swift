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

class RandomizedMap: Map {
    
    required init(players : [Player]) {
        self.players = players
        var dimensionOfMap = players.count * multiplier
        self.maze = Array(repeating: Array(repeating: MapTileImpl(type: .empty), count: dimensionOfMap), count: dimensionOfMap)

        initializeMap(dimensionOfMap)
    }
    var players: [Player]
    let multiplier = 3
    var maze: [[MapTile]]


    func initializeMap(_ dimensionOfMap : Int) {
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
                self.maze[i][j] = tile
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

    func availableMoves(player _: Player) -> [PlayerMove] {
        return []
    }

    func move(player _: Player, move _: PlayerMove) {
        // ТОДО: редуцирай енергията на героя на играча с 1
    }
}



