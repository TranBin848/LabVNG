package demo.user;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import demo.io.ConnectionType;
import demo.io.socket.SocketServerHandler;
import demo.util.Result;

import java.time.Duration;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ThreadLocalRandom;

public class SessionManager {
    public final static int PING_PERIOD = 60; //second
    public final static int SESSION_DURATION = PING_PERIOD * 3; //second

    private final static String HTTP_PREFIX = "H_";
    private final static String SOCKET_PREFIX = "S_";

    static Cache<Long, String> cache = Caffeine.newBuilder()
            .expireAfterAccess(Duration.ofSeconds(SESSION_DURATION))
            .build();

    static ConcurrentHashMap<Long, SocketServerHandler> mapHandler = new ConcurrentHashMap<>();

    public static String getSession(long userId) {
        return cache.getIfPresent(userId);
    }

    /** Gia hạn thời gian expire của session */
    public static void touchSession(long userId) {
        cache.getIfPresent(userId);
    }

    public static boolean validateSession(ConnectionType conType, long userId, String session) {
        if (session == null)
            return false;
        if (conType == ConnectionType.SOCKET && !session.startsWith(SOCKET_PREFIX))
            return false;
        if (conType == ConnectionType.HTTP && !session.startsWith(HTTP_PREFIX))
            return false;

        var cacheSession = getSession(userId);
        if (cacheSession == null)
            return false;
        return cacheSession.equals(session);
    }

    public static String addSession(long userId, SocketServerHandler socketHandler) {
        var prefix = socketHandler == null ? HTTP_PREFIX : SOCKET_PREFIX;
        var session = prefix + ThreadLocalRandom.current().nextLong(0, Long.MAX_VALUE);

        var oldHandler = mapHandler.get(userId);
        if (oldHandler != null)
            oldHandler.kick(Result.KICK_BY_NEW_SESSION);
        if (socketHandler != null)
            mapHandler.put(userId, socketHandler);

        cache.put(userId, session);
        return session;
    }

    public static void removeSession(long userId) {
        cache.invalidate(userId);
    }

    public static SocketServerHandler getHandler (long userId) {
        return mapHandler.get(userId);
    }
}
