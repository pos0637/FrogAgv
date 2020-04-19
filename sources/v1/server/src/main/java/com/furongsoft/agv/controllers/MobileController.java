package com.furongsoft.agv.controllers;

import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1/agv/mobile")
public class MobileController {
    @Data
    @AllArgsConstructor
    private static class Material {
        private String code;
        private String name;
        private int count;
    }

    @GetMapping("/materials")
    public List<Material> getMaterials() {
        List<Material> list = new ArrayList<>();
        for (int i = 0; i < 10; ++i) {
            list.add(new Material("code" + i, "name" + i, 300));
        }

        return list;
    }
}
