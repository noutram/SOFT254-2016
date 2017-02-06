import UIKit
public typealias Point2D = (x: Double, y: Double)  //2D point in a Tuple


// Custom View for Plotting 2D Points
open class PlotView : UIView {
    
    var points : [String : Point2D] = [String : Point2D]()
    
    override open func draw(_ dirtyRect: CGRect) {

        super.draw(dirtyRect)
        
        //Move the origin to the center of the bounds box
        let Y1 = self.bounds.height
        let W2 = self.bounds.width * 0.5
        let H2 = self.bounds.height * 0.5
        let xc = self.bounds.origin.x + W2
        let yc = self.bounds.origin.y + H2
      
      
        //The next line does not work with inline image preview in Playgrounds (does work with the liveView)
        //self.translateOriginToPoint(CGPointMake(xc, yc))
      
        //The following two functions perform a translation from (0,0) origin to (W2,H2)
        func PVPointMake(_ x : CGFloat, _ y : CGFloat) -> CGPoint {
//           return CGPointMake(x + W2, y + H2)
            return CGPoint(x: x+W2, y: Y1-y - H2)
        }
        func PVRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
//           let r = CGRectMake(x + W2, y + H2, width, height)
           let r = CGRect(x: x + W2, y: Y1 - y - H2, width: width, height: height)
           return r
        }
      
        //The remaining code assumes an origin of (0,0)
      
        //Fill plot area
        UIColor.white.set()
        UIBezierPath(rect: self.bounds).fill()

        //Now draw major axis
      
        let vLine =  UIBezierPath()
        vLine.lineWidth = 2.0
        UIColor.black.setStroke()
      
        vLine.move(to: PVPointMake(-W2, 0))
        vLine.addLine(to: PVPointMake(W2, 0.0))
        vLine.stroke()
        vLine.fill()

        vLine.move(to: PVPointMake(0, -H2))
        vLine.addLine(to: PVPointMake(0, H2))
        vLine.stroke()
        vLine.fill()

        //
        // Plot points
        //
        func circlePathAtPoint(_ x : Double, _ y : Double) -> UIBezierPath {
            let p = PVRectMake(CGFloat(x-5.0), CGFloat(y-5.0), 10.0, 10.0)
            let c = UIBezierPath(ovalIn: p)
            return c
        }

        //Plot each point
        for (label, p) in points {
            let circle = circlePathAtPoint(p.x, p.y)
            //Set line and fill color
            UIColor.blue.setStroke()
            UIColor.yellow.setFill()
            //Draw
            circle.stroke()
            circle.fill()
            //Label
            label.draw(at: PVPointMake(CGFloat(p.x+10.0), CGFloat(p.y)), withAttributes: nil)
        }
      
    }
    
    //Constructor
    public init(frame frameRect: CGRect, points: [String : Point2D]) {
        super.init(frame: frameRect)
        self.points = points
    }
    //Required convenience method
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
