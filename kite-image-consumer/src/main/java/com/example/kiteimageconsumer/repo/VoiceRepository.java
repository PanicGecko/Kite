package com.example.kiteimageconsumer.repo;


import com.example.kiteimageconsumer.model.Voice;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface VoiceRepository extends MongoRepository<Voice, String> {
}
