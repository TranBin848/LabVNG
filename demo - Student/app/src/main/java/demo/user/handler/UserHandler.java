package demo.user.handler;

import com.google.gson.JsonObject;
import demo.io.ConnectionType;
import demo.io.socket.SocketServerHandler;
import demo.log.Log;
import demo.user.SessionManager;
import demo.user.handler.api.*;
import demo.util.Json;
import demo.util.Result;

public class UserHandler {
    public static Response<?> handleHttp(JsonObject input) {
        var command = Json.getString(input, Param.COMMAND);
        if (command == null)
            return responseFail("", 0L, LogAction.HANDLE, Result.INVALID_COMMAND);

        var userId = Json.getLong(input, Param.USER_ID);
        if (userId == null || userId < 0)
            return responseFail(command, userId, LogAction.HANDLE, Result.INVALID_USER_ID);

        if (Command.LOGIN.equals(command))
            return handleLogin(command, userId, input, null);

        var session = Json.getString(input, Param.SESSION);
        if (session == null)
            return responseFail(command, userId, LogAction.HANDLE, Result.MISSING_SESSION);

        if (!SessionManager.validateSession(ConnectionType.HTTP, userId, session))
            return responseFail(command, userId, LogAction.HANDLE, Result.INVALID_SESSION);

        return handle(command, userId, false, input);
    }

    public static Response<?> handleSocket(JsonObject input, SocketServerHandler socketHandler) {
        var command = Json.getString(input, Param.COMMAND);
        if (command == null)
            return responseFail("", 0L, LogAction.HANDLE, Result.INVALID_COMMAND).setForceClose();

        if (socketHandler.session == null) {
            var userId = Json.getLong(input, Param.USER_ID);
            if (userId == null || userId < 0)
                return responseFail(command, userId, LogAction.HANDLE, Result.INVALID_USER_ID).setForceClose();

            if (!Command.LOGIN.equals(command))
                return responseFail(command, userId, LogAction.HANDLE, Result.NOT_LOGIN_YET).setForceClose();

            var res = handleLogin(command, userId, input, socketHandler);
            if (res.isSuccess()) {
                socketHandler.userId = userId;
                socketHandler.session = res.session;

            }
            return res;
        } else {
            var res = handle(command, socketHandler.userId, true, input);
            if (res.isSuccess())
                SessionManager.touchSession(socketHandler.userId);
            return res;
        }
    }

    private static Response<?> handle(String command, long userId, boolean isSocket, JsonObject input) {
        try {
            return handleCommand(command, userId, isSocket, input);
        } catch (Exception e) {
            return responseFail(command, userId, LogAction.HANDLE, Result.EXCEPTION, e.getMessage());
        }
    }

    public static Response<?> responseFail(String command, Long userId, LogAction logAction, Result result) {
        return responseFail(command, userId, logAction, result, "");
    }

    public static Response<?> responseFail(String command, Long userId, LogAction logAction, Result result, Object msg) {
        Log.userAction(logAction, userId, result, msg);
        return Response.result(command, result);
    }

    private static Response<?> handleLogin(String command, long userId, JsonObject input, SocketServerHandler socketHandler) {
        return Login.handle(command, userId, input, socketHandler);
    }

    private static Response<?> handleCommand(String command, long userId, boolean isSocket, JsonObject input) {
        Response<?> res = switch (command) {
            case Command.PING -> Ping.handle(command, userId, input);
            case Command.FINISH_LEVEL -> FinishLevel.handle(command, userId, input);
            case Command.CHANGE_NAME -> ChangeName.handle(command, userId, input);
            default -> null;
        };
        if (res != null)
            return res;

        //Các lệnh chỉ hỗ trợ khi kết nối socket
        if (isSocket) {
            res = switch (command) {
                case Command.ROOM_JOIN -> RoomJoin.handle(command, userId, input);
                case Command.ROOM_LEAVE -> RoomLeave.handle(command, userId, input);
                case Command.ROOM_BROADCAST -> RoomBroadcast.handle(command, userId, input);
                default -> null;
            };
            if (res != null)
                return res;
        }

        return responseFail(command, userId, LogAction.HANDLE, Result.INVALID_COMMAND).setForceClose();
    }
}

