package com.kth.aibook.dto.member;

import com.kth.aibook.entity.member.Member;
import com.kth.aibook.entity.member.MemberRole;
import lombok.Getter;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
public class MemberDetailDto {
    private final Long memberId;
    private final String email;
    private final String nickName;
    private final LocalDate birthDate;
    private final LocalDateTime createdAt;
    private final MemberRole role;

    public MemberDetailDto(Member entity) {
        this.memberId = entity.getId();
        this.email = entity.getEmail();
        this.nickName = entity.getNickName();
        this.birthDate = entity.getBirthDate();
        this.createdAt = entity.getCreatedAt();
        this.role = entity.getRole();
    }

    public MemberDetailDto(Long memberId, String email, String nickName, LocalDate birthDate, LocalDateTime createdAt, MemberRole role) {
        this.memberId = memberId;
        this.email = email;
        this.nickName = nickName;
        this.birthDate = birthDate;
        this.createdAt = createdAt;
        this.role = role;
    }
}
