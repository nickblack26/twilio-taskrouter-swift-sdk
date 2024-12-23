import Foundation

enum LogLevel {
    case error, warn, info, debug, trace, silent
}

struct Logger: Decodable {
    var moduleName: String
    
    init(
        _ moduleName: String,
        level: LogLevel
    ) {
        self.moduleName = moduleName
    }
    
    /**
     * @param {string} level
     */
    func setLevel(level: String) {
//        if (logLevels.indexOf(level) === -1) {
//            throw Errors.INVALID_ARGUMENT.clone('Error setting Logger level. <string>level must be one of [\'trace\', \'debug\', \'info\', \'warn\', \'error\', \'silent\']');
//        }
//        
//        self._log.setLevel(level, false);
//        self._log.setDefaultLevel(level);
    }
    
    /**
     * @return {string}
     */
    func getLevel() -> String {
        ""
//        return logLevels[this._log.getLevel()];
    }
    
    /**
     * @private
     * @return {string}
     */
    func _getTimestamp() -> String {
        ""
//        return `[${new Date().toISOString()}]`;
    }
}
