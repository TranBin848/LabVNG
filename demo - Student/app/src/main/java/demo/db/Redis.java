package demo.db;

import demo.log.Log;
import demo.util.Time;
import redis.clients.jedis.JedisPooled;

public class Redis {
    private static JedisPooled jedisPooled;

    static {
        init();
    }

    private static void init() {
        Log.info("Redis", "starting");
        try {
            jedisPooled = new JedisPooled("localhost", 6379);

            jedisPooled.set("testConnect", "" + Time.current());
            Log.info("Redis", "started");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static JedisPooled get() {
        return jedisPooled;
    }
}
