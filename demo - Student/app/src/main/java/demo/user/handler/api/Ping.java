package demo.user.handler.api;

import com.google.gson.JsonObject;
import demo.user.handler.Response;
import demo.util.Time;

public class Ping {
    /*
        + Request:
            - HTTP: http://127.0.0.1/user/ping?id=1&session=XXX
            - TCP Packet: {"cmd":"ping"}
        + Request:
            {
              "cmd": "ping",
              "result": "SUCCESS",
              "data": {
                "time": "2025-10-18 17:14:54"
              }
            }
     */

    record Pong(String time) {
    }

    public static Response<?> handle(String command, long userId, JsonObject input) {
        return Response.success(command, new Pong(Time.curDateTime()));
    }
}
