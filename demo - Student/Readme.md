# ***Yêu cầu trước buổi học***

# Yêu cầu cài đặt
### Bắt buộc
1. Java 21
2. Gradle 8.5 trở lên
3. IDE cho Java 21
### Tùy chọn
4. Telnet client
5. Redis Insight
6. Redis

# Gợi ý cài đặt
1. Java 21: [Amazon Corretto 21](https://docs.aws.amazon.com/corretto/latest/corretto-21-ug/downloads-list.html)
2. [Gradle](https://gradle.org/install/)
3.  IDE: [IntelliJ IDEA Community Edition](https://www.jetbrains.com/idea/download/?section=windows)
4. [Telnet client](https://quantrimang.com/cong-nghe/kich-hoat-telnet-trong-windows-207632)
5. [Redis Insight](https://redis.io/downloads/#Redis_Insight)

2. Redis: Chọn một trong các bản sau
    * Trong code demo có sẵn simualator, không cần cài đặt. Chạy class **RedisSimulator** trong project. 
      * Dữ liệu của của app này được lưu trên RAM, khi tắt app thì dữ liệu sẽ mất hết
    * Bản Portable [Redis for Windows](https://github.com/tporadowski/redis/releases)
      * Dữ liệu của của app này được lưu trên RAM, khi tắt app thì dữ liệu sẽ mất hết
    * Bản cài đặt: [Run Redis on Windows using WSL](https://redis.io/docs/latest/operate/oss_and_stack/install/archive/install-redis/install-redis-on-windows/#run-redis-on-windows-using-wsl-windows-subsystem-for-linux)

# Chạy thử Demo
1. Chạy thử bằng IDE: chạy class DemoServer
   [Video demo start server](https://drive.google.com/file/d/1MxCPn9Llsna2FHTI9QwO-tK7Pa-00el4/view?usp=sharing)

2. Chạy thử bằng command line
```
gradle run
```

3. Chú ý: 
* Phải cài đặt hoặc chạy redis trước khi chạy thử demo

# Test demo
1. Dùng trình duyệt web gọi thử các API sau
    * API login: http://127.0.0.1/user/login?id=1
    Chú ý: Lấy session trong response này để dùng cho các API khác

    * API đổi tên người dùng: http://127.0.0.1/user/changeName?id=1&name=NewName&session=XXX   
    Chú ý: thay XXX bằng session có được từ API login    

2. Thử dùng các API trên với các user id khác

# Tìm hiểu trước về database Redis
1. [Kiểu dữ liệu String](https://redis.io/docs/latest/commands/set/#examples): dùng để lưu dữ liệu người dùng
2. [Kiểu dữ liệu Sorted set](https://redis.io/docs/latest/commands/zrange/#examples): dùng làm bảng xếp hạng

# Tìm hiểu về thư viện Caffeine
1. Cách giới số lượng cache
2. Cách lấy dữ liệu từ cache, khi không có thì đọc từ database
3. Cách expire dữ liệu sau x giây
4. Cách save các dữ liệu đang có trong cache khi app shutdown

# Demo dùng socket nối vào room
* [Video demo join room](https://drive.google.com/file/d/1104EM7E-uFTc2FZ7X-_dR19fXcy6MIp_/view?usp=sharing)
### Thông tin server
1. IP: 127.0.0.1
2. Port: 3000
### Demo cách kết nối
Kết nối server bằng lệnh telnet
```
telnet 127.0.0.1 3000
```
Gửi lệnh login (user id: 1)
```
{"cmd":"login", "id":2}
```
Gửi lệnh join room
```
{"cmd":"roomJoin"}
```
Gửi lệnh chat
```
{"cmd":"roomBroadcast", "data":{"cmdBc":"chat", "msg":"Hallo 1"}}
```