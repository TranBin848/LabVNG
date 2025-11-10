package demo.util.id;

import demo.log.Log;

import java.util.concurrent.atomic.AtomicLong;

//TODO: Dùng database Redis để:
// - save khi stop (viết trong hàm onShutdown)
// - load khi start app (viết trong hàm init)
public class GenerateId {
    protected AtomicLong counter;

    public long next() {
        return counter.incrementAndGet();
    }

    public GenerateId() {
        init();
        Runtime.getRuntime().addShutdownHook(new Thread(this::onShutdown));
    }

    protected void init() {
        counter = new AtomicLong();
        Log.info("GenerateUserId", "init", "counter", counter.get());
    }

    protected void onShutdown() {
        Log.info("GenerateUserId", "onShutdown", "counter", counter.get());
    }
}
