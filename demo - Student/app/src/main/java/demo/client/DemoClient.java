package demo.client;

import demo.client.socket.SocketClient;
import demo.log.Log;

public class DemoClient {
    private static final String TAG = "DemoClient";

    public static void main(String[] args) throws Exception {
        Log.info(TAG, "main");
        new SocketClient().start("127.0.0.1", 3000);
    }
}
