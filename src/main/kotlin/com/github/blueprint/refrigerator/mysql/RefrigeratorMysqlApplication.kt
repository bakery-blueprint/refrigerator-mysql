package com.github.blueprint.refrigerator.mysql

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class RefrigeratorMysqlApplication

fun main(args: Array<String>) {
    runApplication<RefrigeratorMysqlApplication>(*args)
}
