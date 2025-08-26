-- Créer un utilisateur admin dans D1 (si aucun n'existe)
INSERT INTO auth_user (
    username, 
    first_name, 
    last_name, 
    email, 
    is_staff, 
    is_active, 
    is_superuser, 
    date_joined, 
    password
) VALUES (
    'admin', 
    'Admin', 
    'MyMarkaz', 
    'admin@mymarkaz.com', 
    1, 
    1, 
    1, 
    datetime('now'), 
    'pbkdf2_sha256$600000$temp$K7UbEWzHjzKMFT8qEWQ1NHFJvBQdN2hO8Fa5wTNZbTo='
);

-- Mot de passe temporaire : "admin123" 
-- CHANGEZ-LE après première connexion !
