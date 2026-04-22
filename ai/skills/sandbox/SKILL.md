# Skill: Sandbox

## Ziel
Schnelles Erstellen einer isolierten Testumgebung für Probleme ohne eindeutige beste Lösung, um unterschiedliche Ansätze experimentell zu evaluieren. Fokus liegt darauf, die Performance, Korrektheit oder Eignung von Modulen, Algorithmen oder Modellen in einer realistischen Pipeline-Situation zu prüfen.

---

## Input
- Problemstellung ohne eindeutige beste Lösung
- Element der Sandbox (z. B. Library, Modell, Algorithmus)
- Pipeline-spezifischer Input (Format, Datenstruktur, Testfälle)
- Optional: bestehender Code oder Modul-Grundgerüst

---

## Output
- Testbares Modul oder Skript
- Pipeline-kompatible Anpassung des Inputs
- Ergebnisse/Outputs für Vergleich, Bewertung oder Score
- Dokumentation der Experimente und Beobachtungen

---

## Kernprinzipien
1. **Isolation**: Experimente in eigener Umgebung ohne Seiteneffekte
2. **Pipeline-Realismus**: Input/Output entspricht realem Anwendungsfall
3. **Schnelle Iteration**: Fokus auf Tempo und Vergleichbarkeit der Experimente
4. **Dokumentation**: Schritte und Ergebnisse nachvollziehbar halten

---

## Schritte

### 1. Problem verstehen
- Identifiziere, welche Aspekte experimentell geprüft werden müssen
- Bestimme relevante Metriken (z. B. Accuracy, Score, Performance)

---

### 2. Element der Sandbox auswählen
- Library, Modell, Algorithmus oder andere Variable identifizieren
- Prüfen, welche Varianten getestet werden sollen

---

### 3. Modul aufbauen
- Skript/Modul initial erstellen
- Bibliotheken importieren
- Funktionen für Input-Verarbeitung, Modulanwendung und Output definieren

---

### 4. Pipeline-Input vorbereiten
- Input anpassen, sodass er der realen Pipeline entspricht
- Datenformat, Strukturen, Pfade überprüfen
- Testdaten vorbereiten

---

### 5. Experiment durchführen
- Modul ausführen
- Output prüfen
- Relevante Metriken messen

---

### 6. Ergebnisse dokumentieren
- Beobachtungen festhalten
- Vergleich zwischen Varianten
- Stärken, Schwächen, besondere Fälle notieren

---

### 7. Anpassungen und Iteration
- Parameter, Variablen oder Methoden modifizieren
- Neue Testläufe starten
- Ziel: Bestmöglicher Vergleich innerhalb der Sandbox

---

## Regeln
- Keine direkten Änderungen an der Main-Pipeline
- Pipeline-relevante Outputs müssen überprüfbar sein
- Experimente sollten reproduzierbar sein
- Versionskontrolle oder Snapshots der Sandbox bei größeren Experimenten
- Dokumentation zwingend

---

## Failure Modes

### 1. Input nicht pipeline-konform
**Problem:** Ergebnisse nicht aussagekräftig  
**Lösung:** Input exakt an Pipeline-Format anpassen

### 2. Fehlende Isolation
**Problem:** Experimente beeinflussen Main-Pipeline  
**Lösung:** Sandbox sauber isolieren, evtl. virtuelle Umgebung

### 3. Unvollständige Dokumentation
**Problem:** Vergleichbarkeit der Experimente eingeschränkt  
**Lösung:** Jede Variation und jeden Output festhalten

### 4. Nicht reproduzierbare Ergebnisse
**Problem:** Zufallsfaktoren, Seed nicht fixiert  
**Lösung:** Seed setzen oder deterministische Testbedingungen verwenden

---

## Beispiel

### Problem:
Welches Modell liefert den besten Score für Textklassifikation?

### Sandbox-Element:
- Modelle: ModelA, ModelB

### Pipeline-Input:
- Texte aus der Main-Pipeline
- Gleiche Preprocessing-Schritte wie in der Produktion

### Modul:
- Importiere Modelle
- Bereite Input vor
- Berechne Scores für beide Modelle
- Vergleiche Ergebnisse

### Ergebnis:
- Tabelle mit Scores
- Empfehlung, welches Modell in Main-Pipeline integriert werden sollte
