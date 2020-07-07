protocol Weapon {
    var attack: Int { get }
    var defence: Int { get }
}

struct Axe: Weapon {
    var attack: Int = 5
    var defence: Int = 3
}

struct MagicWand: Weapon {
    var attack: Int = 5
    var defence: Int = 2
}

struct Sword: Weapon {
    var attack: Int = 6
    var defence: Int = 4
}

struct Wings: Weapon {
    var attack: Int = 3
    var defence: Int = 5
}
