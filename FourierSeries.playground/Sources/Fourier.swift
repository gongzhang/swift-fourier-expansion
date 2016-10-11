import Foundation

public let 𝜋 = M_PI

public struct FourierExpansion {
    
    public internal(set) var coefficients: FourierCoefficients
    
    public internal(set) var domain: ClosedRange<Double>
    
    public func function(_ x: Double) -> Double {
        return coefficients.apply((x - domain.lowerBound) / (domain.upperBound - domain.lowerBound) * 2 * 𝜋 - 𝜋)
    }
    
    public mutating func simplify(tolerance t: Double) {
        coefficients.simplify(tolerance: t)
    }
    
    public var expression: String {
        let a = coefficients.a
        let b = coefficients.b
        let half_a0 = a[0] / 2
        var str = half_a0 == 0 ? "f(t) = " : "f(t) = \(half_a0)"
        for i in 1 ..< a.count {
            if a[i] > 0 {
                str += " + \(a[i]) * cos\(i)t"
            } else if a[i] < 0 {
                str += " - \(-a[i]) * cos\(i)t"
            }
            
            if b[i] > 0 {
                str += " + \(b[i]) * sin\(i)t"
            } else if b[i] < 0 {
                str += " - \(-b[i]) * sin\(i)t"
            }
        }
        
        if domain.lowerBound == 0.0 {
            str += "\nwhere t = (\(2 / (domain.upperBound)) * x - 1) * 𝜋"
        } else {
            str += "\nwhere t = (\(2 / (domain.upperBound - domain.lowerBound)) * (x - \(domain.lowerBound)) - 1) * 𝜋"
        }
        
        return str
    }
    
}

public struct FourierCoefficients {
    
    public internal(set) var a: [Double] = []
    public internal(set) var b: [Double] = []
    
    public func apply(_ x: Double) -> Double {
        var sum = a[0] / 2
        for i in 1 ..< a.count {
            if a[i] != 0 {
                sum += a[i] * cos(x * Double(i))
            }
            if b[i] != 0 {
                sum += b[i] * sin(x * Double(i))
            }
        }
        return sum
    }
    
    public mutating func simplify(tolerance t: Double) {
        let maxCoef = max(
            a.map(abs).max()!,
            b.map(abs).max()!
        )
        
        let digits = Int(ceil(log10(1 / maxCoef / t)))
        func rnd(_ x: Double) -> Double {
            guard digits > 0 else { return x }
            let m = pow(10, Double(digits))
            return round(x * m) / m
        }
        
        for (i, v) in a.enumerated() {
            if abs(v) / maxCoef < t {
                a[i] = 0.0
            } else {
                a[i] = rnd(v)
            }
        }
        for (i, v) in b.enumerated() {
            if abs(v) / maxCoef < t {
                b[i] = 0.0
            } else {
                b[i] = rnd(v)
            }
        }
    }
    
}

private func an(_ f: (Double) -> Double, _ n: Int, _ step: Double) -> Double {
    var sum = 0.0
    for x in stride(from: (-𝜋), to: 𝜋, by: step) {
        sum += step * f(x) * cos(Double(n) * x)
    }
    return sum / 𝜋
}

private func bn(_ f: (Double) -> Double, _ n: Int, _ step: Double) -> Double {
    var sum = 0.0
    for x in stride(from: (-𝜋), to: 𝜋, by: step) {
        sum += step * f(x) * sin(Double(n) * x)
    }
    return sum / 𝜋
}

private func fourierExpand(_ f: (Double) -> Double, seriesCount count: Int, integralStep step: Double) -> FourierCoefficients {
    var a = [Double](), b = [Double]()
    a.append(an(f, 0, step))
    a.append(contentsOf: (1...count).map { an(f, $0, step) })
    b.append(0.0)
    b.append(contentsOf: (1...count).map { bn(f, $0, step) })
    return FourierCoefficients(a: a, b: b)
}

public func fourierExpand
    (_ f: @escaping (Double) -> Double, domain: ClosedRange<Double>, seriesCount count: Int, integralStep step: Double? = nil) -> FourierExpansion {
    assert(count > 0, "series count must be positive")
    let range = domain.upperBound - domain.lowerBound
    let norm_f: (Double) -> Double = {
        f(($0 + 𝜋) / (2 * 𝜋) * range + domain.lowerBound)
    }
    let coeff = fourierExpand(norm_f, seriesCount: count, integralStep: step == nil ? range / 10 : step!)
    return FourierExpansion(coefficients: coeff, domain: domain.lowerBound ... domain.upperBound)
}
