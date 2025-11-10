package demo.user.handler.api;

import com.google.gson.JsonObject;
import demo.log.Log;
import demo.user.handler.Response;

/**
 * Handler trả về packet hoàn tất level mẫu
 */
public class FinishLevel {

    // simple record to hold response data
    record FinishData(int level, int time, int gold) { }

    public static Response<?> handle(String command, long userId, JsonObject input) {
        Log.info("FinishLevel", "handle", "userId", userId, "command", command);
        // Trả về packet: cmd:finishLevel, level:1 time:30 gold:10
        return Response.success(command, new FinishData(1, 30, 10));
    }
}
