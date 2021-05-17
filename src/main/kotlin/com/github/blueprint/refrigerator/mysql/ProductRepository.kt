package com.github.blueprint.refrigerator.mysql

import org.apache.ibatis.session.SqlSession
import org.springframework.stereotype.Repository

@Repository
class ProductRepository(private val sqlSession: SqlSession) {
    fun selectAllProducts(): MutableList<Product> =
        sqlSession.selectList<Product>("mapper.ProductRepository.selectAllProducts")
}

data class Product(var prodId: Long? = null, var prodName: String? = null, var prodPrice: Int? = null)
