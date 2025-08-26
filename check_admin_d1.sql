-- Vérifier s'il y a un utilisateur admin dans D1
SELECT id, username, email, is_superuser FROM auth_user WHERE is_superuser = 1;

-- Si aucun résultat, créer un utilisateur admin
-- (Copier ces commandes une par une SEULEMENT si pas d'admin trouvé)

-- INSERT INTO auth_user (username, first_name, last_name, email, is_staff, is_active, is_superuser, date_joined, password) 
-- VALUES ('admin', 'Admin', 'MyMarkaz', 'admin@mymarkaz.com', 1, 1, 1, datetime('now'), 'pbkdf2_sha256$600000$PLACEHOLDER$hashplaceholder');

-- Note: Vous devrez générer un vrai hash de mot de passe avec Django
