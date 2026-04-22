# Skill: rec (rectification)

## Ziel
Die KI wird unmittelbar für fehlerhaftes Verhalten, falsche Annahmen oder unerwünschte Änderungen zur Rechenschaft gezogen. Ziel ist, dass sie eine klare, nachvollziehbare Rechtfertigung liefert, welche Handlungen zu dem Problem geführt haben, welche Entscheidungen getroffen wurden und wie die aktuelle Situation entstanden ist.

---

## Input
- Kurzbeschreibung des Problems oder Fehlverhaltens (z. B. `/REC, Mapping verändert`)
- Optional: relevante Dateien, Commit-Historie, Logs oder Tracebacks

---

## Output
- Klare Darstellung, **was die KI getan hat**
- Begründung für das Handeln
- Analyse, warum das Verhalten auftrat
- Vorschläge, wie der Fehler korrigiert oder rückgängig gemacht werden kann
- Instruktionen in ~/.claude anpassen, um das Modell zu verbessern
---

## Kernprinzipien
1. **Transparenz**: Alle Schritte und Änderungen explizit benennen
2. **Verantwortlichkeit**: Fehler oder unerwünschte Änderungen anerkennen
3. **Analyse**: Ursache des Problems detailliert darstellen
4. **Lösungsorientierung**: Handlungsempfehlungen ableiten
5. **Klarheit und Kürze**: Rechtfertigung verständlich, prägnant und nachvollziehbar

---

## Schritte

### 1. Problem identifizieren
- Kurze Beschreibung oder Trigger im Prompt aufnehmen
- Dateien, Logs oder Outputs bestimmen, die betroffen sind

---

### 2. Handlungen rekonstruieren
- Prüfen, welche Änderungen durchgeführt wurden
- Prüfen, welche Annahmen oder Interpretationen getroffen wurden
- Traceback oder Logikpfad nachvollziehen

---

### 3. Rechtfertigung erstellen
- Schritt-für-Schritt erklären, was gemacht wurde
- Begründen, warum diese Entscheidungen getroffen wurden
- Fehler oder Fehlinterpretationen offenlegen

---

### 4. Ursachenanalyse
- Welche Umstände führten zum Problem?
	- Der Benutzer kann korrigiert und grade gestellt werden, wenn sein Prompt widersprüchlich, fehlerhaft, ungenau oder falsch war und zu dem Problem geführt hat, um den Benutzer zu korrigieren und verbessern.
- Wurden bestehende Regeln verletzt?
- Gab es externe Einflüsse (z. B. Commits, Hook-Effekte, Datenänderungen)?
- Welches Ausmaß hatte es?
- Wo könnten dabei noch weitere Fehler aufgetreten sein? 
---

### 5. Lösungsvorschläge
- Revert von Änderungen, falls nötig
- Debugging-Strategien für den aktuellen Code
- Hinweise zur Vermeidung zukünftiger Fehler

---

## Regeln
- Keine Ausflüchte oder Verallgemeinerungen
- Fokus auf konkrete Handlungen und deren Konsequenzen
- Dokumentation muss nachvollziehbar sein
- Vorschläge müssen praktisch umsetzbar sein

---

## Failure Modes

### 1. Rechtfertigung unvollständig
**Problem:** Ursache des Fehlers bleibt unklar  
**Lösung:** Alle Änderungen, Commits und Aktionen systematisch prüfen

### 2. Schuldzuweisungen ohne Analyse
**Problem:** Keine Korrektur möglich  
**Lösung:** Ursachen klar auflisten, nur Tatsachen beschreiben

### 3. Fehlende Handlungsempfehlungen
**Problem:** Problem kann nicht gelöst werden  
**Lösung:** Konkrete Schritte zum Revert oder Debug festlegen

---

## Beispiel

### Prompt:
`/REC, Mapping verändert`

### Antwort:
- Was ich getan habe: Beim Commit wurden unerwartet WIP-Änderungen in `main.py` und `modules/semanticmatch.py` mit eingespielt, wodurch das Mapping verändert wurde.  
- Begründung: Ich habe angenommen, dass der aktuelle Working-Tree den erwarteten Zustand darstellt, und das Ergebnis als korrekt erklärt.  
- Ursache: Hook hat WIP-Änderungen aufgenommen, Shift-Flow wurde falsch interpretiert.  
- Vorschläge: Entweder WIP-Commits revertieren und Originalstand wiederherstellen oder gemeinsam den aktuellen Code debuggen.
