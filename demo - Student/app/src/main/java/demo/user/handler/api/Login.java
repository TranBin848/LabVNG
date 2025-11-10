package demo.user.handler.api;

import com.google.gson.JsonObject;
import demo.DemoServer;
import demo.io.ConnectionType;
import demo.io.socket.SocketServerHandler;
import demo.log.Log;
import demo.user.SessionManager;
import demo.user.handler.LogAction;
import demo.user.handler.Response;
import demo.user.model.UserData;
import demo.user.repository.UserDataRepository;
import demo.util.Result;
import demo.util.Time;

public class Login {
    /*
        + Request:
            - HTTP: http://127.0.0.1/user/login?id=1
            - TCP Packet: {"cmd":"login", "id":1}
        + Request:
            {
              "cmd": "login",
              "result": "SUCCESS",
              "data": {
                "id": 1,
                "timeCreate": "2025-10-18 17:12:53",
                "timeLogin": "2025-10-18 17:14:29",
                "displayName": "User 1",
                "level": 0
              },
              "session": "H_976952924735774675"
            }
     */
    public static Response<UserData> handle(String command, long userId, JsonObject input, SocketServerHandler socketHandler) {
        UserData data;
        if (userId <= 0) {
            userId = DemoServer.genUserId.next();
        }

        data = UserDataRepository.load(userId);
        if (data == null) {
            data = new UserData(userId);
            Log.userAction(LogAction.REGISTER, userId, Result.SUCCESS);
        }

        data.timeLogin = Time.curDateTime();
        var session = SessionManager.addSession(userId, socketHandler);

        UserDataRepository.save(data);

        Log.userAction(LogAction.LOGIN, userId, Result.SUCCESS);
        return Response.success(command, data).setSession(session);
    }
}
