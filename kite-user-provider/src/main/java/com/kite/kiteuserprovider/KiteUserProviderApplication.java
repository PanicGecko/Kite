package com.kite.kiteuserprovider;

import org.apache.dubbo.config.spring.context.annotation.EnableDubbo;
import org.apache.dubbo.config.spring.context.annotation.EnableDubboConfig;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.amqp.rabbit.annotation.EnableRabbit;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication(scanBasePackages = "utils")
@MapperScan(basePackages = "dao")
@EnableRabbit
@EnableDubbo
public class KiteUserProviderApplication {

    public static void main(String[] args) {
        SpringApplication.run(KiteUserProviderApplication.class, args);
    }

}
