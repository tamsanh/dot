#!/usr/bin/env python3
"""
Equalize iTerm2 pane sizes in the current tab.

Layout: one narrow left pane (LEFT_WIDTH columns, full height) plus N equal-width
columns each split into a top and bottom pane.

Runs from: iTerm2 menu → Scripts → equalize_panes
"""

import os
import iterm2

LEFT_WIDTH = 8  # columns for the pinned left pane


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
        total_h = left.grid_size.height  # left spans full height — always exact

        print(f"sessions={len(sessions)}  others={len(others)}  total_h={total_h}")
        print(
            f"left: grid={left.grid_size.width}x{left.grid_size.height}  frame=({left.frame.origin.x},{left.frame.origin.y})"
        )
        for s in others:
            print(
                f"  '{s.name}': grid={s.grid_size.width}x{s.grid_size.height}  y={s.frame.origin.y}"
            )

        # If all panes share the same origin, frame data is stale.
        origins = set(
            (round(s.frame.origin.x), round(s.frame.origin.y)) for s in others
        )
        if len(others) > 1 and len(origins) == 1:
            print("Frame data stale — skipping.")
            return

        # Split others into top and bottom by y-position.
        # x-coordinates are unreliable (often all 0), but y is stable.
        # All panes at the minimum y are top panes — one per column.
        min_y = min(s.frame.origin.y for s in others)
        top_panes = [s for s in others if round(s.frame.origin.y) == round(min_y)]
        bottom_panes = [s for s in others if round(s.frame.origin.y) != round(min_y)]

        num_cols = len(top_panes)
        top_h = total_h // 2
        bot_h = total_h - top_h  # top_h + bot_h always == total_h

        # total_w from grid sizes (no pixel conversion): left + one top pane per column.
        total_others_w = sum(s.grid_size.width for s in top_panes)
        total_w = left.grid_size.width + total_others_w
        others_w = total_w - LEFT_WIDTH
        each_width = max(others_w // num_cols, 1)
        remainder = others_w - each_width * num_cols  # distribute to first N cols, not left

        print(
            f"num_cols={num_cols}  total_w={total_w}  each_width={each_width}  remainder={remainder}  top_h={top_h}  bot_h={bot_h}"
        )
        print(f"top panes:    {[s.name for s in top_panes]}")
        print(f"bottom panes: {[s.name for s in bottom_panes]}")

        # Apply profile to left pane first, before layout, so font changes
        # don't interfere with the sizing pass. Skip any keys that affect
        # window/pane dimensions — those are controlled by the layout below.
        _DIMENSION_KEYS = {"Columns", "Rows", "Window Type", "Screen", "Space"}
        profiles = await iterm2.Profile.async_get(connection)
        smaller = next((p for p in profiles if p.name == "Smaller"), None)
        if smaller:
            print(f"Applying profile '{smaller.name}' to left pane")
            backing = smaller.local_write_only_copy._LocalWriteOnlyProfile__values
            print(f"  {len(backing)} properties to apply")
            ok, skipped = 0, []
            for key, value in backing.items():
                if key in _DIMENSION_KEYS:
                    print(f"  SKIP (dimension) {key!r}")
                    continue
                try:
                    prop = iterm2.LocalWriteOnlyProfile()
                    prop._LocalWriteOnlyProfile__values[key] = value
                    await left.async_set_profile_properties(prop)
                    ok += 1
                except Exception as e:
                    skipped.append(f"{key!r}: {e}")
            print(f"  applied {ok}, skipped {len(skipped)}")
            for s in skipped:
                print(f"  SKIP {s}")
        else:
            print("Profile 'Smaller' not found")

        # Force left to exactly LEFT_WIDTH; spread remainder into other columns.
        left.preferred_size = iterm2.Size(LEFT_WIDTH, total_h)
        for idx, s in enumerate(top_panes):
            w = each_width + (1 if idx < remainder else 0)
            s.preferred_size = iterm2.Size(w, top_h)
        for idx, s in enumerate(bottom_panes):
            w = each_width + (1 if idx < remainder else 0)
            s.preferred_size = iterm2.Size(w, bot_h)

        print(f"set left -> {LEFT_WIDTH}x{total_h}")

        # Apply twice — iTerm2 sometimes needs a second pass to honour the left width.
        await tab.async_update_layout()
        await tab.async_update_layout()

        path = await left.async_get_variable("path")
        if path:
            await tab.async_set_title(os.path.basename(path))

    await equalize_panes.async_register(connection)


iterm2.run_forever(main)
