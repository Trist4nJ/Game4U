from database import get_connection

def se_connecter():
    email = input("📧 Email : ")
    mdp = input("🔒 Mot de passe : ")

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM Utilisateur WHERE email=%s AND mot_de_passe=%s", (email, mdp))
    user = cursor.fetchone()

    cursor.close()
    conn.close()

    if user:
        print(f"\n✅ Connecté : {user['nom']} ({user['role']})")
        return user
    else:
        print("\n❌ Identifiants incorrects.")
        return None
