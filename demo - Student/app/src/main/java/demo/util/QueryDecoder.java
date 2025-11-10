package demo.util;

import com.google.gson.JsonObject;
import demo.user.handler.Param;
import io.netty.handler.codec.http.HttpContent;
import io.netty.handler.codec.http.HttpRequest;
import io.netty.handler.codec.http.QueryStringDecoder;
import io.netty.util.CharsetUtil;

public class QueryDecoder implements Param {

    public static JsonObject parseParam(QueryStringDecoder query) {
        var res = new JsonObject();
        try {
            res.addProperty(COMMAND, query.path().substring(6)); //Path luôn bắt đầu bằng chuỗi "/user/"
            for (var e : query.parameters().entrySet())
                res.addProperty(e.getKey(), e.getValue().getFirst());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }

    public static JsonObject parseContent(HttpRequest req, QueryStringDecoder query) {
        JsonObject res = null;
        try {
            var content = ((HttpContent) req).content().toString(CharsetUtil.UTF_8);
            res = Json.parse(content);
            res.addProperty(COMMAND, query.path().substring(6)); //Path luôn bắt đầu bằng chuỗi "/user/"
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }

}
