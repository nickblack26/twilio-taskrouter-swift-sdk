import Foundation

class BaseRoutes {
    var component = URLComponents(string: BASE_PATH)
    var request: URLRequest
    var routes: [String:String]
    
    init() {
        self.component?.scheme = "https"
        self.component?.host = "taskrouter.twilio.com/v1"
        self.routes = [:]
        self.request = URLRequest(url: component!.url!)
        self.request.allHTTPHeaderFields = ["Authorization": "Bearer \("")"]
    }
    
    /**
     * @public
     * @param {string} route
     * @param {...*} args
     * @return {keyof this.routes}
     */
    func getRoute(
        _ route: String,
        args: [String:String] = [:]
    ) -> String {
        guard let route = self.routes[route] else {
            fatalError("Invalid route fetched <string>route '\(route)' does not exist.")
        }
        
        if (!args.isEmpty) {
            let copy = self.routes[route]
            
//            if (args.length !== (copy.path.match(/%s/g) || []).length) {
//                throw twilioErrors.INVALID_ARGUMENT.clone(`Invalid number of positional arguments supplied for route ${route}`);
//            }
//            
//            for (let arg of args) {
//                copy.path = copy.path.replace(/%s/, arg);
//            }
            
            return copy ?? ""
        }
        
        return self.routes[route] ?? "";
    }
}
