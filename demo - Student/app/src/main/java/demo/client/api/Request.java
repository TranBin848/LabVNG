package demo.client.api;

import demo.io.socket.PacketDecoder;
import demo.util.Json;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelHandlerContext;
import io.netty.util.CharsetUtil;

public abstract class Request {
    public final String command;
    public final String session;
    public final long userId;

    protected Request(String command, String session, long userId) {
        this.command = command;
        this.session = session;
        this.userId = userId;
    }

    public void send (ChannelHandlerContext ctx) {
        var data = Json.toJson(this);
        var buf = Unpooled.copiedBuffer(data + PacketDecoder.DELIMITER, CharsetUtil.UTF_8);
        ctx.writeAndFlush(buf);
    }
}
