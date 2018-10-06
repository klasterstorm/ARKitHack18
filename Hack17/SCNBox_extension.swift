//import UIKit
import SceneKit
//import ARKit

extension SCNNode {
    
    /// Doubles The Size Of The SCNNode & Then Returns It To Its Original Size
    func growAndShrink() {
        
        //1. Create An SCNAction Which Will Double The Size Of Our Node
        let growAction = SCNAction.scale(by: 2, duration: 5)
        
        //2. Create Another SCNAction Wjich Will Revert Our Node Back To It's Original Size
        let shrinkAction = SCNAction.scale(by: 0.5, duration: 5)
        
        //3. Create An Animation Sequence Which Will Store Our Actions
        let animationSequence = SCNAction.sequence([growAction, shrinkAction])
        
        //4. Run The Sequence
//        self.runAction(animationSequence)
        
    }
    
}
