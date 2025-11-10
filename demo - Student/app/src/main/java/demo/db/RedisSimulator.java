package demo.db;

import redis.embedded.RedisServer;

import java.io.IOException;

/**
 * Giả lập database redis. Chỉ dùng khi trên PC không cài đặt redis
 */
public class RedisSimulator {
    private static RedisServer redis;

    public static void main(String[] args) throws Exception {
        Runtime.getRuntime().addShutdownHook(new Thread(RedisSimulator::onShutdown));

        redis = new RedisServer(6379);
        redis.start();

        try {
            Thread.sleep(Long.MAX_VALUE);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    private static void onShutdown() {
        try {
            redis.stop();
        } catch (IOException ignored) {
        }
    }
}
