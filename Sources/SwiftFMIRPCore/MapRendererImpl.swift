class MapRendererImpl: MapRenderer {
    func render(map: Map) {
        for row in map.maze {
            self.renderMapRow(row: row)
        }

        renderMapLegend()
    }

    private func renderMapRow(row: [MapTile]) {
        var r = ""
        for tile in row {
            switch tile.type {
            case .chest:
                r += "📦"
            case .rock:
                r += "🗿"
            case .teleport:
                r += "💿"
            case .empty:
                r += "  "
            case .wall:
                r += "🧱"
            default:
                //empty
                r += " "
            }
        }

        print("\(r)")
    }

    private func renderMapLegend() {
         print("\n Map legend:")
         print("📦 - Treasure chest - it can bring you new armor or weapons)")
         print("🗿 - Rock - it will be broken in order to move to this field and will costs you one point energy")
         print("💿 - Teleport - it can transfers the player to a different tile")
         print("🧱 - Wall - the player can't move to this field")
    }
}
