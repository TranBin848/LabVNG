package demo.client.socket;

import demo.io.socket.PacketDecoder;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.socket.SocketChannel;

public class SocketClientInitializer extends ChannelInitializer<SocketChannel> {

    public SocketClientInitializer() {
    }

    @Override
    public void initChannel(SocketChannel ch) {
        ChannelPipeline p = ch.pipeline();
        p.addLast(new PacketDecoder());
        p.addLast(new SocketClientHandler());

    }
}