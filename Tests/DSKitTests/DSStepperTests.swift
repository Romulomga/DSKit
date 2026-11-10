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
}
