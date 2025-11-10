package demo.client.api;

import demo.user.handler.Command;

public class RequestChangeName extends Request{
    public String name;

    public RequestChangeName(String session, long userId, String name) {
        super(Command.CHANGE_NAME, session, userId);
        this.name = name;
    }
}
