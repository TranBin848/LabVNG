package demo.client.api;

import demo.user.handler.Response;
import demo.user.model.UserData;
import demo.util.Result;

public class ResponseLogin extends Response<UserData> {
    public ResponseLogin(String command, Result result, UserData data) {
        super(command, result, data);
    }
}
