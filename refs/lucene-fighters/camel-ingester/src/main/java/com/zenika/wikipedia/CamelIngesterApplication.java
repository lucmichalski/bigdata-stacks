package com.zenika.wikipedia;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Ingest docmuments into search engines using Apache Camel and Spring Boot
 */
@SpringBootApplication
public class CamelIngesterApplication {

    /**
     * A main method to start this application.
     */
    public static void main(String[] args) {
        SpringApplication.run(CamelIngesterApplication.class, args);
    }
}
