package demo.util.id;

import demo.db.Redis;
import demo.log.Log;

import java.util.concurrent.atomic.AtomicLong;

public class GenerateIdRedis extends GenerateId {
    private final static String KEY_NAME = "GenerateId:counter";

    protected void init() {
        var data = Redis.get().get(KEY_NAME);
        if (data == null)
            counter = new AtomicLong();
        else
            counter = new AtomicLong(Long.parseLong(data));
        Log.info("GenerateUserId", "init", "counter", counter.get());
    }

    protected void onShutdown() {
        Redis.get().set(KEY_NAME, String.valueOf(counter.get()));
        Log.info("GenerateUserId", "onShutdown", "counter", counter.get());
    }
}
