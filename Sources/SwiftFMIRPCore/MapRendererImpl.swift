class MapRendererImpl: MapRenderer {
    func render(map: Map) {
        for i in 1 ... map.maze.count {
            print(" --", terminator: "")
        }
        print()
        for row in map.maze {
            renderMapRow(row: row)
        }

        renderMapLegend()
    }

    private func renderMapRow(row: [MapTile]) {
        var counter = 0
        var r = ""
        for tile in row {
            switch tile.type {
            case .chest:
                r += "|📦"
            case .rock:
                r += "|🗿"
            case .teleport:
                r += "|💿"
            case .empty:
                r += "|  "
            case .player:
                r += printIfHero(tile: tile)
            case .wall:
                r += "|🧱 "
            default:
                r += "|  "
            }
        }

        print("\(r)|")
        for i in 1 ... row.count {
            print(" --", terminator: "")
        }
        print()
    }

    private func printIfHero(tile: MapTile) -> String {
        switch tile.state {
        case "Robots":
            return "|🤖"
        case "Unicorns": return "|🦄"
        case "Eagles": return "|🦅"
        case "Fairies": return "|🧚🏻"
        case "no player": return "|X "
        default: return "|  "
        }
    }

    private func renderMapLegend() {
        print("\n Map legend:")
        print("📦 - Treasure chest - It can bring you new armor or weapon")
        print("🗿 - Rock - It will be broken in order to move to this field and will costs you one point energy")
        print("💿 - Teleport - It can transfers the player to a different tile")
        print("🧱 - Wall - The player can't move to this field")
        print("Players in the game are the Robot: 🤖, the Unicorn: 🦄, the Eagle: 🦅 and the Fairy: 🧚🏻")
    }
}
