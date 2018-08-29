package com.ipt.web.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ipt.web.model.LoginUser;

@Repository
public interface UserRepository extends JpaRepository<LoginUser, Long> {
    LoginUser findByUsername(String username);
}
