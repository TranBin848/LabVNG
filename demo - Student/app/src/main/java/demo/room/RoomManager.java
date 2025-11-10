package demo.room;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import demo.log.Log;
import demo.user.handler.LogAction;
import demo.user.handler.Param;
import demo.user.handler.Response;
import demo.util.Result;
import demo.util.id.GenerateId;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;

public class RoomManager {
    private final static int LIMIT_SIZE = 2;

    private static final ConcurrentHashMap<Long, Room> mapRoom = new ConcurrentHashMap<>();
    private static final ConcurrentHashMap<Long, Long> mapUserIdToRoomId = new ConcurrentHashMap<>();
    private static final ConcurrentLinkedQueue<Room> waitingRoom = new ConcurrentLinkedQueue<>();

    private static final GenerateId genId = new GenerateId();

    public static Room getByUserId(long userId) {
        var roomId = mapUserIdToRoomId.get(userId);
        if (roomId == null)
            return null;
        return mapRoom.get(roomId);
    }

    public static synchronized Response<Room> join(String cmd, long userId) {
        var room = getByUserId(userId);
        if (room != null)
            return Response.result(cmd, Result.ALREADY_JOIN, room);

        room = waitingRoom.poll();
        if (room == null) {
            room = new Room(genId.next());
            room.join(userId);
            mapUserIdToRoomId.put(userId, room.getId());

            waitingRoom.add(room);
            mapRoom.put(room.getId(), room);
        } else {
            room.join(userId);
            mapUserIdToRoomId.put(userId, room.getId());

            if (room.size() < LIMIT_SIZE)
                waitingRoom.add(room);
        }
        return Response.success(cmd, room);
    }

    public static Response<Long> leave(String cmd, long userId) {
        var room = getByUserId(userId);
        if (room == null)
            return Response.result(cmd, Result.NOT_JOIN_YET);

        mapUserIdToRoomId.remove(userId);
        Log.userAction(LogAction.ROOM_LEAVE, userId, Result.SUCCESS, room.getId());

        var res = Response.success(cmd, room.getId()).setId(userId);

        var size = room.leave(userId);
        if (size == 0) {
            mapRoom.remove(room.getId());
            Log.userAction(LogAction.ROOM_REMOVE, userId, Result.SUCCESS, room.getId());
        } else {
            room.broadcast(res);
        }

        return res;
    }

    public static Response<JsonElement> broadcast(String cmd, long userId, JsonObject input) {
        var room = getByUserId(userId);
        if (room == null)
            return Response.result(cmd, Result.NOT_JOIN_YET);

        var data = input.get(Param.DATA);
        if (data == null)
            return Response.result(cmd, Result.MISSING_DATA);

        var res = Response.success(cmd, data).setId(userId).setAutoWrite(false);
        room.broadcast(res);
        return res;
    }

}
