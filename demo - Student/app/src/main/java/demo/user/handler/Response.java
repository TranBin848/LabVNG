package demo.user.handler;

import demo.io.socket.PacketDecoder;
import demo.util.Json;
import demo.util.Result;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.util.CharsetUtil;

public class Response<T> {
    public final String cmd;
    public final Result result;
    public final T data;

    public Long id;
    public String session;

    public transient boolean isForceClose;
    public transient boolean autoWrite;

    public static <T> Response<T> success(String command, T data) {
        return new Response<>(command, Result.SUCCESS, data);
    }

    public static <T> Response<T> result(String command, Result result, T data) {
        return new Response<>(command, result, data);
    }

    public static <T> Response<T> result(String command, Result result) {
        return result(command, result, null);
    }

    public Response(String cmd, Result result, T data) {
        this.cmd = cmd;
        this.result = result;
        this.data = data;
        this.autoWrite = true;
    }

    public boolean isSuccess () {
        return result == Result.SUCCESS;
    }

    public Response<T> setId(long value) {
        id = value;
        return this;
    }

    public Response<T> setForceClose() {
        isForceClose = true;
        return this;
    }

    public Response<T> setSession(String value) {
        session = value;
        return this;
    }

    public Response<T> setAutoWrite(boolean value) {
        autoWrite = value;
        return this;
    }

    @Override
    public String toString() {
        return Json.toJson(this);
    }

    public ByteBuf toByteBuf() {
        return Unpooled.copiedBuffer(toString() + PacketDecoder.DELIMITER, CharsetUtil.UTF_8);
    }
}
