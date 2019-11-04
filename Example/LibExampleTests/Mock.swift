//
//  Mock.swift
//  LibExampleTests
//
//  Created by Manuel on 15/10/2019.
//  Copyright © 2019 Harold. All rights reserved.
//
import Foundation
@testable import LibExample

class Mock {
    class MessageHandler: MessageHandling, MessageSubscriber {
        
        init(callBack: @escaping (Message) -> ()) {
            self.callBack = callBack
        }
        
        let callBack: (Message) -> ()
        
        func handle(msg: Message) { callBack(msg) }
    }
    
    struct CallStarter: CallStarting {
        init() {}
        
        var deferResponse: ((Bool) -> DispatchTimeInterval) = {
            switch $0 {
            case  true: return .milliseconds(10)
            case false: return .milliseconds(7)
            }
        }

        var callback: ((Bool, Call) -> Void)?
        func start(call: Call) {
            checkHandle(call.handle)
                ? delay(by: deferResponse( true)) { self.callback?( true, call)}
                : delay(by: deferResponse(false)) { self.callback?(false, call)}
        }
    }
    
    struct CallManager: CallManaging {
        
        init(shouldSucceed: Bool) {
            self.shouldSucceed = shouldSucceed
        }
        let shouldSucceed: Bool
        func startCall(toNumber: String, for: VSLAccount, completion: @escaping ((VSLCall?, Error?) -> ())) {
            shouldSucceed
                ? completion(VSLCall(inboundCallWithCallId: 9, account: VSLAccount(callManager: VSLCallManager())), nil)
                : completion(nil, NSError())
        }
    }
    
    class StatePersister: StatePersisting  {
        
        var shouldFailLoading = false
        var shouldFailPersisting = false

        private var appState: AppState! = AppState(transportMode: .udp)
        func persist(state: AppState) throws {
            if shouldFailPersisting {
                throw NSError(domain: "failed loading", code: 501, userInfo: nil)
            }
            appState = state
        }
        
        func loadState() throws -> AppState? {
            
            if shouldFailLoading {
                throw NSError(domain: "failed loading", code: 501, userInfo: nil)
            }
            
            return appState
        }
    }
}
