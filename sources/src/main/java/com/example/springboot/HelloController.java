package com.example.springboot;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;


@RestController
@RequestMapping("/api")
@CrossOrigin
public class HelloController {

	@Value("${spring.datasource.url}")
	private String jdbcURL;

	@GetMapping("/")
	public String index() {
		return "Hello World Demo Angular & Spring Boot!";
	}

	@GetMapping("/message")
	public String message() {
		return "Demo Angular & Spring Boot sent from back";
	}

}
