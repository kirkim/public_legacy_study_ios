//
//  Constants.swift
//  PracticeSpriteKit
//
//  Created by 김기림 on 2022/09/28.
//

import SpriteKit

enum Particle {
    static let starfield = "starfield"
}

enum Layer {
    static let starfield: CGFloat = 0
    static let meteor: CGFloat = 1
}

enum Atlas {
    static let gameobjects = SKTextureAtlas(named: "Gameobjects")
}
