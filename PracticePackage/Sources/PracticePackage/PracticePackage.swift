public struct PracticePackage {
    public private(set) var text = "Hello, World!"

    public init() {
    }
    
    // 문자열을 출력해주는 메서드ㄴ
    // "Hello! I'm in Practice Package."가 출력
    public func printHello() {
        print("Hello! I'm in Practice Package.")
    }
}
