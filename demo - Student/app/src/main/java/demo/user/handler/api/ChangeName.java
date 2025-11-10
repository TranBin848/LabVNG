package demo.user.handler.api;

import com.google.gson.JsonObject;
import demo.user.handler.Response;
import demo.log.Log;
import demo.user.handler.LogAction;
import demo.user.handler.Param;
import demo.user.handler.UserHandler;
import demo.user.model.UserData;
import demo.user.repository.UserDataRepository;
import demo.util.Json;
import demo.util.Result;

public class ChangeName {
    /*
        + Request:
            - HTTP: http://127.0.0.1/user/changeName?id=1&name=Hello&session=XXX
            - TCP Packet: {"cmd":"changeName","name":"Hello"}
        + Request:
            {
              "cmd": "changeName",
              "result": "SUCCESS",
              "data": {
                "id": 1,
                "timeCreate": "2025-10-18 17:12:53",
                "timeLogin": "2025-10-18 17:14:29",
                "displayName": "Hello",
                "level": 0
              }
            }
     */
    public static Response<?> handle(String command, long userId, JsonObject input) {
        var logAction = LogAction.CHANGE_NAME;

        var data = UserDataRepository.load(userId);
        if (data == null)
            return UserHandler.responseFail(command, userId, logAction, Result.INVALID_USER_ID, "Null");

        var name = Json.getString(input, Param.NAME);
        if (name == null || name.isBlank() || name.length() > 64)
            return UserHandler.responseFail(command, userId, logAction, Result.INVALID_NAME, name == null ? 0 : name.length());

        data.displayName = name;

        UserDataRepository.save(data);

        Log.userAction(LogAction.CHANGE_NAME, userId, Result.SUCCESS, name);
        return Response.success(command, data);
    }
}
