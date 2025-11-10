package demo.client.socket;

import demo.log.Log;
import io.netty.bootstrap.Bootstrap;
import io.netty.channel.ChannelOption;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.MultiThreadIoEventLoopGroup;
import io.netty.channel.nio.NioIoHandler;
import io.netty.channel.socket.nio.NioSocketChannel;

public class SocketClient {
    public void start(String ip, int port) {
        new Thread(() -> {
            Log.info("SocketClient", "start");

            EventLoopGroup group = new MultiThreadIoEventLoopGroup(1, NioIoHandler.newFactory());
            try {
                Bootstrap b = new Bootstrap();
                b.group(group)
                        .channel(NioSocketChannel.class)
                        .option(ChannelOption.TCP_NODELAY, true)
                        .handler(new SocketClientInitializer());

                // Start the client.
                var f = b.connect(ip, port).sync();
                Log.info("SocketClient", "connected");

                // Wait until the connection is closed.
                f.channel().closeFuture().sync();
                Log.info("SocketClient", "closed");
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                group.shutdownGracefully();
            }
        }).start();
    }
}
