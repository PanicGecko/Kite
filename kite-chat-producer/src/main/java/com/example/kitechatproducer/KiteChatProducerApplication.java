package com.example.kitechatproducer;

import org.apache.dubbo.config.spring.context.annotation.EnableDubbo;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.amqp.rabbit.annotation.EnableRabbit;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.cassandra.repository.config.EnableCassandraRepositories;

@SpringBootApplication(scanBasePackages = "utils")
@MapperScan(basePackages = "dao")
@EnableCassandraRepositories(basePackages = "repos")
@EntityScan(basePackages = "pojo")
@EnableDubbo
//@EnableRabbit
//@EnableDubbo
//@EnableAutoConfiguration
public class KiteChatProducerApplication {

    public static void main(String[] args) {
        SpringApplication.run(KiteChatProducerApplication.class, args);
    }

}
