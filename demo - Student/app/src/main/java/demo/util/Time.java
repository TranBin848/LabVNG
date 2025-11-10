package demo.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Time {
    final static DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public static long current() {
        return System.currentTimeMillis() / 1000;
    }

    public static String curDateTime() {
        return LocalDateTime.now().format(formatter);
    }
}
