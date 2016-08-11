# Fourier Series Expansion in Swift Playground

[https://en.wikipedia.org/wiki/Fourier_series](https://en.wikipedia.org/wiki/Fourier_series)

For example, there is an input function `f` that is defined on domain `0` to `1`:

```swift
let domain = 0.0 ... 1.0

let f: Double -> Double = { x in
    switch x {
    case 0.0 ... 0.25: return -1
    case 0.25 ... 0.5: return 1
    case 0.5 ... 0.75: return -1
    default: return 1
    }
}
```

The graph of function `f` likes this:

![](https://github.com/gongzhang/swift-fourier-expansion/blob/master/Images/1.png)

Then you can expand function `f` into Fourier series:

```swift
var result = fourierExpand(f, domain: domain, seriesCount: 15)
result.simplify(tolerance: 0.05) // allow 5% error
```

To see the result, print `result.expression`:

![](https://github.com/gongzhang/swift-fourier-expansion/blob/master/Images/2.png)

And draw the graph of expanded `f`:

```swift
for x in domain.start.stride(to: domain.end, by: 0.01) {
    result.function(x)
}
```

![](https://github.com/gongzhang/swift-fourier-expansion/blob/master/Images/3.png)
