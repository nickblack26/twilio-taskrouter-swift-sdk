import Foundation

final class WorkspaceRoutes: BaseRoutes {
    var workspaceSid: String

    init(_ workspaceSid: String) {
        /**
         * @type {string}
         */
        self.workspaceSid = workspaceSid

        super.init()
        /**
         * @type {WorkspaceRoutes.routeTypes}
         */
        self.routes = [
            WORKER_LIST: BASE_PATH.appending("/Workspaces/\(workspaceSid)/Workers"),
            TASKQUEUE_LIST: BASE_PATH.appending("/Workspaces/\(workspaceSid)/TaskQueues"),
        ]
    }
}
