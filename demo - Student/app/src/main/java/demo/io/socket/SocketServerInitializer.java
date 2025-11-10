package demo.io.socket;

import demo.user.SessionManager;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.socket.SocketChannel;
import io.netty.handler.timeout.IdleStateHandler;

public class SocketServerInitializer extends ChannelInitializer<SocketChannel> {
    final static int IDLE_TIME_READER = SessionManager.PING_PERIOD * 2; //second
    final static int IDLE_TIME_WRITER = SessionManager.SESSION_DURATION; //second
    final static int IDLE_TIME_ALL = 0; //second

    public SocketServerInitializer() {
    }

    @Override
    public void initChannel(SocketChannel ch) {
        ChannelPipeline p = ch.pipeline();
        p.addLast(new IdleStateHandler(IDLE_TIME_READER, IDLE_TIME_WRITER, IDLE_TIME_ALL));
        p.addLast(new PacketDecoder());
        p.addLast(new SocketServerHandler());

    }
}