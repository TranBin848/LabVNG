/*
 * Copyright 2013 The Netty Project
 *
 * The Netty Project licenses this file to you under the Apache License,
 * version 2.0 (the "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at:
 *
 *   https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */
package demo.io.http;

import demo.user.handler.Response;
import demo.user.handler.UserHandler;
import demo.util.Json;
import demo.util.QueryDecoder;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelFutureListener;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;
import io.netty.handler.codec.http.*;
import io.netty.util.CharsetUtil;

import static io.netty.handler.codec.http.HttpHeaderNames.*;
import static io.netty.handler.codec.http.HttpHeaderValues.APPLICATION_JSON;
import static io.netty.handler.codec.http.HttpHeaderValues.CLOSE;
import static io.netty.handler.codec.http.HttpResponseStatus.FORBIDDEN;
import static io.netty.handler.codec.http.HttpResponseStatus.OK;

public class HttpServerHandler extends SimpleChannelInboundHandler<HttpObject> {
    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        if (!(cause instanceof java.net.SocketException))
            cause.printStackTrace();
    }

    @Override
    public void channelReadComplete(ChannelHandlerContext ctx) {
        ctx.flush();
    }

    @Override
    public void channelRead0(ChannelHandlerContext ctx, HttpObject msg) {
        HttpRequest req = (HttpRequest) msg;
        var query = new QueryStringDecoder(req.uri());
        var path = query.path();

        Response res = null;
        if (path.equals("/"))
            res = Response.success("", "alive");
        else if (path.startsWith("/user/")) {
            var request = req.method() == HttpMethod.GET
                    ? QueryDecoder.parseParam(query)
                    : QueryDecoder.parseContent(req, query);

            res = UserHandler.handleHttp(request);
        }

        FullHttpResponse httpResponse;
        if (res == null) {
            httpResponse = new DefaultFullHttpResponse(req.protocolVersion(), FORBIDDEN);
        } else {
            var content = Json.toJsonPretty(res);
            httpResponse = new DefaultFullHttpResponse(req.protocolVersion(), OK, Unpooled.copiedBuffer(content, CharsetUtil.UTF_8));
            httpResponse.headers()
                    .set(CONTENT_TYPE, APPLICATION_JSON)
                    .setInt(CONTENT_LENGTH, content.length());
        }

        httpResponse.headers().set(CONNECTION, CLOSE);
        ctx.write(httpResponse).addListener(ChannelFutureListener.CLOSE);
    }
}
