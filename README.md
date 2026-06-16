# CDM Widget macOS

Une app macOS SwiftUI pour suivre les matchs de la Coupe du Monde en temps réel avec widgets et tab bar.

## Fonctionnalités

- 📊 **Tab Bar Navigation**: Matchs, Standings, Favoris
- 🔔 **Widgets macOS**: Accès rapide aux matchs en cours et à venir
- ⭐ **Système de Favoris**: Marquez vos équipes préférées
- 📱 **Design Natif macOS**: Interface moderne avec SwiftUI

## Architecture

```
CDMWidget/
├── App/
│   └── CDMWidgetApp.swift
├── Models/
│   ├── Match.swift
│   ├── Team.swift
│   └── Standings.swift
├── Views/
│   ├── ContentView.swift
│   ├── Tabs/
│   │   ├── MatchesView.swift
│   │   ├── StandingsView.swift
│   │   └── FavoritesView.swift
│   └── Components/
│       ├── MatchCard.swift
│       └── TeamCard.swift
├── Services/
│   └── MatchService.swift
└── Widgets/
    ├── MatchWidget.swift
    └── UpcomingMatchesWidget.swift
```

## Développement

```bash
# Ouvrir le projet
open CDMWidget.xcodeproj

# Builder
xcodebuild build -scheme CDMWidget -destination 'platform=macOS'

# Tester
xcodebuild test -scheme CDMWidget
```

## Données

Les données utilisées sont des données mock pour démonstration. Vous pouvez les remplacer avec une API réelle comme:
- FIFA World Cup API
- RapidAPI Football

## License

MIT
