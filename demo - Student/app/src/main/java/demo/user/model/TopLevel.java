package demo.user.model;

import demo.db.Redis;
import redis.clients.jedis.resps.Tuple;

import java.util.List;

public class TopLevel {

    public static void add(long userId, int level) {
        Redis.get().zadd(keyName(), level, "" + userId);
    }

    public static List<Tuple> getTop(int size) {
        return Redis.get().zrevrangeWithScores(keyName(), 0, size);
    }

    public static long getRank(long userId) {
        var rank = Redis.get().zrevrank(keyName(), "" + userId);
        return rank == null ? -1 : rank;
    }

    public static String keyName() {
        return KeyName.TOP_LEVEL;
    }
}
