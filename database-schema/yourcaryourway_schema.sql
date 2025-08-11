-- =========================================================
-- Script SQL pour la base de données "Your Car Your Way App"
-- =========================================================

-- Table des utilisateurs (clients, agents, administrateurs)
-- Représente les entités "User" du schéma conceptuel.
CREATE TABLE users (
    id CHAR(36) PRIMARY KEY,
    firstname VARCHAR(100) NOT NULL,
    lastname VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    birthdate DATE NOT NULL,
    address TEXT,
    role ENUM('CLIENT', 'AGENT', 'ADMIN') NOT NULL
);

-- Table des agences
-- Représente les entités "Agency" où sont gérés les véhicules.
CREATE TABLE agencies (
    id CHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    address TEXT NOT NULL
);

-- Table des véhicules
-- Représente les entités "Vehicle" rattachées à une agence.
CREATE TABLE vehicles (
    id CHAR(36) PRIMARY KEY,
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    brand VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    category ENUM('MCMR', 'CDMR', 'FVMR') NOT NULL,
    available BOOLEAN NOT NULL DEFAULT TRUE,
    agency_id CHAR(36),
    FOREIGN KEY (agency_id) REFERENCES agencies(id)
);

-- Table des offres de location
-- Représente les entités "Rental Offer" correspondant aux véhicules disponibles
CREATE TABLE rental_offers (
    id CHAR(36) PRIMARY KEY,
    vehicle_id CHAR(36) NOT NULL,
    start_city VARCHAR(100) NOT NULL,
    end_city VARCHAR(100) NOT NULL,
    start_datetime DATETIME NOT NULL,
    end_datetime DATETIME NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id)
);

-- Table des réservations
-- Représente les entités "Reservation" faites par les utilisateurs sur des offres.
CREATE TABLE reservations (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    rental_offer_id CHAR(36) NOT NULL,
    reservation_date DATETIME NOT NULL,
    status ENUM('CONFIRMED', 'CANCELLED', 'PENDING') NOT NULL,
    payment_reference VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (rental_offer_id) REFERENCES rental_offers(id)
);


-- Table des fils de discussion du support client
-- Représente les entités "Support Thread" permettant le suivi d'un échange avec un agent.
CREATE TABLE support_threads (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    agent_id CHAR(36),
    created_at DATETIME NOT NULL,
    closed BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (agent_id) REFERENCES users(id)
);

-- Table des messages du support
-- Représente les entités "Message" échangées dans un support thread.
CREATE TABLE messages (
    id CHAR(36) PRIMARY KEY,
    thread_id CHAR(36) NOT NULL,
    sender_id CHAR(36) NOT NULL,
    content TEXT NOT NULL,
    sent_at DATETIME NOT NULL,
    FOREIGN KEY (thread_id) REFERENCES support_threads(id),
    FOREIGN KEY (sender_id) REFERENCES users(id)
);
