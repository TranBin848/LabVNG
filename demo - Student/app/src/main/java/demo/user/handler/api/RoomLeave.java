package demo.user.handler.api;

import com.google.gson.JsonObject;
import demo.log.Log;
import demo.room.RoomManager;
import demo.user.handler.LogAction;
import demo.user.handler.Response;

public class RoomLeave {
    /*
        + Request:
            - TCP Packet: {"cmd":"roomLeave"}
     */

    public static Response<?> handle(String command, long userId, JsonObject input) {
        return RoomManager.leave(command, userId);
    }
}
