package demo.client.api;

import demo.user.handler.Command;

public class RequestLogin extends Request{
    public RequestLogin(long userId) {
        super(Command.LOGIN, null, userId);
    }
}
