package demo.client.socket;

import com.google.gson.JsonObject;
import demo.client.api.RequestChangeName;
import demo.client.api.RequestLogin;
import demo.client.api.ResponseChangeName;
import demo.client.api.ResponseLogin;
import demo.log.Log;
import demo.user.handler.Command;
import demo.user.handler.Param;
import demo.user.handler.Response;
import demo.user.handler.UserHandler;
import demo.util.Json;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;

public class SocketClientHandler extends SimpleChannelInboundHandler<JsonObject> {
    private long userId = 1000;
    private String session;

    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        super.channelActive(ctx);
        Log.info("SocketClientHandler.channelActive");

        var request = new RequestLogin(userId);
        request.send(ctx);
    }

    @Override
    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
        super.channelInactive(ctx);
        Log.info("SocketClientHandler.channelInactive");
    }

    @Override
    protected void channelRead0(ChannelHandlerContext ctx, JsonObject input) throws Exception {
        var command = input.get(Param.COMMAND).getAsString();
        switch (command) {
            case Command.LOGIN -> {
                //Có thể parse response thành object hoặc dùng dưới dạng json
                var resLogin = Json.fromJson(input, ResponseLogin.class);
                session = resLogin.session;
                //session = input.get(Param.SESSION).getAsString();
                Log.info("session", session);

                //test gửi lệnh đổi tên sau khi login
                var request = new RequestChangeName(session, userId, "Name " + System.currentTimeMillis());
                request.send(ctx);
            }

            case Command.CHANGE_NAME -> {
                //Có thể parse response thành object hoặc dùng dưới dạng json
                var resChangeName = Json.fromJson(input, ResponseChangeName.class);
                Log.info("Change name response", Json.toJson(resChangeName));
            }
        }
    }
}
