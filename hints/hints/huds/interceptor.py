"""Popup window to intercept keyboard events.

This is a way to work around applications that listen for keyboard
events, which interfere with the keyboard events to perform mouse
movements.

By creting a small window (like 1x1 pixel) over the corner of the taget
application, we can grab keyboard focus thus preventing the target
application from grabbing focus and interfering with the events we are
listening for.
"""

from __future__ import annotations

from typing import Any
from time import time  # <-- WICHTIG: Zeit-Modul importieren

from gi import require_foreign, require_version

from hints.mouse import click, do_mouse_action, move
from hints.mouse_enums import MouseButton, MouseButtonState, MouseMode
from hints.utils import HintsConfig

require_version("Gdk", "3.0")
require_version("Gtk", "3.0")
require_foreign("cairo")

from gi.repository import Gdk, Gtk


class InterceptorWindow(Gtk.Window):
    """Composite widget to overlay hints over a window."""

    def __init__(
        self,
        x_pos: float,
        y_pos: float,
        width: float,
        height: float,
        mouse_action: dict[str, Any],
        config: HintsConfig,
        is_wayland=False,
    ):
        """Hint overlay constructor."""
        super().__init__(Gtk.WindowType.POPUP)

        self.width = width
        self.height = height
        self.mouse_action = mouse_action
        self.config = config
        self.key_press_state: dict[str, Any] = {}
        self.is_wayland = is_wayland
        self.first_move = True

        # --- UNZERSTÖRBARER ZEITSTEMPEL FÜR DIE BREMSE ---
        self.last_ui_move_time = 0.0

        # composite setup
        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        self.set_visual(visual)

        # window setup
        self.set_app_paintable(True)
        self.set_decorated(False)
        self.set_accept_focus(True)
        self.set_sensitive(True)
        self.set_default_size(self.width, self.height)
        self.move(x_pos, y_pos)

        self.connect("destroy", Gtk.main_quit)
        self.connect("key-press-event", self.on_key_press)
        self.connect("key-release-event", self.on_key_release)
        self.connect("show", self.on_grab)

    def on_key_release(self, *_):
        """Handle key releases."""
        self.key_press_state.clear()

    def on_key_press(self, _, event):
        """Handle key presses :param event: Event object."""

        # === START DER RADIKALEN TASTATUR-BREMSE ===
        # 0.1 bedeutet: Maximal 10 Bewegungen pro Sekunde.
        # Setze es zum Testen auf 0.5 (nur 2 Bewegungen pro Sekunde), um den Effekt sofort zu spüren!
        HARD_UI_INTERVAL = 0.01
        current_time = time()

        if current_time - self.last_ui_move_time < HARD_UI_INTERVAL:
            return True  # Event komplett blockieren und verwerfen!

        # Nur wenn das Intervall abgelaufen ist, merken wir uns die neue Zeit
        self.last_ui_move_time = current_time
        # === ENDE DER BREMSE ===

        keymap = Gdk.Keymap.get_for_display(Gdk.Display.get_default())

        # if keyval is bound, keyval, effective_group, level, consumed_modifiers
        _, keyval, _, _, _ = keymap.translate_keyboard_state(
            event.hardware_keycode,
            Gdk.ModifierType(event.state & ~Gdk.ModifierType.LOCK_MASK),
            1,
        )

        keyval_lower = Gdk.keyval_to_lower(keyval)

        if keyval_lower == self.config["exit_key"]:
            click(0, 0, MouseButton.LEFT, (MouseButtonState.UP,), absolute=False)
            Gtk.main_quit()

        if self.first_move:
            # Some window system like Hyprland require mouse movemovement to
            # focus the window being interacted with. So we do a very small move to
            # refocus the window
            move(0, 1, absolute=False)
            move(0, -1, absolute=False)
            self.first_move = False

        if keyval_lower:
            try:
                # chr() fängt Fehler ab, falls Sondertasten gedrückt werden
                key_char = chr(keyval_lower)
            except ValueError:
                key_char = ""

            if key_char:
                match self.mouse_action["action"]:
                    case "grab":
                        self.key_press_state = do_mouse_action(
                            self.key_press_state,
                            key_char,
                            MouseMode.MOVE,
                        )
                    case "scroll":
                        self.key_press_state = do_mouse_action(
                            self.key_press_state,
                            key_char,
                            MouseMode.SCROLL,
                        )

    def on_grab(self, window):
        """Force keyboard grab to listen for keybaord events."""
        if not self.is_wayland:
            Gdk.keyboard_grab(window.get_window(), False, Gdk.CURRENT_TIME)
