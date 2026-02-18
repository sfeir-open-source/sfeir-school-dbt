Assets pour l'installateur NSIS
=================================

Placez ici :

1. icon.ico
   - Icône de l'application
   - Format : ICO (Windows Icon)
   - Résolution recommandée : 256x256 pixels
   - Utilisé pour :
     * L'exécutable de l'installateur
     * Les raccourcis créés
     * L'entrée dans "Ajout/Suppression de programmes"

Pour créer un icon.ico à partir d'une image PNG :
- Utilisez un outil en ligne : https://converticon.com
- Ou avec ImageMagick : convert logo.png -resize 256x256 icon.ico

Si aucune icône n'est fournie, NSIS utilisera l'icône par défaut.
