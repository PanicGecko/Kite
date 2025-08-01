package com.kite.kiteuserconsumer;

import org.apache.dubbo.config.spring.context.annotation.EnableDubbo;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@EnableDubbo
public class KiteUserConsumerApplication {

    public static void main(String[] args) {
        SpringApplication.run(KiteUserConsumerApplication.class, args);
    }

}
