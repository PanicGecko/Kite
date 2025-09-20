package com.example.kiteimageprovider.repo;

import com.example.kiteimageprovider.model.Voice;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface VoiceRepository extends MongoRepository<Voice, String> {
}
