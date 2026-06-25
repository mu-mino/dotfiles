"""Mouse service for hints.

This service is an independent application that hints calls using a Unix
Domain Socket to perform mouse movements by writing to uinput. We use
custom uinput devices to support X11 and Wayland. This is separate from
the main hints application to prevent slowing down the main hints
process when creating virutal devices.
"""

from __future__ import annotations

import socket
from os import path, remove
from pickle import dumps, loads
from signal import SIGINT, signal
from time import sleep, time
from typing import TYPE_CHECKING, Any, Iterable

from evdev import AbsInfo, UInput, ecodes
from gi import require_version

from hints.constants import SOCKET_MESSAGE_SIZE, UNIX_DOMAIN_SOCKET_FILE
from hints.mouse_enums import MouseButton, MouseMode
from hints.utils import load_config

require_version("Gdk", "3.0")
require_version("Gtk", "3.0")
from gi.repository import Gdk, GLib, Gtk

if TYPE_CHECKING:
    from hints.mouse_enums import MouseButtonState

MOUSE_SERVICE_LOOP_MS_INTERVAL = 10
config = load_config()


class Mouse:
    """Mouse class for performing mouse actions (click, hover, move, etc).

    This uses uinput to support both X11 and Wayland.
    """

    def __init__(self, abs_max_width=10000, abs_max_height=10000, write_pause=0.03):
        keys = [button.value for button in MouseButton]
        self.write_pause = write_pause

        # --- MANIPULATIONSSICHERER GLOBALER TIMER ---
        self._global_last_move_time = 0.0

        self.relative_mouse = UInput(
            {
                ecodes.EV_KEY: keys,
                ecodes.EV_REL: [
                    ecodes.REL_X,
                    ecodes.REL_Y,
                    ecodes.REL_HWHEEL,
                    ecodes.REL_WHEEL,
                ],
            },
            name="Hints relative mouse",
        )

        self.absolute_mouse = UInput(
            {
                ecodes.EV_KEY: keys,
                ecodes.EV_ABS: [
                    (
                        ecodes.ABS_X,
                        AbsInfo(
                            value=0,
                            min=0,
                            max=abs_max_width,
                            fuzz=0,
                            flat=0,
                            resolution=0,
                        ),
                    ),
                    (
                        ecodes.ABS_Y,
                        AbsInfo(
                            value=0,
                            min=0,
                            max=abs_max_height,
                            fuzz=0,
                            flat=0,
                            resolution=0,
                        ),
                    ),
                ],
            },
            name="Hints absolute mouse",
        )

    def scroll(self, x: int, y: int, *_args, **_kwargs):
        """Scroll event."""
        self.relative_mouse.write(ecodes.EV_REL, ecodes.REL_HWHEEL, int(x))
        self.relative_mouse.write(ecodes.EV_REL, ecodes.REL_WHEEL, int(y))
        self.relative_mouse.syn()

    def move(self, x: int, y: int, absolute: bool = True):
        """Move event."""
        if absolute:
            self.absolute_mouse.write(ecodes.EV_ABS, ecodes.ABS_X, int(x))
            self.absolute_mouse.write(ecodes.EV_ABS, ecodes.ABS_Y, int(y))
            self.absolute_mouse.syn()
        else:
            self.relative_mouse.write(ecodes.EV_REL, ecodes.REL_X, int(x))
            self.relative_mouse.write(ecodes.EV_REL, ecodes.REL_Y, int(y))
            self.relative_mouse.syn()

        sleep(self.write_pause)

    def click(
        self,
        x: int,
        y: int,
        button: MouseButton,
        button_states: Iterable[MouseButtonState],
        repeat: int = 1,
        absolute: bool = True,
    ):
        """Click event."""
        self.move(x, y, absolute=absolute)

        for _ in range(repeat):
            for button_state in button_states:
                self.relative_mouse.write(ecodes.EV_KEY, button, button_state)
                self.relative_mouse.syn()
                sleep(self.write_pause)

        if absolute:
            self.move(x + 1, y, absolute=True)
            self.move(x - 1, y, absolute=True)

    def do_mouse_action(
        self,
        key_press_state: dict[str, Any],
        key: str,
        mode: MouseMode,
    ):
        """Perform mouse action.

        :param key_press_state: State containing key press event data
            used for ramping up speeds.
        :param key: The key to perform a mouse action for.
        :param mode: The mouse mode.
        """
        # --- ERZWUNGENE SERVER-BREMSE GEGEN TASTATUR-SPAM ---
        # Ändere diesen Wert, um die Pausen-Länge zu steuern (z.B. 0.1 oder 0.4)
        HARD_INTERVAL = 0.2
        current_time = time()

        if current_time - self._global_last_move_time < HARD_INTERVAL:
            return 0  # Event verwerfen, alten Status zurückgeben

        self._global_last_move_time = current_time
        # --- ENDE DER BREMSE ---

        key_press_state.setdefault("start_time", time())

        sensitivity = 1
        rampup_time = 40
        mouse_navigation_action = self.move
        left = "h"
        right = "l"
        up = "k"
        down = "j"

        if mode == MouseMode.MOVE.value:
            sensitivity = 0.01
            rampup_time = 900
            left = config["mouse_move_left"]
            right = config["mouse_move_right"]
            up = config["mouse_move_down"]
            down = config["mouse_move_up"]
            mouse_navigation_action = self.move

        elif mode == MouseMode.SCROLL.value:
            sensitivity = 0.01
            rampup_time = 900
            left = config["mouse_scroll_left"]
            right = config["mouse_scroll_right"]
            up = config["mouse_scroll_up"]
            down = config["mouse_scroll_down"]
            mouse_navigation_action = self.scroll

        key_press_state.setdefault("sensitivity", sensitivity)

        if key == left:
            mouse_navigation_action(-key_press_state["sensitivity"], 0, absolute=False)
        if key == right:
            mouse_navigation_action(key_press_state["sensitivity"], 0, absolute=False)
        if key == up:
            mouse_navigation_action(0, key_press_state["sensitivity"], absolute=False)
        if key == down:
            mouse_navigation_action(0, -key_press_state["sensitivity"], absolute=False)

        return key_press_state


class MouseService:
    """Mouse Service."""

    def __init__(self):
        """Mouse Service Constructor."""
        Gtk.init()

        self.screen = Gdk.Screen.get_default()
        self.mouse = Mouse(self.screen.get_width(), self.screen.get_height())

        if path.exists(UNIX_DOMAIN_SOCKET_FILE):
            remove(UNIX_DOMAIN_SOCKET_FILE)

        self.socket = socket.socket(
            socket.AF_UNIX, socket.SOCK_STREAM | socket.SOCK_NONBLOCK
        )
        self.socket.bind(UNIX_DOMAIN_SOCKET_FILE)
        self.socket.listen(1)
        GLib.timeout_add(MOUSE_SERVICE_LOOP_MS_INTERVAL, self.socket_connection)

        self.screen.connect("size-changed", self.on_size_changed)
        signal(SIGINT, self.on_interrupt)

    def on_interrupt(self, *_):
        """Interrupt handler to clean up."""
        self.socket.close()
        Gtk.main_quit()

    def on_size_changed(self, screen: Gdk.Screen):
        """Screen size change event handler."""
        self.mouse = Mouse(screen.get_width(), screen.get_height())

    def socket_connection(self):
        """Handle socket connection events."""
        try:
            connection, _ = self.socket.accept()
            payload = loads(connection.recv(SOCKET_MESSAGE_SIZE))
            method = payload.get("method", "")
            args = payload.get("args", ())
            kwargs = payload.get("kwargs", {})

            connection.send(
                dumps(
                    {
                        "click": self.mouse.click,
                        "move": self.mouse.move,
                        "scroll": self.mouse.scroll,  # Typo im Original gefixt ("scoll" zu "scroll")
                        "do_mouse_action": self.mouse.do_mouse_action,
                    }[method](*args, **kwargs)
                )
            )
        except BlockingIOError:
            pass

        return GLib.SOURCE_CONTINUE

    def run(self):
        """Run the mouse service."""
        Gtk.main()


def main():
    """Mouse service entry point."""
    MouseService().run()


if __name__ == "__main__":
    main()
