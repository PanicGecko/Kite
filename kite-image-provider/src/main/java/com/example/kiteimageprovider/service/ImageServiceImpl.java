package com.example.kiteimageprovider.service;

import com.example.kiteimageprovider.model.Image;
import com.example.kiteimageprovider.repo.ImageRepository;
import org.apache.dubbo.config.annotation.DubboService;
import org.bson.BsonBinarySubType;
import org.bson.types.Binary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.multipart.MultipartFile;
import service.RpcImageService;
import utils.Constants;
import vo.GetImageVO;
import vo.StoreImageVO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@DubboService
public class ImageServiceImpl implements RpcImageService{
    @Autowired
    private ImageRepository imageRepository;

    @Override
    public List<String> storeImages(StoreImageVO storeImageVO) {

        System.out.println("ImageServiceImpl - storeImages - begin");

        Map<String, String> extentions = new HashMap<>();
        for (MultipartFile i : storeImageVO.getImages()) {
            int index = i.getOriginalFilename().lastIndexOf('.');
            if (index > 0) {
                String ex = i.getOriginalFilename().substring(index + 1);
                if (!Constants.exts.contains(ex)) {
                    return null;
                }
                extentions.put(i.getOriginalFilename(), ex);
            }
        }

        ArrayList<String> fileUrls = new ArrayList<>();
        try {
            for (int i = 0; i < storeImageVO.getImages().length; i++) {
                Image image = new Image();
                image.setChat(storeImageVO.getChatId());
                image.setFrom(storeImageVO.getFrom());
                image.setImage(new Binary(BsonBinarySubType.BINARY, storeImageVO.getImages()[i].getBytes()));
                image.setId(storeImageVO.getNames()[i]);
                image = imageRepository.insert(image);
                fileUrls.add(image.getId()); //change this when we can confirm that the names and ids match up
            }

        } catch (Exception e) {
            System.out.println("ImageServiceImpl: storeImages - something went wrong: " + e.getMessage());
        }
        if (!fileUrls.isEmpty()) {
            for (int i = 0; i < fileUrls.size(); i++) {
                System.out.println("names: " + storeImageVO.getNames()[i] + ", vs: fileUrls: " + fileUrls.get(i) + ", are the same: " + (storeImageVO.getNames()[i].equals(fileUrls.get(i))));
            }
            return fileUrls;
        }
        return null;
    }

    @Override
    public byte[] getImage(String id) {
        return imageRepository.findById(id).get().getImage().getData();
    }

    @Override
    public int testRPC() {
        System.out.println("in testRPC");
        return 9;
    }
}
