# language: fr
Fonctionnalité: Authentification

  Contexte: Utilisateur enregistré 
    Etant donné un compte confirmé pour "john@stif-boiv.info" avec un nom d'utilisateur "john"

    Scénario: Un utilisateur non connecté ne doit pas pouvoir accéder à l'application
      Etant donné que je suis déconnecté
      # Alors je ne dois pas pouvoir visiter la page "d'accueil"