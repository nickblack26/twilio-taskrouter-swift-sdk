import Foundation

let WORKER_LIST = "workerList"
let TASKQUEUE_LIST = "taskQueueList"
let BASE_PATH: String = "taskrouter.twilio.com"
let DEFAULT_PAGE_SIZE = 1000
let DEFAULT_MAX_WORKERS = 1000

enum WORKER_EVENTS: String {
    case activityUpdated,
        attributesUpdated = "worker.attributes.update",
        disconnected,
        error,
        ready = "init",
        reservationCreated = "reservation.created",
        reservationFailed,
        tokenExpired,
        tokenUpdated
}

enum OTHER_WORKER_EVENTS {
    case activityUpdated
    case
        attributesUpdated(Worker)
    case
        disconnected(Worker)
    case
        error(Worker)
    case
        ready(Worker)
    case
        reservationCreated(Reservation)
    case
        reservationFailed(Reservation)
    case
        tokenExpired(Worker)
    case
        tokenUpdated(Worker)
}

enum TASK_EVENTS: String {
    case canceled,
        completed,
        transferAttemptFailed,
        transferCanceled,
        transferCompleted,
        transferFailed,
        transferInitiated,
        updated,
        wrapup
}
