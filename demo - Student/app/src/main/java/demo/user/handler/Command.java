package demo.user.handler;

public interface Command {
    String LOGIN = "login";
    String LOGOUT = "logout";
    String PING = "ping";
    String KICK = "kick";
    String CHANGE_NAME = "changeName";
    String FINISH_LEVEL = "finishLevel";
    String GET_TOP_LEVEL = "getTopLevel";
    String GET_TOP_TIME = "getTopTime";
    String ROOM_JOIN = "roomJoin";
    String ROOM_LEAVE = "roomLeave";
    String ROOM_BROADCAST = "roomBroadcast";
}
