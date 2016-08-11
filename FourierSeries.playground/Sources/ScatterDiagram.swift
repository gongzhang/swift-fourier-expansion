import Foundation

public struct ScatterDiagram {
    
    public var dataPoints: [Double: Double] = [:]
    
    public init() {}
    
    public var domain: ClosedInterval<Double> {
        assert(dataPoints.count > 1, "the diagram must contains two points at least.")
        let min_x = dataPoints.keys.minElement()!
        let max_x = dataPoints.keys.maxElement()!
        return min_x ... max_x
    }
    
    public func lineTogether() -> Double -> Double {
        assert(dataPoints.count > 1, "the diagram must contains two points at least.")
        let sorted = dataPoints.sort { $0.0 < $1.0 }
        let domain = sorted.first!.0 ... sorted.last!.0
        return { x in
            assert(domain.contains(x), "x is out of domain")
            for (i, (xi, yi)) in sorted.enumerate() {
                if x == xi {
                    return yi
                } else {
                    let (xj, yj) = sorted[i + 1]
                    if x < xj {
                        let p = (x - xi) / (xj - xi)
                        return yi + p * (yj - yi)
                    }
                }
            }
            fatalError()
        }
    }
    
}
