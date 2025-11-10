package demo.user.model;

import demo.db.Redis;
import redis.clients.jedis.resps.Tuple;

import java.util.List;

public class TopTime {

    public static void add(long userId, int level, long time) {
        Redis.get().zadd(keyName(level), time, "" + userId);
    }

    public static List<Tuple> getTop(int level, int size) {
        return Redis.get().zrevrangeWithScores(keyName(level), 0, size);
    }

    public static long getRank(int level, long userId) {
        var rank = Redis.get().zrevrank(keyName(level), "" + userId);
        return rank == null ? -1 : rank;
    }

    public static String keyName(int level) {
        return KeyName.TOP_TIME_PREFIX + level;
    }
}
