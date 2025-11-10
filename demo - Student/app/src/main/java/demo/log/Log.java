package demo.log;

import demo.user.SessionManager;
import demo.user.handler.LogAction;
import demo.util.Result;
import demo.util.Time;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Log {
    private static final Logger logger = LogManager.getLogger(Log.class);
    private static final String SEPARATOR = " | ";

    public static void info(Object... acs) {
        var sb = new StringBuilder();
        sb.append(Time.curDateTime()).append(SEPARATOR);
        sb.append("INFO").append(SEPARATOR);
        for (Object o : acs)
            sb.append(o).append(SEPARATOR);

        logger.info(sb);
    }

    public static void error(Object... acs) {
        var sb = new StringBuilder();
        sb.append(Time.curDateTime()).append(SEPARATOR);
        sb.append("ERROR").append(SEPARATOR);
        for (Object o : acs)
            sb.append(o).append(SEPARATOR);

        logger.error(sb);
    }

    public static void userAction(LogAction action, Long userId, Result result, Object... acs) {
        userAction(action, userId, SessionManager.getSession(userId), result, acs);
    }

    public static void userAction(LogAction action, Long userId, String session, Result result, Object... acs) {
        var sb = new StringBuilder();
        sb.append(Time.curDateTime()).append(SEPARATOR);
        sb.append("USER").append(SEPARATOR);
        sb.append(action).append(SEPARATOR);
        sb.append(userId).append(SEPARATOR);
        sb.append(session == null ? "" : session).append(SEPARATOR);
        sb.append(result).append(SEPARATOR);
        for (Object o : acs)
            sb.append(o).append(SEPARATOR);

        logger.info(sb);
    }
}
