package com.example.kiteimageprovider;

import org.apache.dubbo.config.spring.context.annotation.EnableDubbo;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@EnableDubbo
public class KiteImageProviderApplication {

    public static void main(String[] args) {
        SpringApplication.run(KiteImageProviderApplication.class, args);
    }

}
