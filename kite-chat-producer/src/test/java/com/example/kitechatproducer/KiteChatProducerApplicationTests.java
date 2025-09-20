package com.example.kitechatproducer;

import org.junit.jupiter.api.Test;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@EntityScan(basePackages = "repos")
class KiteChatProducerApplicationTests {

    @Test
    void contextLoads() {
    }

}
