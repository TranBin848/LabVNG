package demo.io.socket;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import demo.log.Log;
import demo.room.Room;
import demo.room.RoomManager;
import demo.user.SessionManager;
import demo.user.handler.Command;
import demo.user.handler.LogAction;
import demo.user.handler.Response;
import demo.user.handler.UserHandler;
import demo.util.Result;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;

public class SocketServerHandler extends SimpleChannelInboundHandler<JsonObject> {
    public long userId;
    public String session;

    private ChannelHandlerContext ctx;

    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        super.channelActive(ctx);
        this.ctx = ctx;
        //Log.info("channelActive");
    }

    @Override
    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
        super.channelInactive(ctx);
        //Log.info("channelInactive", userId);
        if (userId > 0) {
            RoomManager.leave(Command.ROOM_LEAVE, userId);
            Log.userAction(LogAction.LOGOUT, userId, session, Result.SUCCESS);
            SessionManager.removeSession(userId);
        }
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        if (!(cause instanceof java.net.SocketException))
            cause.printStackTrace();
    }

    @Override
    protected void channelRead0(ChannelHandlerContext ctx, JsonObject input) throws Exception {
        //Log.info("SocketServerHandler.channelRead0", Json.toJson(input));
        var res = UserHandler.handleSocket(input, this);
        if (res.autoWrite)
            ctx.writeAndFlush(res.toByteBuf());
        if (res.isForceClose)
            ctx.close();
    }

    public void kick(Result result) {
        var res = Response.result(Command.KICK, result);
        ctx.writeAndFlush(res.toByteBuf());
        ctx.close();
    }

    public void writeAndFlush(Response<?> res) {
        ctx.writeAndFlush(res.toByteBuf());
    }
}
