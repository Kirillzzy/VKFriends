import Foundation
#if os(iOS)
    import UIKit
#endif
#if os(OSX)
    import Cocoa
#endif


///Delegate to the SwiftyVK
public protocol VKDelegate {
    /**Called when SwiftyVK need autorization permissions
     - returns: permissions as VK.Scope type*/
    func vkWillAuthorize() -> [VK.Scope]
    ///Called when SwiftyVK did authorize and receive token
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>)
    ///Called when SwiftyVK did unauthorize and remove token
    func vkDidUnauthorize()
    ///Called when SwiftyVK did failed autorization
    func vkAutorizationFailedWith(error: VK.Error)
    /**Called when SwiftyVK need know where a token is located
     - returns: Path to save/read token or nil if should save token to UserDefaults*/
    func vkShouldUseTokenPath() -> String?
    #if os(iOS)
    /**Called when need to display a view from SwiftyVK
     - returns: UIViewController that should present autorization view controller*/
    func vkWillPresentView() -> UIViewController
    #elseif os(OSX)
    /**Called when need to display a view from SwiftyVK
     - returns: Parent window for modal view or nil if view should present in separate window.*/
    func vkWillPresentView() -> NSWindow?
    #endif
}
//
//
//
//
//
//
//
//
//
//
/**
 Library to connect to the social network "VKontakte"
 * To use, you must call configure() specifying the application ID and a delegate
 * For user authentication you must call authorize()
 */
public struct VK {
    internal static var delegate : VKDelegate? {
        set{delegateInstance = newValue}
        get{assert(VK.state != .unknown, "At first initialize VK with configure() method")
            return delegateInstance}
    }
    public private(set) static var appID : String? {
        set{appIDInstance = newValue}
        get{assert(VK.state != .unknown, "At first initialize VK with configure() method")
            return appIDInstance}
    }
    private static var delegateInstance : VKDelegate?
    private static var appIDInstance : String?
    
    

    /**
     Initialize library with identifier and application delegate
     - parameter appID: application ID
     - parameter delegate: Delegate corresponding protocol VKDelegate
     */
    public static func configure(appID id: String, delegate owner: VKDelegate) {
        delegate = owner
        appID    = id
        _ = Token.get()
        VK.Log.put("Global", "SwiftyVK INIT")
    }
    
    
    
    fileprivate static var configured : Bool {
        return VK.delegateInstance != nil && VK.appIDInstance != nil
    }
    

    
    /**
     Getting authenticate token.
     * If the token is already stored in the file, then the authentication takes place in the background
     * If not, shows a pop-up notification with authorization request
     */
    public static func logIn() {
        Authorizator.authorize(nil);
    }
    
    
    
    #if os(iOS)
    @available(iOS 9.0, *)
    public static func process(url: URL, options: [AnyHashable: Any]) {
    Authorizator.recieveTokenURL(url: url, fromApp: options[UIApplicationOpenURLOptionsKey.sourceApplication.rawValue] as? String);
    }
    
    
    @available(iOS, introduced:4.2, deprecated:9.0, message:"Please use url:options:")
    public static func process(url: URL, sourceApplication app: String?) {
    Authorizator.recieveTokenURL(url: url, fromApp: app);
    }
    #endif
    
    
    
    public static func logOut() {
        LP.stop()
        Token.remove()
    }
    
    
    
    @available(*, unavailable, renamed: "configure")
    public static func start(appID id: String, delegate owner: VKDelegate) {}
    @available(*, unavailable, renamed: "logIn")
    public static func authorize() {}
}
//
//
//
//
//
//
//
//
//
//
private typealias VK_Defaults = VK
extension VK_Defaults {
    public struct defaults {
        //Returns used VK API version
        public static var apiVersion = "5.53"
        //Returns used VK SDK version
        public static let sdkVersion = "1.3.17"
        ///Requests timeout
        public static var timeOut : Int = 10
        ///Maximum number of attempts to send requests
        public static var maxAttempts : Int = 3
        ///Whether to allow automatic processing of some API error
        public static var catchErrors : Bool = true
        //Similarly request sendAsynchronous property
        public static var sendAsynchronous : Bool = true
        ///Maximum number of requests per second
        public static var maxRequestsPerSec : Int = 3
        ///Allows print log messages to console
        public static var logToConsole : Bool = false
        
        public static var language : String? {
            get {
                if useSystemLanguage {
                    let syslemLang = Bundle.preferredLocalizations(from: supportedLanguages).first
                    
                    if syslemLang == "uk" {
                        return "ua"
                    }
                    
                    return syslemLang
                }
                return self.privateLanguage
            }
            
            set {
                guard newValue == nil || supportedLanguages.contains(newValue!) else {return}
                self.privateLanguage = newValue
                useSystemLanguage = (newValue == nil)
            }
        }
        internal static var sleepTime : TimeInterval {return TimeInterval(1/Double(maxRequestsPerSec))}
        internal static let successBlock : VK.SuccessBlock = {success in}
        internal static let errorBlock : VK.ErrorBlock = {error in}
        internal static let progressBlock : VK.ProgressBlock = {int in}
        internal static let supportedLanguages = ["ru", "uk", "be", "en", "es", "fi", "de", "it"]
        internal static var useSystemLanguage = true
        private static var privateLanguage : String?
    }
}
//
//
//
//
//
//
//
//
//
//


public typealias VK_States = VK
extension VK_States {
    public enum States {
        case unknown
        case configured
//        case authorization
        case authorized
    }
    
    public static var state : States {
        guard VK.configured else {
            return .unknown
        }
        guard Token.exist else {
            return .configured
        }
        return .authorized
    }
}
//
//
//
//
//
//
//
//
//
//
private typealias VK_Extensions = VK
extension VK_Extensions {
    ///Access to the API methods
    public typealias API = _VKAPI
    public typealias Error = _VKError
    public typealias SuccessBlock = (_ response: JSON) -> Void
    public typealias ErrorBlock = (_ error: VK.Error) -> Void
    public typealias ProgressBlock = (_ done: Int, _ total: Int) -> Void
}
