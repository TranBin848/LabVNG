package demo.user.handler.api;

import com.google.gson.JsonObject;
import demo.log.Log;
import demo.room.Room;
import demo.room.RoomManager;
import demo.user.handler.LogAction;
import demo.user.handler.Response;

import java.util.Map;

public class RoomJoin {
    /*
        + Request:
            - TCP Packet: {"cmd":"roomJoin"}
     */

    public static class Info {
        long roomId;
        Map<Long, String> mapName;

        Info(Room room) {
            if (room != null) {
                this.roomId = room.getId();
                this.mapName = room.getMapName();
            }
        }
    }

    public static Response<Info> handle(String command, long userId, JsonObject input) {
        var resJoin = RoomManager.join(command, userId);
        var room = resJoin.data;
        Log.userAction(LogAction.ROOM_JOIN, userId, resJoin.result, room == null ? 0L : room.getId());

        var res = Response.result(command, resJoin.result, new Info(room)).setId(userId).setAutoWrite(false);
        if (room != null)
            room.broadcast(res);
        return res;
    }
}
