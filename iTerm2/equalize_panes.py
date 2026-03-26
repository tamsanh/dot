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

        # Setting all sessions to the same preferred_size gives them equal weight
        # when async_update_layout() redistributes the available space.
        sizes = [s.grid_size for s in sessions]
        avg_w = sum(s.width for s in sizes) // len(sizes)
        avg_h = sum(s.height for s in sizes) // len(sizes)
        target = iterm2.Size(avg_w, avg_h)

        for session in sessions:
            session.preferred_size = target

        await tab.async_update_layout()

    await equalize_panes.async_register(connection)


iterm2.run_forever(main)
