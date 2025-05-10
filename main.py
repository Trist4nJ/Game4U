import mysql.connector
import tkinter as tk
from tkinter import messagebox, Toplevel, ttk

###########################
#        Fonctions        #
###########################


def louer_jeu():
    id_user = entry_user_id.get()
    id_jeu = entry_game_id.get()

    # Vérification de base
    if not id_user or not id_jeu:
        messagebox.showwarning("Champs requis", "Veuillez saisir l'ID utilisateur et l'ID jeu.")
        return

    try:
        conn.start_transaction()
        cursor = conn.cursor()
        cursor.callproc("louer_jeu", (int(id_user), int(id_jeu)))
        conn.commit()
        messagebox.showinfo("Succès", f"Le jeu {id_jeu} a bien été loué par l’utilisateur {id_user}.")

    except mysql.connector.Error as err:
        conn.rollback()
        messagebox.showerror("Erreur", f"Location impossible :\\n{err}")


def retourner_jeu():
    id_location = entry_location_id.get()

    if not id_location:
        messagebox.showwarning("Champ requis", "Veuillez saisir l'ID de la location.")
        return

    try:
        conn.start_transaction()
        cursor = conn.cursor()
        cursor.callproc("retourner_jeu", (int(id_location),))
        conn.commit()
        messagebox.showinfo("Succès", f"Location n°{id_location} bien retournée.")

    except mysql.connector.Error as err:
        conn.rollback()
        messagebox.showerror("Erreur", f"Retour impossible :\\n{err}")


def afficher_jeux_disponibles():
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT id_jeu, nom, stock FROM jeux_disponibles")
        resultats = cursor.fetchall()

        fenetre = Toplevel(root)
        fenetre.title("Jeux disponibles")

        tree = ttk.Treeview(fenetre, columns=("ID", "Nom", "Stock"), show="headings")
        tree.heading("ID", text="ID")
        tree.heading("Nom", text="Nom du jeu")
        tree.heading("Stock", text="Stock")

        for ligne in resultats:
            tree.insert("", "end", values=ligne)

        tree.pack(expand=True, fill="both")

    except mysql.connector.Error as err:
        messagebox.showerror("Erreur", f"Impossible d'afficher les jeux :\\n{err}")


def afficher_historique_client():
    id_user = entry_user_hist.get()

    if not id_user:
        messagebox.showwarning("Champ requis", "Veuillez saisir l'ID utilisateur.")
        return

    try:
        cursor = conn.cursor()
        query = f"""
        SELECT jeu, date_location, date_retour, statut
        FROM historique_par_client
        WHERE utilisateur = (SELECT nom FROM Utilisateur WHERE id_utilisateur = %s)
        """
        cursor.execute(query, (id_user,))
        resultats = cursor.fetchall()

        if not resultats:
            messagebox.showinfo("Aucun résultat", "Aucune location trouvée pour cet utilisateur.")
            return

        fenetre = Toplevel(root)
        fenetre.title(f"Historique de l'utilisateur {id_user}")

        tree = ttk.Treeview(fenetre, columns=("Jeu", "Début", "Retour", "Statut"), show="headings")
        tree.heading("Jeu", text="Jeu")
        tree.heading("Début", text="Date location")
        tree.heading("Retour", text="Date retour")
        tree.heading("Statut", text="Statut")

        for ligne in resultats:
            tree.insert("", "end", values=ligne)

        tree.pack(expand=True, fill="both")

    except mysql.connector.Error as err:
        messagebox.showerror("Erreur", f"Impossible d'afficher l'historique :\\n{err}")


def ajouter_avis():
    id_jeu = entry_avis_id_jeu.get()
    note_moyenne = entry_avis_note.get()
    note_bayesienne = entry_avis_bayes.get()
    nb_eval = entry_avis_eval.get()

    if not (id_jeu and note_moyenne and note_bayesienne and nb_eval):
        messagebox.showwarning("Champs requis", "Veuillez remplir tous les champs pour l'avis.")
        return

    try:
        conn.start_transaction()
        cursor = conn.cursor()
        cursor.callproc("ajouter_avis", (
            int(id_jeu),
            float(note_moyenne),
            float(note_bayesienne),
            int(nb_eval)
        ))
        conn.commit()
        messagebox.showinfo("Succès", f"Avis ajouté pour le jeu {id_jeu}.")

    except mysql.connector.Error as err:
        conn.rollback()
        messagebox.showerror("Erreur", f"Impossible d'ajouter l'avis :\\n{err}")


def afficher_top_jeux():
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT nom, note_moyenne, rang, nb_joueurs_min, nb_joueurs_max, age_min FROM top_jeux_notes")
        resultats = cursor.fetchall()

        if not resultats:
            messagebox.showinfo("Aucun résultat", "Aucun jeu avec une note ≥ 8.")
            return

        fenetre = Toplevel(root)
        fenetre.title("Top jeux (note ≥ 8)")

        tree = ttk.Treeview(fenetre, columns=("Nom", "Note", "Rang", "Joueurs", "Âge"), show="headings")
        tree.heading("Nom", text="Nom du jeu")
        tree.heading("Note", text="Note Moyenne")
        tree.heading("Rang", text="Rang")
        tree.heading("Joueurs", text="Joueurs")
        tree.heading("Âge", text="Âge min")

        for jeu in resultats:
            nom, note, rang, jmin, jmax, age = jeu
            tree.insert("", "end", values=(nom, note, rang, f"{jmin}-{jmax}", age))

        tree.pack(expand=True, fill="both")

    except mysql.connector.Error as err:
        messagebox.showerror("Erreur", f"Impossible d'afficher les top jeux :\\n{err}")

def rechercher_jeu():
    mot_cle = entry_recherche.get()

    if not mot_cle:
        messagebox.showwarning("Champ vide", "Veuillez saisir un mot-clé.")
        return

    try:
        cursor = conn.cursor()
        query = """
        SELECT j.nom, j.description_jeu, j.stock, IFNULL(a.note_moyenne, 'Aucune') AS note
        FROM Jeu j
        LEFT JOIN Avis a ON j.id_jeu = a.id_jeu
        WHERE j.nom LIKE %s
        """
        cursor.execute(query, (f"%{mot_cle}%",))
        resultats = cursor.fetchall()

        if not resultats:
            messagebox.showinfo("Aucun résultat", "Aucun jeu trouvé avec ce mot-clé.")
            return

        fenetre = Toplevel(root)
        fenetre.title("Résultat de la recherche")

        tree = ttk.Treeview(fenetre, columns=("Nom", "Description", "Stock", "Note"), show="headings")
        tree.heading("Nom", text="Nom du jeu")
        tree.heading("Description", text="Description")
        tree.heading("Stock", text="Stock")
        tree.heading("Note", text="Note Moyenne")

        for ligne in resultats:
            tree.insert("", "end", values=ligne)

        tree.pack(expand=True, fill="both")

    except mysql.connector.Error as err:
        messagebox.showerror("Erreur", f"Recherche impossible :\\n{err}")


###########################
#   connexion BDD MySQL   #
###########################

try:
    conn = mysql.connector.connect(
        host="localhost",
        port=3307, #remplace par le port sur lequel ça tourne
        user="root",
        password="ton-mdp",  # remplace par ton mot de passe MySQL
        database="projetBDA",    
        charset='utf8mb4',
        collation='utf8mb4_general_ci',
        use_pure=True
    )

    if conn.is_connected():
        print("-->Connexion à la base projetBDA réussie !")

except mysql.connector.Error as err:
    print("Erreur :", err)



###########################
#     fenetres Tkinter    #
###########################
# Interface graphique
root = tk.Tk()
root.title("Game4U - Gestion de ludothèque")
root.geometry("400x800")

# Définition des frames pour structurer l’interface
frame_location = tk.LabelFrame(root, text="Louer un jeu", padx=10, pady=10)
frame_location.pack(padx=10, pady=5, fill="x")

frame_return = tk.LabelFrame(root, text="Retourner un jeu", padx=10, pady=10)
frame_return.pack(padx=10, pady=5, fill="x")

frame_vues = tk.LabelFrame(root, text="Afficher des jeux", padx=10, pady=10)
frame_vues.pack(padx=10, pady=5, fill="x")

frame_historique = tk.LabelFrame(root, text="Historique utilisateur", padx=10, pady=10)
frame_historique.pack(padx=10, pady=5, fill="x")

frame_avis = tk.LabelFrame(root, text="Ajouter un avis", padx=10, pady=10)
frame_avis.pack(padx=10, pady=5, fill="x")

frame_recherche = tk.LabelFrame(root, text="Rechercher un jeu", padx=10, pady=10)
frame_recherche.pack(padx=10, pady=5, fill="x")

# Champs louer un jeu
entry_user_id = tk.Entry(frame_location, width=10)
entry_user_id.grid(row=0, column=1)
tk.Label(frame_location, text="ID Utilisateur").grid(row=0, column=0)

entry_game_id = tk.Entry(frame_location, width=10)
entry_game_id.grid(row=1, column=1)
tk.Label(frame_location, text="ID Jeu à louer").grid(row=1, column=0)

tk.Button(frame_location, text="Louer un jeu", command=louer_jeu).grid(row=2, columnspan=2, pady=5)

# Champs retourner un jeu
entry_location_id = tk.Entry(frame_return, width=10)
entry_location_id.grid(row=0, column=1)
tk.Label(frame_return, text="ID Location à retourner").grid(row=0, column=0)

tk.Button(frame_return, text="Retourner un jeu", command=retourner_jeu).grid(row=1, columnspan=2, pady=5)

# Boutons vues
btn_dispo = tk.Button(frame_vues, text="Afficher les jeux disponibles", command=afficher_jeux_disponibles)
btn_dispo.pack(pady=2)

btn_top = tk.Button(frame_vues, text="Afficher les top jeux (note ≥ 8)", command=afficher_top_jeux)
btn_top.pack(pady=2)

# Historique utilisateur
entry_user_hist = tk.Entry(frame_historique, width=10)
entry_user_hist.grid(row=0, column=1)
tk.Label(frame_historique, text="ID Utilisateur").grid(row=0, column=0)

tk.Button(frame_historique, text="Voir historique du client", command=afficher_historique_client).grid(row=1, columnspan=2, pady=5)

# Ajouter un avis
entry_avis_id_jeu = tk.Entry(frame_avis, width=10)
entry_avis_id_jeu.grid(row=0, column=1)
tk.Label(frame_avis, text="ID Jeu (avis)").grid(row=0, column=0)

entry_avis_note = tk.Entry(frame_avis, width=10)
entry_avis_note.grid(row=1, column=1)
tk.Label(frame_avis, text="Note Moyenne").grid(row=1, column=0)

entry_avis_bayes = tk.Entry(frame_avis, width=10)
entry_avis_bayes.grid(row=2, column=1)
tk.Label(frame_avis, text="Note Bayésienne").grid(row=2, column=0)

entry_avis_eval = tk.Entry(frame_avis, width=10)
entry_avis_eval.grid(row=3, column=1)
tk.Label(frame_avis, text="Nombre évaluations").grid(row=3, column=0)

tk.Button(frame_avis, text="Ajouter un avis", command=ajouter_avis).grid(row=4, columnspan=2, pady=5)

# Rechercher un jeu
entry_recherche = tk.Entry(frame_recherche, width=20)
entry_recherche.grid(row=0, column=1)
tk.Label(frame_recherche, text="Mot-clé").grid(row=0, column=0)

tk.Button(frame_recherche, text="Rechercher un jeu", command=rechercher_jeu).grid(row=1, columnspan=2, pady=5)

root.mainloop()
