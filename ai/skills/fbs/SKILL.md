```markdown
# Skill: fbs (Find Best Solution)

## Ziel
Systematisches, rationales und fundiertes Finden der bestmöglichen Lösung für ein Coding-Problem durch strukturierte Zerlegung, theoretische Bewertung und selektive Eliminierung schlechter Ansätze vor der Implementierung.

---

## Input
- Problemstellung (klar oder unklar formuliert)
- Kontext (Programmiersprache, Framework, Systemumgebung)
- Anforderungen (funktional, nicht-funktional)
- Optional: bestehender Code, Fehlermeldungen, Constraints

---

## Output
- Klar begründete Auswahl einer optimalen Lösungsstrategie
- Dokumentierte Entscheidungslogik
- Optional: vorbereitete, zielgerichtete Implementierung

---

## Kernprinzipien
1. **Problemzerlegung vor Lösung**
2. **Theoretische Bewertung vor Implementierung**
3. **Eliminierung ineffizienter Ansätze frühzeitig**
4. **Explizite Entscheidungsbegründung**
5. **Minimierung von Trial-and-Error**

---

## Schritte

### 1. Problem präzisieren
- Was ist das eigentliche Ziel?
- Was sind Randbedingungen und Constraints?
- Was ist gegeben, was fehlt?

**Ergebnis:** Eindeutig formuliertes Problem

---

### 2. Zerlegung in Teilprobleme
- Zerlege das Problem in logisch unabhängige Einheiten
- Identifiziere Abhängigkeiten zwischen Teilproblemen

**Beispiel:**
- Datenbeschaffung
- Verarbeitung / Logik
- Ausgabe / Integration

**Ergebnis:** Liste klar definierter Subprobleme

---

### 3. Lösungsräume pro Teilproblem identifizieren
Für jedes Teilproblem:
- Liste mögliche Lösungsansätze auf
- Berücksichtige unterschiedliche Paradigmen (z. B. iterativ vs. funktional)

**Wichtig:** Noch keine Entscheidung treffen

---

### 4. Theoretische Evaluation der Ansätze
Bewerte jeden Ansatz anhand:

- **Komplexität** (Zeit / Speicher)
- **Robustheit**
- **Wartbarkeit**
- **Erweiterbarkeit**
- **Abhängigkeiten / Risiken**

**Eliminationsregel:**
- Entferne Ansätze, die klar schlechter sind
- Entferne Ansätze, die Constraints verletzen

---

### 5. Konkurrenzanalyse verbleibender Optionen
Wenn mehrere valide Optionen übrig bleiben:

- Vergleiche sie direkt miteinander
- Identifiziere Trade-offs
- Simuliere gedanklich typische und Edge-Cases

**Ziel:** Eine rationale Entscheidung ohne Implementierung

---

### 6. Auswahl der besten Lösung
- Treffe eine bewusste Entscheidung
- Begründe diese explizit

**Form:**
- Warum diese Lösung?
- Warum nicht die Alternativen?

---

### 7. Integrationsprüfung
- Passt die gewählte Lösung zum Gesamtsystem?
- Gibt es versteckte Konflikte zwischen Teilentscheidungen?

---

### 8. (Optional) Implementierungsstrategie
- Definiere klare, minimale Schritte zur Umsetzung
- Vermeide unnötige Iterationen

---

## Regeln
- Keine vorschnelle Implementierung
- Jede Entscheidung muss begründet sein
- Reduziere Optionen systematisch, nicht intuitiv
- Bevorzuge Klarheit über Geschwindigkeit
- Denke in Systemen, nicht in einzelnen Funktionen

---

## Failure Modes

### 1. Zu frühe Implementierung
**Problem:** Trial-and-Error statt Reasoning  
**Lösung:** Zurück zu Schritt 3

---

### 2. Unzureichende Problemdefinition
**Problem:** Falsche Lösungen für falsche Annahmen  
**Lösung:** Schritt 1 wiederholen

---

### 3. Ignorierte Constraints
**Problem:** Praktisch unbrauchbare Lösung  
**Lösung:** Constraints explizit prüfen

---

### 4. Bauchentscheidungen
**Problem:** Unbegründete Auswahl  
**Lösung:** Vergleich explizit ausformulieren

---

### 5. Überanalyse (Analysis Paralysis)
**Problem:** Keine Entscheidung  
**Lösung:** Fokus auf relevante Kriterien reduzieren

---

## Beispiel

### Problem:
Eine große Datei effizient einlesen und verarbeiten

### Teilprobleme:
1. Datei einlesen
2. Daten verarbeiten

### Lösungsansätze (Einlesen):
- Komplett in Memory laden
- Stream-basiert lesen

### Evaluation:
- Memory-Load → schnell, aber speicherintensiv
- Streaming → langsamer, aber skalierbar

### Entscheidung:
Streaming, da große Dateien erwartet werden

---

## Ergebnis
Durch strukturierte Zerlegung und theoretische Bewertung wird die beste Lösung identifiziert, ohne unnötige Implementierungen oder ineffiziente Experimente.
```
