# Skill: Q (Christian)

## Ziel
Schnelles, präzises Traceback von Ausgaben, Code-Teilen oder Funktionen, um zu verstehen, woher ein Wert oder Logeintrag stammt, warum er existiert und unter welchen Bedingungen er erzeugt wird. Ziel ist eine Debugging- und Analysefähigkeit auf Anfrage.

---

## Input
- Prompt mit Q-Tag (z. B. `/Q, Timestamp 00:10`)
- Kontext: Codebase, Logs, Funktionen, Module
- Optional: relevante Variablen, Konfigurationsdateien, Laufzeitbedingungen

---

## Output
- Traceback oder Ablaufbeschreibung
- Ursprung der Ausgabe (Variablen, Funktionen, Module)
- Bedingungen für das Auftreten
- Relevanter Code-Zweig oder Logikpfad
- Optional: Hinweise zur Fehlersuche oder Optimierung

---

## Kernprinzipien
1. **Schnelligkeit**: Direkte Rückverfolgung ohne unnötige Umwege
2. **Genauigkeit**: Alle relevanten Schritte im Ablauf berücksichtigen
3. **Kontextbewusstsein**: Bedingungen und Systemzustand einbeziehen
4. **Strukturiert**: Traceback Schritt-für-Schritt darstellen

---

## Schritte

### 1. Anfrage analysieren
- Extrahiere Zielvariable, Logeintrag oder Funktion aus Prompt
- Identifiziere den relevanten Zeitpunkt / Kontext

---

### 2. Ursprung lokalisieren
- Suche Definitionen, Initialisierungen, Importstellen
- Prüfe Konfigurations- oder Eingabedateien

---

### 3. Code-Pfad zurückverfolgen
- Welche Funktionen, Methoden, oder Module werden durchlaufen?
- Welche Bedingungen (if, loops, Events) müssen erfüllt sein?
- Welche Nebenwirkungen oder globalen Zustände beeinflussen das Ergebnis?

---

### 4. Bedingungen dokumentieren
- Input-Voraussetzungen
- Externe Faktoren (Konfig, Umgebung)
- Logikbedingungen für das Auftreten

---

### 5. Traceback darstellen
- Schritt-für-Schritt Abfolge der Codepfade
- Definitionen und Zuweisungen
- Optional: visuelles Diagramm der Logikpfade

---

### 6. Hinweise und Empfehlungen
- Was könnte Fehler verursachen?
- Welche Teile sind kritisch für das Ergebnis?
- Wie lässt sich die Beobachtung reproduzieren?

---

## Regeln
- Kein bloßes Erraten der Quelle; nur nachvollziehbare Pfade
- Vollständigkeit bevorzugen, aber relevante Details priorisieren
- Kontext der Main-Pipeline beachten
- Jede Entscheidung muss auf Code/Logik basieren
- **Nur aktuellen Code-Zustand analysieren** — keine Git-Historie, Commits oder vergangene Zustände einbeziehen, es sei denn explizit angefragt
- **Scope strikt einhalten** — nur was der Nutzer fragt, keine eigene Deutung oder Bewertung ob das Ergebnis korrekt ist

---

## Failure Modes

### 1. Unklare Eingabe
**Problem:** Traceback unvollständig oder ungenau  
**Lösung:** Input spezifizieren (Variable, Logeintrag, Timestamp)

### 2. Fehlender Kontext
**Problem:** Ursprung kann nicht eindeutig bestimmt werden  
**Lösung:** Relevanten Code/Logdateien bereitstellen

### 3. Übersehen von Bedingungen
**Problem:** Traceback unvollständig  
**Lösung:** Bedingungen explizit prüfen, Pfade analysieren

### 4. Falsche Interpretation
**Problem:** Ergebnis passt nicht zum realen Output  
**Lösung:** Code und Logs systematisch überprüfen, nicht intuitiv schließen

---

## Beispiel

### Prompt:
`/Q, Timestamp 00:10`

### Traceback:
1. Timestamp generiert in `logger.py`, Funktion `log_event()`
2. Bedingung: Event `data_loaded` muss eintreten
3. Codepfad: `main.py → data_loader.load() → logger.log_event()`
4. Definition: `timestamp = datetime.now()` im Log-Modul
5. Ergebnis: Timestamp erscheint nur, wenn Event erfolgreich durchlaufen wurde
