package com.example.kiteemailservice.service;

import com.alibaba.fastjson.JSON;
import com.example.kiteemailservice.pojo.EmailVerVO;
import org.springframework.amqp.core.AmqpAdmin;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

@Component
public class QueueConfig {

    private AmqpAdmin amqpAdmin;

    @Resource
    private JavaMailSender javaMailSender;

    @Value("${spring.mail.username}")
    private String sender;

    public QueueConfig(AmqpAdmin amqpAdmin) {
        this.amqpAdmin = amqpAdmin;
    }

    @PostConstruct
    public void createQueues() {
        amqpAdmin.declareQueue(new Queue("EmailVer", true));
    }

    @RabbitListener(queues = {"EmailVer"})
    public void receive(String income) {
        System.out.println("Rabbit message: " + income);
        EmailVerVO message = JSON.parseObject(income, EmailVerVO.class);
        try {
            SimpleMailMessage mailMessage = new SimpleMailMessage();
            mailMessage.setFrom(sender);
            mailMessage.setTo(message.getEmail());
            mailMessage.setText("Your Verification Code: " + message.getCode());
            mailMessage.setSubject("Kite Verification Code");

            javaMailSender.send(mailMessage);
            System.out.println("Message sent successfuly");
        } catch (Exception e) {
            System.out.println("Message sent Failed" + e.getMessage());
        }

    }
}
