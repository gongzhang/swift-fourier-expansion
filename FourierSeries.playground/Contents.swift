import UIKit

let domain = 0.0 ... 1.0

let f: Double -> Double = { x in
    switch x {
    case 0.0 ... 0.25: return -1
    case 0.25 ... 0.5: return 1
    case 0.5 ... 0.75: return -1
    default: return 1
    }
}

for x in domain.start.stride(to: domain.end, by: 0.01) {
    f(x)
}

var result = fourierExpand(f, domain: domain, seriesCount: 15)
result.simplify(tolerance: 0.05) // allow 5% error

result.expression

for x in domain.start.stride(to: domain.end, by: 0.01) {
    result.function(x)
}