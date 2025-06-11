package com.example.kiteemailservice;

import org.springframework.amqp.rabbit.annotation.EnableRabbit;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@EnableRabbit
public class KiteEmailServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(KiteEmailServiceApplication.class, args);
    }

}
