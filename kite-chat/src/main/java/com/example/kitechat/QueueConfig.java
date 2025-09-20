package com.example.kitechat;

import org.springframework.amqp.core.AmqpAdmin;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.annotation.EnableRabbit;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Configuration
public class QueueConfig {

    private AmqpAdmin amqpAdmin;

    public QueueConfig(AmqpAdmin amqpAdmin) {
        this.amqpAdmin = amqpAdmin;
    }

    @PostConstruct
    public void createQueues() {
        amqpAdmin.declareQueue(new Queue("server1", true));
    }
}
