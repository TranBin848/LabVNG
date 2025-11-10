package demo.room;

import com.google.gson.JsonElement;
import demo.io.socket.SocketServerHandler;
import demo.user.SessionManager;
import demo.user.handler.Response;
import demo.user.repository.UserDataRepository;

import java.util.Map;
import java.util.TreeMap;
import java.util.concurrent.ConcurrentHashMap;

public class Room {
    private final ConcurrentHashMap<Long, SocketServerHandler> mapHandler = new ConcurrentHashMap<>();

    private final long id;

    public Room(long id) {
        this.id = id;
    }

    public int join (long userId) {
        var handler = SessionManager.getHandler(userId);
        mapHandler.put(userId, handler);
        return size();
    }

    public int leave (long userId) {
        mapHandler.remove(userId);
        return size();
    }

    public int size () {
        return mapHandler.size();
    }

    public long getId() {
        return id;
    }

    public void broadcast (Response<?> res) {
        for (var handler : mapHandler.values()) {
            handler.writeAndFlush(res);
        }
    }

    public Map<Long, String> getMapName() {
        var map = new TreeMap<Long, String>();
        for (var handler : mapHandler.values()) {
            var userData = UserDataRepository.load(handler.userId);
            map.put(handler.userId, userData.displayName);
        }
        return map;
    }
}
