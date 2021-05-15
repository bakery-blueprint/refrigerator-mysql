package com.github.blueprint.refrigerator.mysql

import org.junit.jupiter.api.Test
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.TestConstructor

@SpringBootTest
@TestConstructor(autowireMode = TestConstructor.AutowireMode.ALL)
internal class ProductRepositoryTest(private val productRepository: ProductRepository) {

    @Test
    fun selectAllProducts() {
        productRepository.selectAllProducts()
    }
}