func with<T>(_ value: T, _ update: (inout T) -> Void) -> T {
  var copy = value
  update(&copy)
  return copy
}

