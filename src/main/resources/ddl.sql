CREATE TABLE `member`
(
    `member_id`     BIGINT       NOT NULL AUTO_INCREMENT,
    `email`         VARCHAR(320) NOT NULL,
    `nick_name`     VARCHAR(20)  NOT NULL,
    `birth_date`    DATE         NOT NULL,
    `created_at`    DATETIME     NOT NULL,
    `role`          VARCHAR(20)  NOT NULL,
    oauth_member_id BIGINT NULL,
    primary key (member_id),
    FOREIGN KEY (oauth_member_id) references oauth_member (oauth_member_id)
);
drop table member;

CREATE TABLE oauth_member
(
    oauth_member_id    BIGINT       NOT NULL AUTO_INCREMENT,
    provider           VARCHAR(100) NOT NULL,
    provider_member_id BIGINT       NOT NULL,
    primary key (oauth_member_id)
);

CREATE TABLE story
(
    story_id   BIGINT       NOT NULL AUTO_INCREMENT,
    base_story TEXT         NOT NULL,
    title      VARCHAR(100) NOT NULL,
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_public  TINYINT(1)   NOT NULL DEFAULT FALSE,
    is_dubbed  TINYINT(1)   NOT NULL DEFAULT FALSE,
    view_count BIGINT       NOT NULL DEFAULT 0,
    member_id  BIGINT       NOT NULL,
    PRIMARY KEY (story_id),
    FOREIGN KEY (member_id) REFERENCES member (member_id) ON DELETE CASCADE
);

CREATE TABLE story_page
(
    story_page_id     BIGINT       NOT NULL AUTO_INCREMENT,
    page_number       TINYINT      NOT NULL,
    content           VARCHAR(300) NOT NULL,
    story_id          BIGINT       NOT NULL,
    dubbing_audio_url VARCHAR(300) NULL,
    PRIMARY KEY (story_page_id),
    FOREIGN KEY (story_id) REFERENCES story (story_id) ON DELETE CASCADE
);

CREATE TABLE story_like
(
    story_like_id BIGINT NOT NULL AUTO_INCREMENT,
    member_id     BIGINT NOT NULL,
    story_id      BIGINT NOT NULL,
    PRIMARY KEY (story_like_id),
    FOREIGN KEY (member_id) REFERENCES member (member_id) ON DELETE RESTRICT,
    FOREIGN KEY (story_id) REFERENCES story (story_id) ON DELETE CASCADE
);

CREATE TABLE voice
(
    voice_id   BIGINT       NOT NULL AUTO_INCREMENT,
    name       VARCHAR(20)  NOT NULL,
    audio_url  VARCHAR(500) NOT NULL,
    member_id  BIGINT       NOT NULL,
    deleted_at TIMESTAMP,
    PRIMARY KEY (voice_id),
    FOREIGN KEY (member_id) REFERENCES member (member_id) ON DELETE CASCADE
);

CREATE TABLE story_dubbing
(
    story_dubbing_id BIGINT   NOT NULL AUTO_INCREMENT,
    story_id         BIGINT   NOT NULL,
    voice_id         BIGINT   NOT NULL,
    dubbed_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    member_id        BIGINT   NOT NULL,
    PRIMARY KEY (story_dubbing_id),
    FOREIGN KEY (story_id) REFERENCES story (story_id),
    FOREIGN KEY (voice_id) REFERENCES voice (voice_id),
    FOREIGN KEY (member_id) REFERENCES member (member_id) ON DELETE CASCADE
);

drop table story_dubbing;
CREATE TABLE story_page_dubbing
(
    story_page_dubbing_id BIGINT       NOT NULL AUTO_INCREMENT,
    story_page_id         BIGINT       NOT NULL,
    story_dubbing_id      BIGINT       NOT NULL,
    dubbing_audio_url     VARCHAR(300) NOT NULL,
    PRIMARY KEY (story_page_dubbing_id),
    FOREIGN KEY (story_dubbing_id) REFERENCES story_dubbing (story_dubbing_id),
    FOREIGN KEY (story_page_id) REFERENCES story_page (story_page_id)
);


drop table story_page;
drop table story_like;
drop table story;