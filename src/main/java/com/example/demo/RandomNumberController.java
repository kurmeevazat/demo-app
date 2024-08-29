package com.example.demo;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.util.Random;

@Controller
public class RandomNumberController {

    @GetMapping("/")
    public String index(Model model) {
        return "index";
    }

    @GetMapping("/generate")
    public String generateRandomNumber(Model model) {
        Random random = new Random();
        int randomNumber = random.nextInt(100) + 1;
        model.addAttribute("randomNumber", randomNumber);
        return "index";
    }
}