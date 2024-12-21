//
//  GameScene.swift
//  PracticeSpriteKit
//
//  Created by 김기림 on 2022/09/28.
//

import SpriteKit
//import GameplayKit

class GameScene: SKScene {
    
    // 타이머용 컨테이너
    var meteorTimer = Timer()
    var meteorInterval: TimeInterval = 2.0
    
    override func didMove(to view: SKView) {
        
        // 배경용 별무리 붙이기
        guard let starfield = SKEmitterNode(fileNamed: Particle.starfield) else { return }
        starfield.position = CGPoint(x: size.width / 2, y: size.height)
        starfield.zPosition = Layer.starfield
        starfield.advanceSimulationTime(30) // 시뮬레이션 X초 지난 시점부터 시작
        self.addChild(starfield)
        
//        addMeteor()
        meteorTimer = setTimer(interval: meteorInterval, function: addMeteor)
    }
    
    func addMeteor() {
        let randomMeteor = arc4random_uniform(UInt32(3)) + 1 // arc4random_uniform 메서드를 쓰려면 unsigned Int 타입을 써야됨
        let randomXPos = CGFloat(arc4random_uniform(UInt32(self.size.width)))
        let randomSpeed = TimeInterval(arc4random_uniform(UInt32(5)) + 5)
        
        let texture = Atlas.gameobjects.textureNamed("meteor\(randomMeteor)")
        let meteor = SKSpriteNode(texture: texture)
        meteor.name = "meteor"
        meteor.position = CGPoint(x: randomXPos, y: self.size.height + meteor.size.height)
        meteor.zPosition = Layer.meteor
        
        self.addChild(meteor)
        
        let moveAct = SKAction.moveTo(y: -meteor.size.height, duration: randomSpeed) // y가 (-메테오크기)로 함으로써 화면 밖으로 나가도록함
        let rotateAct = SKAction.rotate(toAngle: CGFloat(Double.pi), duration: randomSpeed)
        let moveandRotateAct = SKAction.group([moveAct, rotateAct])
        let removeAct = SKAction.removeFromParent() // 단순히 메테오를 화면밖으로만 보이면 노드가 계속 쌓여 메모리가 늘고 렌더링 속도도 느려지게됨. 화면밖으로 나가면 그때그때 삭제하도록함
        
        meteor.run(SKAction.sequence([moveandRotateAct, removeAct])) // .sequence를 사용하여 순서대로 일어나게함. 메테오가 화면밖까지 움직임 -> 메테오 삭제
    }
    
    func setTimer(interval: TimeInterval, function: @escaping () -> Void) -> Timer {
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            function()
        }
        timer.tolerance = interval * 0.2 //20%정도 늦게 처리해도 괜찮다
        
        return timer
    }
}
