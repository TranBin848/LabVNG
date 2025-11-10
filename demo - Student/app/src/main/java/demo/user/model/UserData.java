package demo.user.model;

import demo.util.Json;
import demo.util.Time;

public class UserData {
    public final long id;
    public final String timeCreate;

    public String timeLogin;
    public String displayName;
    public int level;

    public UserData(long id) {
        this.id = id;
        timeCreate = Time.curDateTime();
        displayName = "User " + id;
    }

    public static String keyName(long userId) {
        return KeyName.USER_DATA_PREFIX + userId;
    }

    public String encodeJson() {
        return Json.toJson(this);
    }

    public static UserData decodeJson(String raw) {
        return Json.fromJson(raw, UserData.class);
    }

    @Override
    public String toString() {
        return encodeJson();
    }
}
