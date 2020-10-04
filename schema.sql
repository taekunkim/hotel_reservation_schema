DROP SCHEMA IF EXISTS mydatabase; -- CASCADE;
CREATE SCHEMA mydatabase;
-- SET search_path = mydatabase;
USE mydatabase;

CREATE TABLE guest (
    id_guest SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    address TEXT NOT NULL,
    date_of_birth DATE NOT NULL
);

CREATE TABLE hostess(
    id_hostess SERIAL PRIMARY KEY,
    email TEXT NOT NULL
);

CREATE TABLE property (
    id_property SERIAL PRIMARY KEY,
    id_hostess BIGINT UNSIGNED NOT NULL,
    num_bedroom INTEGER NOT NULL,
    num_bathroom INTEGER NOT NULL,
    capacity INTEGER NOT NULL,
    address TEXT NOT NULL,
    CONSTRAINT capacity_num_bedroom CHECK (capacity >= num_bedroom),
    FOREIGN KEY (id_hostess) REFERENCES hostess (id_hostess)
);

CREATE TABLE luxury (
    id_property BIGINT UNSIGNED NOT NULL,
    hot_tub BOOLEAN NOT NULL,
    sauna BOOLEAN NOT NULL,
    cleaning BOOLEAN NOT NULL,
    breakfast BOOLEAN NOT NULL,
    concierge BOOLEAN NOT NULL,
    FOREIGN KEY (id_property)
        REFERENCES property (id_property)
);

CREATE TABLE city (
    id_property BIGINT UNSIGNED PRIMARY KEY,
    walkability INTEGER NOT NULL,
    closest_transit ENUM('bus', 'LRT', 'subway', 'none') NOT NULL,
    CONSTRAINT walkability_score CHECK (walkability BETWEEN 0 AND 100),
    FOREIGN KEY (id_property)
        REFERENCES property (id_property)
);

CREATE TABLE water (
    id_property BIGINT UNSIGNED NOT NULL,
    water_body ENUM('beach', 'lake', 'pool') NOT NULL,
    lifeguard BOOLEAN NOT NULL,
    PRIMARY KEY (id_property , water_body),
    FOREIGN KEY (id_property)
        REFERENCES property (id_property)
);

CREATE TABLE rental (
    id_rental SERIAL PRIMARY KEY,
    id_property BIGINT UNSIGNED NOT NULL,
    id_renter BIGINT UNSIGNED NOT NULL,
    start_week DATE NOT NULL,
    num_week INTEGER NOT NULL,
    credit_card INTEGER NOT NULL,
    CONSTRAINT saturday_check 
		CHECK (DAYOFWEEK(start_week) = 7),
    FOREIGN KEY (id_property) REFERENCES property (id_property),
    FOREIGN KEY (id_renter) REFERENCES guest (id_guest)
);

CREATE TABLE price (
    id_property BIGINT UNSIGNED NOT NULL,
    week DATE NOT NULL,
    price INTEGER NOT NULL,
    PRIMARY KEY (id_property , week),
    FOREIGN KEY (id_property)
        REFERENCES property (id_property)
);

CREATE TABLE additional_guest (
    id_rental BIGINT UNSIGNED NOT NULL,
    id_guest BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_rental , id_guest),
    FOREIGN KEY (id_rental)
        REFERENCES rental (id_rental),
    FOREIGN KEY (id_guest)
        REFERENCES guest (id_guest)
);

CREATE TABLE rating (
    id_rating SERIAL PRIMARY KEY,
    rating_type ENUM('property', 'hostess'),
    id_guest BIGINT UNSIGNED NOT NULL,
    id_rental BIGINT UNSIGNED NOT NULL,
    star INTEGER NOT NULL,
    FOREIGN KEY (id_guest)
        REFERENCES guest (id_guest),
    FOREIGN KEY (id_rental)
        REFERENCES rental (id_rental),
    CONSTRAINT star_boundary CHECK (star BETWEEN 0 AND 5),
    UNIQUE (rating_type , id_guest , id_rental)
);

CREATE TABLE comment (
    id_rating BIGINT UNSIGNED PRIMARY KEY,
    comment TEXT,
    FOREIGN KEY (id_rating)
        REFERENCES rating (id_rating)
);