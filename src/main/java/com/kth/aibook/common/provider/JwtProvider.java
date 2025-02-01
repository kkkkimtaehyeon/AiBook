package com.kth.aibook.common.provider;

import com.kth.aibook.dto.member.MemberDto;
import com.kth.aibook.entity.member.MemberRole;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;

@Component
public class JwtProvider {
    private Key key;

    @Value("${jwt.secret}")
    private String jwtSecret;

    @Value("${jwt.access-duration}")
    private long accessDuration;

    @Value("${jwt.refresh-duration}")
    private long refreshDuration;

    @PostConstruct
    public void init() {
        byte[] byteSecretKey = Decoders.BASE64.decode(jwtSecret);
        this.key = Keys.hmacShaKeyFor(byteSecretKey);
    }

    public String generateAccessToken(MemberDto memberDto) {
        return generateJwt(memberDto, accessDuration);
    }

    public void validateToken(String token) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token);
        } catch (ExpiredJwtException e) {
            throw new JwtException("토큰이 만료되었습니다.", e);
        } catch (MalformedJwtException e) {
            throw new JwtException("토큰이 변조되었습니다.", e);
        } catch (Exception e) {
            throw new JwtException("토큰을 파싱하는 중 오류가 발생했습니다", e);
        }
    }

    public long getMemberIdFromToken(String token) {
        Claims claims = parseToken(token);
        return Long.parseLong(claims.getSubject());
    }

    public MemberRole getMemberRoleFromToken(String token) {
        Claims claims = parseToken(token);
        return MemberRole.valueOf((String) claims.get("role"));
    }


    private String generateJwt(MemberDto memberDto, long duration) {
        long currentMillis = System.currentTimeMillis();
        return Jwts.builder()
                .setSubject(String.valueOf(memberDto.getMemberId()))
                .claim("role", memberDto.getRole())
                .setIssuedAt(new Date(currentMillis))
                .setExpiration(new Date(currentMillis + duration))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    private Claims parseToken(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
}
