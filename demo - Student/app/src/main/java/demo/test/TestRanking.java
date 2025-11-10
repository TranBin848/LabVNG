package demo.test;

import demo.db.Redis;
import demo.log.Log;
import redis.clients.jedis.resps.Tuple;

import java.util.List;

public class TestRanking {
    /*
        Read about the data types used for leaderboards (Sorted Set) at this link:
        https://redis.io/docs/latest/commands/?group=sorted-set
     */
    public static void main(String[] args) throws Exception {
        var redis = Redis.get();

        String keyName = "test_ranking";
        //Thêm user vào bảng xếp hạng
        //https://redis.io/docs/latest/commands/zadd/
        redis.zadd(keyName, 200, "" + 1);
        redis.zadd(keyName, 500, "" + 2);
        redis.zadd(keyName, 100, "" + 3);

        //Lấy top 10
        //https://redis.io/docs/latest/commands/zrevrange/
        List<Tuple> tupleList = redis.zrevrangeWithScores(keyName, 0, 10);
        for (var i = 0; i < tupleList.size(); i++) {
            var tuple = tupleList.get(i);
            var userId = tuple.getElement();
            var score = tuple.getScore();
            var rank = i + 1;

            Log.info("Rank", rank, "User ID", userId, "Score", score);
        }
    }

}
