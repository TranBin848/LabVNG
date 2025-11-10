package demo.test;

import demo.user.model.TopLevel;
import demo.user.model.TopTime;
import demo.user.model.UserData;
import demo.user.repository.UserDataRepository;

public class CreateDataForRanking {
    public static void main(String[] args) throws Exception {
        var userId = 1001;
        UserDataRepository.save(new UserData(userId));
        TopLevel.add(userId, 102);
        TopTime.add(userId, 100, 30);
        TopTime.add(userId, 101, 10);
        TopTime.add(userId, 102, 50);

        userId = 1002;
        UserDataRepository.save(new UserData(userId));
        TopLevel.add(userId, 101);
        TopTime.add(userId, 100, 20);
        TopTime.add(userId, 101, 20);

        userId = 1003;
        UserDataRepository.save(new UserData(userId));
        TopLevel.add(userId, 100);
        TopTime.add(userId, 100, 25);

    }
}
