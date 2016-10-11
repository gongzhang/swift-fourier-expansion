import UIKit

// 1. define any function and its domain by yourself:

//let domain = 0.0 ... 1.0
//
//let f: Double -> Double = { x in
//    switch x {
//    case 0.0 ... 0.25: return -1
//    case 0.25 ... 0.5: return 1
//    case 0.5 ... 0.75: return -1
//    default: return 1
//    }
//}

// or use scatter diagram...

var digram = ScatterDiagram()
digram.dataPoints[0.0] = 0.5
digram.dataPoints[0.25] = 1.0
digram.dataPoints[0.5] = -0.5
digram.dataPoints[0.75] = 2.0
digram.dataPoints[1.0] = 0.5

let domain = digram.domain
let f = digram.lineTogether()

// draw the graph

for x in stride(from: domain.lowerBound, to: domain.upperBound, by: 0.01) {
    f(x)
}

// 2. do Fourier series expansion on that function

var result = fourierExpand(f, domain: domain, seriesCount: 15)
result.simplify(tolerance: 0.01) // allow 1% error

result.expression

for x in stride(from: domain.lowerBound, to: domain.upperBound, by: 0.01) {
    result.function(x)
}
