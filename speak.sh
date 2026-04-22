#!/bin/bash
WAV="mic.wav"
TSV="mic.tsv"
CARD="bluez_card.31_11_72_51_E1_F9"
SRC="bluez_input.31_11_72_51_E1_F9.0"
cd /home/muhammed-emin-eser/desk/apps/whisper

cleanup(){
  echo "Aufnahme gestoppt, schalte zurück auf HiFi..."
  pactl set-card-profile "$CARD" a2dp-sink
  trap - INT
  echo "Starte Whisper (nur TSV-Output)..."
  pipenv run whisper --model small --language de --task transcribe \
          --output_format tsv --output_dir . "$WAV"
  echo "Warte auf $TSV..."
  for i in {1..100}; do
    [ -f "$TSV" ] && break
    sleep 0.1
  done
  if [ -f "$TSV" ]; then
    echo "Transkript gefunden."
    sed '1d; s/^\S*\t\S*\t//' "$TSV" | xclip -selection clipboard
    echo "In Zwischenablage kopiert (xclip)."
    rm -f "$WAV" "$TSV"
    echo "Temporäre Dateien entfernt."
    while true; do
      sleep 0.2
      xclip -selection clipboard -o | grep -q . && exit 0
    done
  else
    echo "Kein Transkript gefunden."
    rm -f "$WAV"
  fi
  return 0
}

trap cleanup INT

echo "Aufnahme läuft... Strg+C zum Beenden"

# AUF AIRPODS-MIKRO SCHALTEN
pactl set-card-profile "$CARD" headset-head-unit-msbc

# AUFNEHMEN
ffmpeg -f pulse -i "$SRC" "$WAV"

cleanup