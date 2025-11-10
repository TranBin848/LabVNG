package demo.io.socket;

import demo.log.Log;
import demo.util.Json;
import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.ByteToMessageDecoder;

import java.nio.charset.StandardCharsets;
import java.util.List;

public class PacketDecoder extends ByteToMessageDecoder {
    final static int LIMIT_SIZE = 1000;
    public final static char DELIMITER = '\n';
    private static final String TAG = "PacketDecoder";

    @Override
    protected final void decode(ChannelHandlerContext ctx, ByteBuf buffer, List<Object> out) throws Exception {
        buffer.markReaderIndex();
        var bufferSize = buffer.readableBytes();
        if (bufferSize > LIMIT_SIZE) {
            ctx.close();
            Log.info(TAG, "close", "LIMIT_SIZE", bufferSize);
            return;
        }

        var posStart = buffer.readerIndex();
        var posEndLine = buffer.indexOf(posStart, posStart + bufferSize, (byte) DELIMITER);
        if (posEndLine < 0) {
            buffer.resetReaderIndex();
            return;
        }

        var length = posEndLine - posStart + 1;
        var line = buffer.readString(length, StandardCharsets.UTF_8).trim();
        if (line.isEmpty())
            return;
        //Log.info(TAG, line);

        var json = Json.parse(line);
        if (json == null) {
            Log.info(TAG, "close connection", "Invalid json");
            ctx.close();
            return;
        }

        out.add(json);
    }
}