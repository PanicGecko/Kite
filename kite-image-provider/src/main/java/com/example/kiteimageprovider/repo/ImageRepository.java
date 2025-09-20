package com.example.kiteimageprovider.repo;

import com.example.kiteimageprovider.model.Image;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ImageRepository extends MongoRepository<Image, String> {



}
