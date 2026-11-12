import Testing
@testable import DSKit

@Suite("Stepper")
struct DSStepperTests {
    @Test func stepsUpAndDown() {
        #expect(DSStepperLogic.stepped(3, by: 1, in: 1...12, increasing: true) == 4)
        #expect(DSStepperLogic.stepped(3, by: 1, in: 1...12, increasing: false) == 2)
        #expect(DSStepperLogic.stepped(2.5, by: 0.25, in: 0.25...15, increasing: true) == 2.75)
    }

    @Test func staysAtTheLimits() {
        #expect(DSStepperLogic.stepped(12, by: 1, in: 1...12, increasing: true) == 12)
        #expect(DSStepperLogic.stepped(1, by: 1, in: 1...12, increasing: false) == 1)
    }

    @Test func aStepPastTheLimitLandsOnIt() {
        #expect(DSStepperLogic.stepped(11, by: 5, in: 1...12, increasing: true) == 12)
        #expect(DSStepperLogic.stepped(0.3, by: 0.25, in: 0.25...15, increasing: false) == 0.25)
    }

    @Test func aDecimalStepLeavesNoBinaryResidue() {
        #expect(88.4 - 0.1 != 88.3)
        #expect(DSStepperLogic.stepped(88.4, by: 0.1, in: 20...300, increasing: false) == 88.3)
        #expect(DSStepperLogic.stepped(0.1, by: 0.2, in: 0...10, increasing: true) == 0.3)
        #expect(DSStepperLogic.stepped(Float(0.7), by: 0.1, in: 0...10, increasing: true) == Float(0.8))
    }

    @Test func integersAreUntouched() {
        #expect(DSStepperLogic.stepped(Int.max - 1, by: 1, in: 0...Int.max, increasing: true) == Int.max)
    }
}
