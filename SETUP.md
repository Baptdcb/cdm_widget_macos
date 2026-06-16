# Installation & Setup

## Prérequis
- macOS 11+
- Xcode 13+
- Swift 5.5+

## Étapes d'installation

### 1. Cloner le repo
```bash
git clone https://github.com/Baptdcb/cdm_widget_macos.git
cd cdm_widget_macos
```

### 2. Créer le projet Xcode

Puisque les fichiers SwiftUI sont prêts, vous devez créer le structure du projet Xcode:

```bash
# Créer le workspace
mkdir -p CDMWidget.xcodeproj/project.xcworkspace

# Créer la structure des sources
mkdir -p Sources/CDMWidget
mv *.swift Sources/CDMWidget/
```

### 3. Ouvrir dans Xcode

```bash
# Option 1: Ouvrir avec les fichiers existants
open .

# Option 2: Créer un nouveau projet macOS et intégrer les fichiers
# - File > New > Project
# - Choisir "macOS App"
# - Nommer "CDMWidget"
# - Importer les fichiers Swift
```

### 4. Compiler et lancer

```bash
xcodebuild build -scheme CDMWidget -destination 'platform=macOS'
```

## Architecture du projet

- **Models.swift** - Structures de données (Match, Team, Standings)
- **MatchService.swift** - Service de gestion des matchs et favoris
- **CDMWidgetApp.swift** - Point d'entrée de l'application
- **ContentView.swift** - Vue principale avec tab bar
- **MatchesView.swift** - Affichage des matchs (Live, À venir, Terminés)
- **StandingsView.swift** - Affichage des classements
- **FavoritesView.swift** - Gestion des équipes favorites
- **MatchCard.swift** - Composant pour afficher un match
- **LiveMatchesWidget.swift** - Widget pour les matchs en direct
- **UpcomingMatchesWidget.swift** - Widget pour les matchs à venir

## Fonctionnalités

✅ **Matchs en Direct** - Vue en temps réel des scores
✅ **Matchs à Venir** - Calendrier des matchs futurs
✅ **Matchs Terminés** - Résultats archivés
✅ **Classements** - Standings par groupe
✅ **Système de Favoris** - Marquez vos équipes avec sauvegarde locale
✅ **Widgets macOS** - Accès rapide depuis le bureau
✅ **Design natif** - Interface SwiftUI moderne

## Données

Actuellement, l'app utilise des **données mock** pour démonstration.

Pour intégrer une vrai API:

```swift
// Dans MatchService.swift
func fetchRealMatches() async {
    // Remplacer par appel API
    // Exemple: https://api.football-data.org/
}
```

## Prochaines étapes

1. [ ] Intégrer une API de football (RapidAPI, football-data.org)
2. [ ] Ajouter les notifications pour les matchs
3. [ ] Implémenter la synchronisation CloudKit
4. [ ] Ajouter plus de widgets (standings, équipe favori)
5. [ ] Implémenter les statistiques détaillées
6. [ ] Mode sombre amélioré

## Support

Pour des questions ou bugs, ouvrez une issue sur GitHub!
