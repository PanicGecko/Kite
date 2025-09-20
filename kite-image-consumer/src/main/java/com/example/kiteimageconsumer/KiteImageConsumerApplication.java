package com.example.kiteimageconsumer;

import org.apache.dubbo.config.spring.context.annotation.EnableDubbo;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@EnableDubbo
public class KiteImageConsumerApplication {

    public static void main(String[] args) {
        SpringApplication.run(KiteImageConsumerApplication.class, args);
    }

}
