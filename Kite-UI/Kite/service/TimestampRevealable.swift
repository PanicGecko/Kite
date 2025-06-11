import CoreFoundation
protocol TimestampRevealable: AnyObject {
    
  // amount to slide left (0…max)
  func revealTimestamp(by offset: CGFloat)
  // spring-animate back to zero
  func resetTimestamp()
}

