#!/usr/bin/env python3
"""
Equalize iTerm2 pane sizes in the current tab.

Runs from: iTerm2 menu → Scripts → equalize_panes
"""

import iterm2


async def main(connection):
    @iterm2.RPC
    async def equalize_panes():
        app = await iterm2.async_get_app(connection)
        window = app.current_terminal_window
        if not window:
            return

        tab = window.current_tab
        sessions = tab.sessions

        if len(sessions) <= 1:
            return

        # Pin the leftmost pane to a narrow fixed width; equalize the rest.
        LEFT_WIDTH = 2  # columns

        left = min(sessions, key=lambda s: s.frame.origin.x)
        others = [s for s in sessions if s != left]

        left.preferred_size = iterm2.Size(LEFT_WIDTH, left.grid_size.height)

        if others:
            sizes = [s.grid_size for s in others]
            avg_w = sum(s.width for s in sizes) // len(sizes)
            avg_h = sum(s.height for s in sizes) // len(sizes)
            target = iterm2.Size(avg_w, avg_h)
            for session in others:
                session.preferred_size = target

        await tab.async_update_layout()

    await equalize_panes.async_register(connection)


iterm2.run_forever(main)
