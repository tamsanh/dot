#!/usr/bin/env python3
"""
Equalize iTerm2 pane sizes in the current tab.

Layout: one narrow left pane (LEFT_WIDTH columns, full height) plus N equal-width
columns each split into a top and bottom pane.

Runs from: iTerm2 menu → Scripts → equalize_panes
"""

import iterm2
from collections import defaultdict

LEFT_WIDTH = 2  # columns for the pinned left pane


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

        left = min(sessions, key=lambda s: s.frame.origin.x)
        others = [s for s in sessions if s != left]
        num_cols = max(len(others) // 2, 1)
        total_h = left.grid_size.height  # left spans full height — always exact

        print(f"sessions={len(sessions)}  others={len(others)}  num_cols={num_cols}  total_h={total_h}")
        print(f"left: grid={left.grid_size.width}x{left.grid_size.height}  frame={left.frame}")
        for s in others:
            print(f"  other '{s.name}': grid={s.grid_size.width}x{s.grid_size.height}  frame={s.frame}")

        # If all panes share the same origin, frame data is stale from a recent
        # layout change. The layout is already equalized; nothing to do.
        origins = set((round(s.frame.origin.x), round(s.frame.origin.y)) for s in others)
        if len(others) > 1 and len(origins) == 1:
            print("Frame data stale — layout already equalized, skipping.")
            return

        # Group others by their column (x-position).
        by_col = defaultdict(list)
        for s in others:
            by_col[round(s.frame.origin.x)].append(s)
        print(f"columns by x: { {x: [s.name for s in p] for x, p in by_col.items()} }")

        # Sum grid widths of one pane per column + the left pane for an exact total_w.
        # Using grid_size avoids any pixel-to-char conversion rounding.
        # Use len(by_col) — not len(others)//2 — as the true column count so that
        # full-height single-pane columns are counted correctly.
        top_panes = [min(panes, key=lambda s: s.frame.origin.y) for panes in by_col.values()]
        total_w = left.grid_size.width + sum(s.grid_size.width for s in top_panes)
        num_actual_cols = len(by_col)
        each_width = max((total_w - LEFT_WIDTH) // num_actual_cols, 1)
        remainder = (total_w - LEFT_WIDTH) - each_width * num_actual_cols
        print(f"total_w={total_w} (left={left.grid_size.width} + cols={[s.grid_size.width for s in top_panes]})")
        print(f"num_cols(pane-count)={num_cols}  num_actual_cols(by-x)={num_actual_cols}")
        print(f"each_width={each_width}  remainder={remainder}  check: {LEFT_WIDTH} + {each_width}*{num_actual_cols} + {remainder} = {LEFT_WIDTH + each_width * num_actual_cols + remainder}  (expected {total_w})")

        left.preferred_size = iterm2.Size(LEFT_WIDTH, total_h)
        print(f"set left '{left.name}' -> {LEFT_WIDTH}x{total_h}")

        # Within each column, assign heights that sum exactly to total_h.
        # The last pane in the column absorbs any remainder from integer division.
        assigned_w_total = LEFT_WIDTH
        for col_i, (x, col_panes) in enumerate(sorted(by_col.items())):
            col_panes.sort(key=lambda s: s.frame.origin.y)
            # Distribute remainder: first `remainder` columns get one extra character.
            col_w = each_width + (1 if col_i < remainder else 0)
            remaining_h = total_h
            assigned_h_total = 0
            for i, pane in enumerate(col_panes):
                h = remaining_h if i == len(col_panes) - 1 else total_h // len(col_panes)
                remaining_h -= h
                assigned_h_total += h
                pane.preferred_size = iterm2.Size(col_w, h)
                print(f"  set '{pane.name}' -> {col_w}x{h}")
            assigned_w_total += col_w
            print(f"  col x={x}: width={col_w}  height sum={assigned_h_total} (expected {total_h})")
        print(f"width sum={assigned_w_total} (expected {total_w})")

        await tab.async_update_layout()

    await equalize_panes.async_register(connection)


iterm2.run_forever(main)
