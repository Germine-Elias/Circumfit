# circumfit_v3

CircumFit est une application mobile  développée dans le cadre d’un projet de fin d'études. Cette application est conçue pour mesurer le tour de taille et calculer le BRI d'un individu.

Dossier lib (Contient les fichiers principaux relatifs aux différentes pages de ) :
    - main.dart : Page d’accueil de l’application.
    - check_detail_page.dart : Page de saisie des informations personnelles (comme la taille).
    - face_profile_photos_page.dart : Page permettant de sélectionner les photos de face et de profil.
    - historique_page.dart : Page historique (à implémenter pour suivre les mesures).
    - about_page.dart : Page d’informations sur l’application.

Dossier measure : app.py et measure_final_.py :API et code Python permettant de calculer le tour de taille. (voir README respectif).

Dossier assets : illustrations et icônes utilisées dans l'application.

Autres dossiers importants

    - build/ : Dossier généré automatiquement contenant les fichiers nécessaires pour la compilation de l’application.
    - test/ : Contient des fichiers de test pour vérifier le bon fonctionnement des différentes fonctionnalités.
    - android/ et ios/ : Dossiers spécifiques aux configurations et déploiements sur les plateformes Android et iOS.

Exécution : Lancer l’application sur un émulateur ou un appareil connecté via Flutter (pour cela, il faut configurer son téléphone en mode développeur https://developer.android.com/studio/debug/dev-options?hl=fr et utiliser un cable usb connecté à l'ordinateur et le smartphone).