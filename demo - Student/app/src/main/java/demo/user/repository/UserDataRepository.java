package demo.user.repository;

import demo.db.Redis;
import demo.log.Log;
import demo.user.model.UserData;

public class UserDataRepository {
    static {
        Runtime.getRuntime().addShutdownHook(new Thread(UserDataRepository::onShutdown));
    }

    private static void onShutdown() {
        Log.info("UserDataRepository", "onShutdown");
    }

    public static UserData load(long userId) {
        return loadFromDatabase(userId);
    }

    private static UserData loadFromDatabase(long userId) {
        Log.info("UserDataRepository", "loadFromDatabase", userId);
        var keyName = UserData.keyName(userId);
        var data = Redis.get().get(keyName);
        return data == null ? null : UserData.decodeJson(data);
    }

    public static void save(UserData data) {
        saveToDatabase(data);
    }

    private static void saveToDatabase(UserData data) {
        Log.info("UserDataRepository", "saveToDatabase", data.id);
        var keyName = UserData.keyName(data.id);
        var raw = data.encodeJson();
        Redis.get().set(keyName, raw);
    }
}
