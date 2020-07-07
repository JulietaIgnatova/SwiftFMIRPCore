struct SilverArmor: Armor {
    var attack: Int = 2
    var defence: Int = 3
}

struct GoldArmor: Armor {
    var attack: Int = 3
    var defence: Int = 5
}

// func ==(left: Armor, right: Armor) -> Bool {
//     guard type(of: left) == type(of: right) else { return false }
//     return left.attack == right.attack && left.defence == right.defence
// }
