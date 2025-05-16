import mysql.connector
import tkinter as tk
from tkinter import messagebox, Toplevel, ttk

# Connexion MySQL
try:
    conn = mysql.connector.connect(
        host="localhost",
        port=3307,
        user="root",
        password="anaelle",
        database="projetBDA",
        charset='utf8mb4',
        collation='utf8mb4_general_ci',
        use_pure=True
    )
    if conn.is_connected():
        print("--> Connexion réussie à la base de données projetBDA")
except mysql.connector.Error as err:
    print("Erreur de connexion :", err)

def get_connection():
    global conn
    if not conn.is_connected():
        conn.reconnect(attempts=3, delay=2)
    return conn

def louer_jeu(id_user, id_jeu):
    if not id_user or not id_jeu:
        messagebox.showwarning("Champs requis", "Veuillez saisir l'ID utilisateur et l'ID jeu.")
        return
    try:
        conn.rollback()
        conn.start_transaction()
        cursor = get_connection().cursor()
        cursor.callproc("louer_jeu", (int(id_user), int(id_jeu)))
        conn.commit()
        messagebox.showinfo("Succès", f"Le jeu {id_jeu} a bien été loué par l’utilisateur {id_user}.")
    except mysql.connector.Error as err:
        conn.rollback()
        messagebox.showerror("Erreur", str(err))

def retourner_jeu(id_location):
    try:
        conn.rollback()
        conn.start_transaction()
        cursor = get_connection().cursor()
        cursor.callproc("retourner_jeu", (int(id_location),))
        conn.commit()
        messagebox.showinfo("Succès", f"Le jeu lié à la location {id_location} a bien été retourné.")
    except mysql.connector.Error as err:
        conn.rollback()
        messagebox.showerror("Erreur", str(err))

def retourner_location_si_autorise(id_user, id_location):
    try:
        cursor = get_connection().cursor()
        cursor.execute("SELECT id_utilisateur FROM Location WHERE id_location = %s", (int(id_location),))
        result = cursor.fetchone()
        if result and result[0] == id_user:
            retourner_jeu(id_location)
        else:
            messagebox.showwarning("Accès refusé", "Vous ne pouvez retourner que vos propres locations.")
    except mysql.connector.Error as err:
        messagebox.showerror("Erreur", f"Erreur lors de la vérification :\n{err}")



def afficher_jeux_disponibles():
    try:
        cursor = get_connection().cursor()
        cursor.execute("SELECT id_jeu, nom, stock FROM jeux_disponibles")
        resultats = cursor.fetchall()

        fenetre = Toplevel()
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


def afficher_top_jeux():
    try:
        cursor = get_connection().cursor()
        cursor.execute("SELECT nom, note_moyenne, rang, nb_joueurs_min, nb_joueurs_max, age_min FROM top_jeux_notes")
        resultats = cursor.fetchall()

        if not resultats:
            messagebox.showinfo("Aucun résultat", "Aucun jeu avec une note ≥ 8.")
            return

        fenetre = Toplevel()
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
        cursor = get_connection().cursor()
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

        fenetre = Toplevel()
        fenetre.title("Résultat de la recherche")

        tree = ttk.Treeview(fenetre, columns=("Nom", "Description", "Stock", "Note"), show="headings")
        for col in ("Nom", "Description", "Stock", "Note"):
            tree.heading(col, text=col)
            tree.column(col, anchor="center")

        for ligne in resultats:
            tree.insert("", "end", values=ligne)

        tree.pack(expand=True, fill="both")

    except mysql.connector.Error as err:
        messagebox.showerror("Erreur", f"Recherche impossible :\n{err}")




def ajouter_avis(id_jeu, note_moyenne, note_bayesienne, nb_eval):
    try:
        conn.rollback()
        conn.start_transaction()
        cursor = get_connection().cursor()
        cursor.callproc("ajouter_avis", (int(id_jeu), float(note_moyenne), float(note_bayesienne), int(nb_eval)))
        conn.commit()
        messagebox.showinfo("Succès", "Avis ajouté avec succès.")
    except mysql.connector.Error as err:
        conn.rollback()
        messagebox.showerror("Erreur", str(err))

def afficher_historique_utilisateur(id_utilisateur):
    try:
        cursor = get_connection().cursor()
        cursor.execute("""
            SELECT l.id_location, j.nom AS jeu, l.date_location, l.date_retour, l.statut
            FROM Location l
            JOIN Jeu j ON l.id_jeu = j.id_jeu
            WHERE l.id_utilisateur = %s
            ORDER BY l.date_location DESC
        """, (id_utilisateur,))
        resultats = cursor.fetchall()

        if not resultats:
            messagebox.showinfo("Historique", "Aucune location trouvée.")
            return

        fenetre = Toplevel()
        fenetre.title("Mon historique")

        colonnes = ("ID Location", "Jeu", "Début", "Retour", "Statut")
        tree = ttk.Treeview(fenetre, columns=colonnes, show="headings")

        for col in colonnes:
            tree.heading(col, text=col)
            tree.column(col, anchor="center", width=120)

        for ligne in resultats:
            tree.insert("", "end", values=ligne)

        tree.pack(expand=True, fill="both")

    except mysql.connector.Error as err:
        messagebox.showerror("Erreur", f"Erreur lors de l'affichage :\n{err}")



def voir_locations_admin():
    try:
        cursor = get_connection().cursor()
        cursor.execute("CALL voir_locations_admin()")
        resultats = cursor.fetchall()

        fenetre = Toplevel()
        fenetre.title("Toutes les locations")

        tree = ttk.Treeview(fenetre, columns=("ID", "Utilisateur", "Jeu", "Début", "Retour", "Statut"), show="headings")
        for col in ("ID", "Utilisateur", "Jeu", "Début", "Retour", "Statut"):
            tree.heading(col, text=col)

        for ligne in resultats:
            tree.insert("", "end", values=ligne)

        tree.pack(expand=True, fill="both")
    except mysql.connector.Error as err:
        messagebox.showerror("Erreur", f"Erreur lors de la récupération :\n{err}")

def ajouter_jeu():
    def valider():
        try:
            cursor = get_connection().cursor()
            cursor.callproc("ajouter_jeu", (
                entry_nom.get(),
                entry_description.get(),
                int(entry_annee.get()),
                int(entry_jmin.get()),
                int(entry_jmax.get()),
                int(entry_age.get()),
                int(entry_stock.get())
            ))
            conn.commit()
            messagebox.showinfo("Succès", "Jeu ajouté.")
            fenetre.destroy()
        except Exception as err:
            conn.rollback()
            messagebox.showerror("Erreur", str(err))

    fenetre = Toplevel()
    fenetre.title("Ajouter un jeu")

    champs = [("Nom", "entry_nom"), ("Description", "entry_description"), ("Année", "entry_annee"),
              ("Joueurs min", "entry_jmin"), ("Joueurs max", "entry_jmax"), ("Âge min", "entry_age"), ("Stock", "entry_stock")]

    for i, (label, var) in enumerate(champs):
        tk.Label(fenetre, text=label).grid(row=i, column=0)
        globals()[var] = tk.Entry(fenetre)
        globals()[var].grid(row=i, column=1)

    tk.Button(fenetre, text="Valider", command=valider).grid(row=len(champs), columnspan=2, pady=5)

def modifier_jeu():
    def valider():
        try:
            cursor = get_connection().cursor()
            cursor.callproc("modifier_jeu", (
                int(entry_id_jeu.get()),
                entry_nom.get(),
                entry_description.get(),
                int(entry_annee.get()),
                int(entry_jmin.get()),
                int(entry_jmax.get()),
                int(entry_age.get()),
                int(entry_stock.get())
            ))
            conn.commit()
            messagebox.showinfo("Succès", "Jeu modifié.")
            fenetre.destroy()
        except Exception as err:
            conn.rollback()
            messagebox.showerror("Erreur", str(err))

    fenetre = Toplevel()
    fenetre.title("Modifier un jeu")

    champs = [("ID Jeu", "entry_id_jeu"), ("Nom", "entry_nom"), ("Description", "entry_description"),
              ("Année", "entry_annee"), ("Joueurs min", "entry_jmin"), ("Joueurs max", "entry_jmax"),
              ("Âge min", "entry_age"), ("Stock", "entry_stock")]

    for i, (label, var) in enumerate(champs):
        tk.Label(fenetre, text=label).grid(row=i, column=0)
        globals()[var] = tk.Entry(fenetre)
        globals()[var].grid(row=i, column=1)

    tk.Button(fenetre, text="Modifier", command=valider).grid(row=len(champs), columnspan=2, pady=5)

def supprimer_jeu():
    def valider():
        try:
            cursor = get_connection().cursor()
            cursor.callproc("supprimer_jeu", (int(entry_id.get()),))
            conn.commit()
            messagebox.showinfo("Succès", "Jeu supprimé.")
            fenetre.destroy()
        except Exception as err:
            conn.rollback()
            messagebox.showerror("Erreur", str(err))

    fenetre = Toplevel()
    fenetre.title("Supprimer un jeu")

    tk.Label(fenetre, text="ID du jeu à supprimer").grid(row=0, column=0)
    entry_id = tk.Entry(fenetre)
    entry_id.grid(row=0, column=1)

    tk.Button(fenetre, text="Supprimer", command=valider).grid(row=1, columnspan=2, pady=5)

def gestion_utilisateurs():
    try:
        cursor = get_connection().cursor()
        cursor.execute("SELECT id_utilisateur, nom, email, role FROM Utilisateur")
        resultats = cursor.fetchall()

        fenetre = Toplevel()
        fenetre.title("Gestion des utilisateurs")
        fenetre.geometry("600x400")

        colonnes = ("ID", "Nom", "Email", "Rôle")
        tree = ttk.Treeview(fenetre, columns=colonnes, show="headings")

        for col in colonnes:
            tree.heading(col, text=col)
            tree.column(col, width=150, anchor="center")

        for ligne in resultats:
            tree.insert("", "end", values=ligne)

        tree.pack(expand=True, fill="both")

        scrollbar = ttk.Scrollbar(fenetre, orient="vertical", command=tree.yview)
        tree.configure(yscroll=scrollbar.set)
        scrollbar.pack(side="right", fill="y")

        def supprimer_selection():
            selected = tree.selection()
            if not selected:
                messagebox.showwarning("Sélection", "Aucun utilisateur sélectionné.")
                return

            id_utilisateur = tree.item(selected[0])['values'][0]

            if messagebox.askyesno("Confirmation", f"Supprimer l'utilisateur ID {id_utilisateur} ?"):
                try:
                    cursor.execute("DELETE FROM Utilisateur WHERE id_utilisateur = %s", (id_utilisateur,))
                    conn.commit()
                    tree.delete(selected[0])
                    messagebox.showinfo("Succès", "Utilisateur supprimé.")
                except mysql.connector.Error as err:
                    conn.rollback()
                    messagebox.showerror("Erreur", f"Erreur lors de la suppression :\n{err}")

        btn_supprimer = tk.Button(fenetre, text="Supprimer l'utilisateur sélectionné", command=supprimer_selection)
        btn_supprimer.pack(pady=5)

    except mysql.connector.Error as err:
        messagebox.showerror("Erreur", f"Impossible d'afficher les utilisateurs :\n{err}")


def modifier_stock_jeu(id_jeu, nouveau_stock):
    try:
        cursor = get_connection().cursor()
        cursor.callproc("modifier_stock", (int(id_jeu), int(nouveau_stock)))
        conn.commit()
        messagebox.showinfo("Succès", "Stock mis à jour.")
    except mysql.connector.Error as err:
        conn.rollback()
        messagebox.showerror("Erreur", str(err))


def interface_principale(role, id_utilisateur):
    app = tk.Tk()
    app.title("Game4U - Tableau de bord")
    app.geometry("600x700")

    # --- Section : Consultation des jeux ---
    section_consultation = tk.LabelFrame(app, text="Découvrir les jeux", padx=10, pady=10)
    section_consultation.pack(fill="x", padx=10, pady=5)
    tk.Button(section_consultation, text="Jeux disponibles", command=afficher_jeux_disponibles).pack(pady=2)
    tk.Button(section_consultation, text="Jeux les mieux notés", command=afficher_top_jeux).pack(pady=2)
        # Champ de recherche
    frame_recherche = tk.Frame(section_consultation)
    frame_recherche.pack(pady=5)

    global entry_recherche
    entry_recherche = tk.Entry(frame_recherche, width=30)
    entry_recherche.grid(row=0, column=0, padx=5)

    btn_rechercher = tk.Button(frame_recherche, text="Rechercher un jeu", command=rechercher_jeu)
    btn_rechercher.grid(row=0, column=1)



    # --- Section : Location d’un jeu ---
    section_location = tk.LabelFrame(app, text="Louer un jeu", padx=10, pady=10)
    section_location.pack(fill="x", padx=10, pady=5)

    if role == "admin":
        tk.Label(section_location, text="ID Utilisateur").grid(row=0, column=0)
        entry_user_id = tk.Entry(section_location)
        entry_user_id.grid(row=0, column=1)
        user_row = 1
    else:
        user_row = 0  # pas de champ ID utilisateur pour un user

    tk.Label(section_location, text="ID Jeu").grid(row=user_row, column=0)
    entry_jeu_id = tk.Entry(section_location)
    entry_jeu_id.grid(row=user_row, column=1)

    if role == "admin":
        tk.Button(section_location, text="Louer", command=lambda: louer_jeu(entry_user_id.get(), entry_jeu_id.get())).grid(row=user_row+1, columnspan=2, pady=5)
    else:
        tk.Button(section_location, text="Louer", command=lambda: louer_jeu(id_utilisateur, entry_jeu_id.get())).grid(row=user_row+1, columnspan=2)


    # --- Section : Retour d’un jeu ---
    section_retour = tk.LabelFrame(app, text="Retourner un jeu", padx=10, pady=10)
    section_retour.pack(fill="x", padx=10, pady=5)
    tk.Label(section_retour, text="ID Location").grid(row=0, column=0)
    entry_location_id = tk.Entry(section_retour)
    entry_location_id.grid(row=0, column=1)

    if role == "admin":
        tk.Button(section_retour, text="Retourner", command=lambda: retourner_jeu(entry_location_id.get())).grid(row=1, columnspan=2, pady=5)
    else:
        tk.Button(section_retour, text="Retourner", command=lambda: retourner_location_si_autorise(id_utilisateur, entry_location_id.get())).grid(row=1, columnspan=2, pady=5)

    # --- Section : Espace utilisateur ---
    if role == "user":
        section_user = tk.LabelFrame(app, text="Mes actions", padx=10, pady=10)
        section_user.pack(fill="x", padx=10, pady=5)

        def popup_ajout_avis():
            win = Toplevel()
            win.title("Ajouter un avis")
            labels = ["ID Jeu", "Note moyenne", "Note bayésienne", "Nb évaluations"]
            entries = []
            for i, label in enumerate(labels):
                tk.Label(win, text=label).grid(row=i, column=0)
                entry = tk.Entry(win)
                entry.grid(row=i, column=1)
                entries.append(entry)

            def valider():
                ajouter_avis(entries[0].get(), entries[1].get(), entries[2].get(), entries[3].get())
                win.destroy()

            tk.Button(win, text="Envoyer", command=valider).grid(row=len(labels), columnspan=2, pady=5)

        tk.Button(section_user, text="Ajouter un avis", command=popup_ajout_avis).pack(pady=2)
        tk.Button(section_user, text="Voir mes locations", command=lambda: afficher_historique_utilisateur(id_utilisateur)).pack(pady=2)

    # --- Section : Espace admin ---
    if role == "admin":
        section_admin = tk.LabelFrame(app, text="Administration", padx=10, pady=10)
        section_admin.pack(fill="x", padx=10, pady=5)

        def popup_modifier_stock():
            win = Toplevel()
            win.title("Modifier stock")
            tk.Label(win, text="ID Jeu").grid(row=0, column=0)
            tk.Label(win, text="Nouveau stock").grid(row=1, column=0)
            entry1 = tk.Entry(win)
            entry2 = tk.Entry(win)
            entry1.grid(row=0, column=1)
            entry2.grid(row=1, column=1)
            tk.Button(win, text="Valider", command=lambda: modifier_stock_jeu(entry1.get(), entry2.get())).grid(row=2, columnspan=2, pady=5)

        

        tk.Button(section_admin, text="Suivi des locations", command=voir_locations_admin).pack(pady=2)
        tk.Button(section_admin, text="Modifier stock", command=popup_modifier_stock).pack(pady=2)
        tk.Button(section_admin, text="Ajouter un jeu", command=ajouter_jeu).pack(pady=2)
        tk.Button(section_admin, text="Modifier un jeu", command=modifier_jeu).pack(pady=2)
        tk.Button(section_admin, text="Supprimer un jeu", command=supprimer_jeu).pack(pady=2)
        tk.Button(section_admin, text="Gérer utilisateurs", command=gestion_utilisateurs).pack(pady=2)

    app.mainloop()

def page_connexion():
    root = tk.Tk()
    root.title("Game4U - Connexion")
    root.geometry("350x200")

    frame_login = tk.Frame(root, padx=20, pady=20)
    frame_login.pack(expand=True)

    tk.Label(frame_login, text="Nom d'utilisateur").grid(row=0, column=0, sticky="e")
    entry_nom = tk.Entry(frame_login)
    entry_nom.grid(row=0, column=1)

    tk.Label(frame_login, text="Mot de passe").grid(row=1, column=0, sticky="e")
    entry_mdp = tk.Entry(frame_login, show="*")
    entry_mdp.grid(row=1, column=1)

    def se_connecter():
        nom = entry_nom.get()
        mdp = entry_mdp.get()
        try:
            cursor = get_connection().cursor()
            cursor.execute("SELECT id_utilisateur, role FROM Utilisateur WHERE nom = %s AND mot_de_passe = %s", (nom, mdp))
            result = cursor.fetchone()
            if result:
                id_utilisateur, role = result
                messagebox.showinfo("Connexion réussie", f"Connecté en tant que {role}")
                root.destroy()
                interface_principale(role, id_utilisateur)
            else:
                messagebox.showerror("Erreur", "Identifiants incorrects.")
        except mysql.connector.Error as err:
            messagebox.showerror("Erreur", f"Erreur de connexion :\n{err}")

    btn_login = tk.Button(frame_login, text="Se connecter", command=se_connecter)
    btn_login.grid(row=2, columnspan=2, pady=10)

    root.mainloop()

page_connexion()
