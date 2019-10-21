//
//  EndCallSpec.swift
//  LibExampleTests
//
//  Created by Manuel on 14/10/2019.
//  Copyright © 2019 Harold. All rights reserved.
//

import Quick
import Nimble
@testable import LibExample

class EndCallSpec: QuickSpec {
    override func spec() {
        describe("the EndCall UseCase") {
            var sut: EndCall!

            var receivedCall: Call!
            var depend: Dependencies!

            beforeEach {
                depend = Dependencies(callStarter: Mock.CallStarter())
                sut = EndCall(dependencies:depend) {
                    switch $0 {
                    case .callDidStop(let call):
                        receivedCall = call
                    }
                }
            }
            
            afterEach {
                depend = nil
                receivedCall = nil
                sut = nil
            }
            
            it("ends a call"){
                sut.handle(request: .stop(Call(handle: "12345")))
                
                expect(receivedCall).toNot(beNil())
            }
        }
    }
}
