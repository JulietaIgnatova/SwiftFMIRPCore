struct HeroRobot: Hero {
    var race: String = HeroRace.Robots.rawValue

    var energy: Int = 5
    var lifePoitns: Int = 7

    var weapon: Weapon? = Axe()
    var armor: Armor? = GoldArmor()
}

struct HeroUnicorn: Hero {
    var race: String = HeroRace.Unicorns.rawValue

    var energy: Int = 8
    var lifePoitns: Int = 10

    var weapon: Weapon? = Wings()
    var armor: Armor? = NoArmor()
}

struct HeroFairy: Hero {
    var race: String = HeroRace.Fairies.rawValue

    var energy: Int = 4
    var lifePoitns: Int = 6

    var weapon: Weapon? = MagicWand()
    var armor: Armor? = SilverArmor()
}

struct HeroЕagle: Hero {
    var race: String = HeroRace.Eagles.rawValue

    var energy: Int = 10
    var lifePoitns: Int = 9

    var weapon: Weapon? = Sword()
    var armor: Armor? = GoldArmor()
}

enum HeroRace: String {
    case Robots
    case Unicorns
    case Eagles
    case Fairies
}
