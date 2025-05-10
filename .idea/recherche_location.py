from database import get_connection
from datetime import date

def rechercher_jeux():
    mot_cle = input("🔍 Entrez un mot-clé pour rechercher un jeu : ")

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    query = "SELECT * FROM jeu WHERE nom LIKE %s OR description LIKE %s"
    wildcard = f"%{mot_cle}%"
    cursor.execute(query, (wildcard, wildcard))

    resultats = cursor.fetchall()
    if resultats:
        print("\n🎯 Résultats trouvés :")
        for jeu in resultats:
            print(f"{jeu['id']}. {jeu['nom']} - {jeu['description']} (Stock: {jeu['quantite']})")
    else:
        print("❌ Aucun jeu trouvé.")

    cursor.close()
    conn.close()


def louer_jeu(id_utilisateur):
    id_jeu = input("📦 Entrez l'ID du jeu à louer : ")

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    # Vérifie si le jeu existe et s’il est disponible
    cursor.execute("SELECT * FROM jeu WHERE id = %s", (id_jeu,))
    jeu = cursor.fetchone()

    if jeu and jeu['quantite'] > 0:
        # Ajoute la location
        cursor.execute("""
            INSERT INTO location (id_utilisateur, id_jeu, date_location)
            VALUES (%s, %s, %s)
        """, (id_utilisateur, id_jeu, date.today()))

        # Met à jour le stock
        cursor.execute("UPDATE jeu SET quantite = quantite - 1 WHERE id = %s", (id_jeu,))
        conn.commit()

        print(f"\n✅ '{jeu['nom']}' a été loué avec succès !")
    else:
        print("❌ Ce jeu n'existe pas ou n'est plus disponible.")

    cursor.close()
    conn.close()
