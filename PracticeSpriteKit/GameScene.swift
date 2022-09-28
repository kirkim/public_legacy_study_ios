//
//  GameScene.swift
//  PracticeSpriteKit
//
//  Created by 김기림 on 2022/09/28.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        // 배경용 별무리 붙이기
        guard let starfield = SKEmitterNode(fileNamed: Particle.starfield) else { return }
        starfield.position = CGPoint(x: size.width / 2, y: size.height)
        starfield.zPosition = Layer.starfield
        starfield.advanceSimulationTime(30) // 시뮬레이션 X초 지난 시점부터 시작
        self.addChild(starfield)
    }
}
