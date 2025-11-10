package demo.test;

import demo.log.Log;
import demo.util.id.GenerateId;

public class TestGenerateId {
    public static GenerateId genId = new GenerateId();

    public static void main(String[] args) throws Exception {

        for (var i = 0; i < 5; i++) {
            Log.info("next ID", genId.next());
        }
    }
}
