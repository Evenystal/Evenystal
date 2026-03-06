PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS Users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    phone_number TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Role (
    role_id INTEGER PRIMARY KEY AUTOINCREMENT,
    role_name TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS UserRole (
    user_id INTEGER,
    role_id INTEGER,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES Role(role_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Admin (
    user_id INTEGER PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Organizers (
    user_id INTEGER PRIMARY KEY,
    organizer_description TEXT,
    organizer_type TEXT,
    website_url TEXT,
    approval_status TEXT DEFAULT 'pending'
        CHECK(approval_status IN ('pending', 'approved', 'rejected')),
    organizer_photo_url TEXT,
    approved_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Participants (
    user_id INTEGER PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Venues (
    venue_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    location TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Eventtype (
    event_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS Events (
    event_id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_type_id INTEGER,
    venue_id INTEGER,
    organizer_user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    event_description TEXT,
    start_datetime DATETIME,
    end_datetime DATETIME,
    registration_fee REAL,
    event_photo_url TEXT,
    external_registration_url TEXT,
    status TEXT DEFAULT 'draft'
        CHECK(status IN ('draft', 'published', 'cancelled')),
    outsiders_allowed INTEGER DEFAULT 0,
    published_date DATETIME,
    cancelled_date DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_type_id) REFERENCES Eventtype(event_type_id) ON DELETE SET NULL,
    FOREIGN KEY (venue_id) REFERENCES Venues(venue_id) ON DELETE SET NULL,
    FOREIGN KEY (organizer_user_id) REFERENCES Organizers(user_id) ON DELETE CASCADE,
    CHECK (end_datetime > start_datetime)
);

CREATE TABLE IF NOT EXISTS Workshops (
    event_id INTEGER PRIMARY KEY,
    instructor TEXT,
    FOREIGN KEY (event_id) REFERENCES Events(event_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Hackathons (
    event_id INTEGER PRIMARY KEY,
    max_team_size INTEGER,
    min_team_size INTEGER,
    prize_pool REAL,
    FOREIGN KEY (event_id) REFERENCES Events(event_id) ON DELETE CASCADE,
    CHECK (min_team_size <= max_team_size)
);

CREATE TABLE IF NOT EXISTS Interests (
    interest_id INTEGER PRIMARY KEY AUTOINCREMENT,
    participant_user_id INTEGER,
    event_id INTEGER,
    interested_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (participant_user_id) REFERENCES Participants(user_id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Events(event_id) ON DELETE CASCADE,
    UNIQUE(participant_user_id, event_id)
);

CREATE TABLE IF NOT EXISTS Subscriptions (
    subscription_id INTEGER PRIMARY KEY AUTOINCREMENT,
    organizer_user_id INTEGER,
    participant_user_id INTEGER,
    subscribed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (organizer_user_id) REFERENCES Organizers(user_id) ON DELETE CASCADE,
    FOREIGN KEY (participant_user_id) REFERENCES Participants(user_id) ON DELETE CASCADE,
    UNIQUE(organizer_user_id, participant_user_id)
);