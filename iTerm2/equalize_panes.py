#!/usr/bin/env python3
"""
Equalize iTerm2 pane sizes in the current tab.

Runs from: iTerm2 menu → Scripts → equalize_panes
"""

import iterm2


def build_split_tree(sessions):
    """
    Reconstruct the binary split tree from pixel frame data.
    Returns a session (leaf) or ('v'|'h', subtree_a, subtree_b).

    iTerm2 always produces a binary guillotine-cut layout, so there is always
    a straight cut that partitions any group of panes into two non-overlapping
    halves — we just have to find it.

    Both sides are classified by right/bottom edge rather than origin, so that
    subpixel rounding differences between adjacent panes don't cause misclassification.
    """
    if len(sessions) == 1:
        return sessions[0]

    # Try vertical cuts (left/right) in left-to-right order.
    for cut_x in sorted(set(round(s.frame.origin.x + s.frame.size.width) for s in sessions))[:-1]:
        left  = [s for s in sessions if round(s.frame.origin.x + s.frame.size.width) <= cut_x]
        right = [s for s in sessions if round(s.frame.origin.x + s.frame.size.width) >  cut_x]
        if left and right and len(left) + len(right) == len(sessions):
            return ('v', build_split_tree(left), build_split_tree(right))

    # Try horizontal cuts (top/bottom) in top-to-bottom order.
    for cut_y in sorted(set(round(s.frame.origin.y + s.frame.size.height) for s in sessions))[:-1]:
        top    = [s for s in sessions if round(s.frame.origin.y + s.frame.size.height) <= cut_y]
        bottom = [s for s in sessions if round(s.frame.origin.y + s.frame.size.height) >  cut_y]
        if top and bottom and len(top) + len(bottom) == len(sessions):
            return ('h', build_split_tree(top), build_split_tree(bottom))

    print(f"No valid split found for {len(sessions)} sessions:")
    for s in sessions:
        print(f"  {s.name}: frame={s.frame}")
    raise ValueError(f"No valid split found for {len(sessions)} sessions")


def col_count(tree):
    """Number of equal-width columns in this subtree."""
    if not isinstance(tree, tuple):
        return 1
    if tree[0] == 'v':
        return col_count(tree[1]) + col_count(tree[2])
    # 'h': both halves occupy the same column width
    return col_count(tree[1])


def row_count(tree):
    """Number of equal-height rows in this subtree."""
    if not isinstance(tree, tuple):
        return 1
    if tree[0] == 'h':
        return row_count(tree[1]) + row_count(tree[2])
    # 'v': both halves occupy the same row height
    return row_count(tree[1])


def assign_sizes(tree, w, h):
    """
    Recursively assign equal sizes within the given w×h character budget.
    At each 'v' split the width is divided proportionally to column count;
    at each 'h' split the height is divided proportionally to row count.
    Returns {session: (w, h)}.
    """
    if not isinstance(tree, tuple):
        return {tree: (w, h)}

    kind, a, b = tree
    if kind == 'v':
        ca, cb = col_count(a), col_count(b)
        wa = w * ca // (ca + cb)
        return {**assign_sizes(a, wa, h), **assign_sizes(b, w - wa, h)}
    else:  # 'h'
        ra, rb = row_count(a), row_count(b)
        ha = h * ra // (ra + rb)
        return {**assign_sizes(a, w, ha), **assign_sizes(b, w, h - ha)}


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

        LEFT_WIDTH = 2  # columns to pin the leftmost pane to

        # Derive chars-per-pixel from the first session (uniform within a window).
        ref = sessions[0]
        char_w = ref.grid_size.width / ref.frame.size.width
        char_h = ref.grid_size.height / ref.frame.size.height

        total_w = round(max(s.frame.origin.x + s.frame.size.width for s in sessions) * char_w)
        total_h = round(max(s.frame.origin.y + s.frame.size.height for s in sessions) * char_h)

        left = min(sessions, key=lambda s: s.frame.origin.x)
        others = [s for s in sessions if s != left]

        # Build and equalize the tree for the non-pinned panes.
        others_tree = build_split_tree(others)
        sizes = assign_sizes(others_tree, total_w - LEFT_WIDTH, total_h)
        sizes[left] = (LEFT_WIDTH, total_h)

        print(f"total={total_w}x{total_h}  others_tree={others_tree}")
        for session, (sw, sh) in sizes.items():
            print(f"  {session.name}: {sw}x{sh}")
            session.preferred_size = iterm2.Size(sw, sh)

        await tab.async_update_layout()

    await equalize_panes.async_register(connection)


iterm2.run_forever(main)
