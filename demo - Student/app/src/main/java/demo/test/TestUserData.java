package demo.test;

import demo.db.Redis;
import demo.log.Log;
import demo.user.model.UserData;

public class TestUserData {
    /*
        Read about the data types used for UserData (String) at this link:
        https://redis.io/docs/latest/commands/?group=string
     */
    public static void main(String[] args) throws Exception {
        //Chọn ngẫu nhiên id để test
        var userId = System.nanoTime();
        Log.info("userId", userId);

        var keyName = UserData.keyName(userId);
        Log.info("keyName", keyName);

        UserData user = new UserData(userId);
        String encodeData = user.encodeJson();
        Log.info("encode", encodeData);
        //https://redis.io/docs/latest/commands/set/
        Log.info("set", Redis.get().set(keyName, encodeData));

        //https://redis.io/docs/latest/commands/get/
        String data = Redis.get().get(keyName);
        Log.info("get", data);
        UserData decode = UserData.decodeJson(data);
        Log.info("decode", decode);
    }
}
