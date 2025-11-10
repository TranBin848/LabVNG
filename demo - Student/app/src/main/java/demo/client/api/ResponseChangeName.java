package demo.client.api;

import demo.user.handler.Response;
import demo.user.model.UserData;
import demo.util.Result;

public class ResponseChangeName extends Response<UserData> {
    public ResponseChangeName(String command, Result result, UserData data) {
        super(command, result, data);
    }
}
