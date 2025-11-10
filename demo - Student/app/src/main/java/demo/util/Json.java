package demo.util;

import com.google.gson.*;

public class Json {
    public static Gson gson = new GsonBuilder().create();
    public static Gson gsonPretty = new GsonBuilder().setPrettyPrinting().create();

    public static String toJson(Object src) {
        return gson.toJson(src);
    }

    public static String toJsonPretty(Object src) {
        return gsonPretty.toJson(src);
    }

    public static <T> T fromJson(String json, Class<T> classOfT) {
        return gson.fromJson(json, classOfT);
    }

    public static <T> T fromJson(JsonElement json, Class<T> classOfT) {
        return gson.fromJson(json, classOfT);
    }

    public static JsonObject parse(String input) {
        try {
            return JsonParser.parseString(input).getAsJsonObject();
        } catch (Exception ignored) {
        }
        return null;
    }

    public static Integer getInt(JsonObject data, String key) {
        try {
            return data.get(key).getAsInt();
        } catch (Exception ignored) {
        }
        return null;
    }

    public static Long getLong(JsonObject data, String key) {
        try {
            return data.get(key).getAsLong();
        } catch (Exception ignored) {
        }
        return null;
    }

    public static String getString(JsonObject data, String key) {
        try {
            return data.get(key).getAsString();
        } catch (Exception ignored) {
        }
        return null;
    }
}
