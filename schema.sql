-- تراست‌فا — PostgreSQL schema
-- این فایل برای مرجع و init در Docker است.
-- SQLAlchemy هم جداگانه جداول را می‌سازد.

CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    avatar TEXT,
    provider VARCHAR(20) DEFAULT 'email',
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);

CREATE TABLE IF NOT EXISTS businesses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL UNIQUE,
    category VARCHAR(100) DEFAULT 'سایر',
    rating DOUBLE PRECISION DEFAULT 0,
    reviews_count INTEGER DEFAULT 0,
    logo VARCHAR(10),
    color VARCHAR(50) DEFAULT 'bg-slate-500',
    domain VARCHAR(200),
    icon VARCHAR(50) DEFAULT 'fa-store',
    verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_businesses_name ON businesses(name);

CREATE TABLE IF NOT EXISTS reviews (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL REFERENCES users(id),
    business_id INTEGER REFERENCES businesses(id),
    business_name VARCHAR(200) NOT NULL,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title VARCHAR(255) NOT NULL,
    text TEXT NOT NULL,
    helpful INTEGER DEFAULT 0,
    images TEXT DEFAULT '[]',
    hidden BOOLEAN DEFAULT FALSE,
    edited BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_reviews_user ON reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_business ON reviews(business_name);

CREATE TABLE IF NOT EXISTS review_likes (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL REFERENCES users(id),
    review_id INTEGER NOT NULL REFERENCES reviews(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, review_id)
);

CREATE TABLE IF NOT EXISTS review_reports (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL REFERENCES users(id),
    review_id INTEGER NOT NULL REFERENCES reviews(id),
    reason VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, review_id)
);

CREATE TABLE IF NOT EXISTS owned_businesses (
    id VARCHAR(36) PRIMARY KEY,
    owner_id VARCHAR(36) NOT NULL REFERENCES users(id),
    name VARCHAR(200) NOT NULL,
    category VARCHAR(100) DEFAULT 'سایر',
    website VARCHAR(255),
    description TEXT,
    plan VARCHAR(50) DEFAULT 'رایگان',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS contact_messages (
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
