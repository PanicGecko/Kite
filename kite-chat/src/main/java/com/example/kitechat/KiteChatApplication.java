package com.example.kitechat;

import org.apache.dubbo.config.spring.context.annotation.EnableDubbo;
import org.springframework.amqp.rabbit.annotation.EnableRabbit;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.cassandra.CassandraAutoConfiguration;
import org.springframework.boot.autoconfigure.data.cassandra.CassandraDataAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@SpringBootApplication
@EnableRabbit
@EnableDubbo
public class KiteChatApplication {

    public static void main(String[] args) {

        SpringApplication.run(KiteChatApplication.class, args);

    }

}
