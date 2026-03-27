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

    # Use origin (left/top edges) for both cut candidates and classification.
    # Panes in the same column/row can share the same right/bottom edge (e.g. due
    # to per-pane title bars offsetting origin without changing the far edge), so
    # right/bottom edges are not reliable as cut points.

    # Try vertical cuts (left/right).
    for cut_x in sorted(set(round(s.frame.origin.x) for s in sessions))[:-1]:
        left  = [s for s in sessions if round(s.frame.origin.x) <= cut_x]
        right = [s for s in sessions if round(s.frame.origin.x) >  cut_x]
        if left and right and len(left) + len(right) == len(sessions):
            return ('v', build_split_tree(left), build_split_tree(right))

    # Try horizontal cuts (top/bottom).
    for cut_y in sorted(set(round(s.frame.origin.y) for s in sessions))[:-1]:
        top    = [s for s in sessions if round(s.frame.origin.y) <= cut_y]
        bottom = [s for s in sessions if round(s.frame.origin.y) >  cut_y]
        if top and bottom and len(top) + len(bottom) == len(sessions):
            return ('h', build_split_tree(top), build_split_tree(bottom))

    # Frame data is stale or non-guillotine — can't determine layout from positions.
    # Fall back to a balanced binary tree so assign_sizes distributes space equally.
    print(f"Frame data stale for {len(sessions)} sessions, using fallback equal split:")
    for s in sessions:
        print(f"  {s.name}: grid={s.grid_size} frame={s.frame}")
    mid = len(sessions) // 2
    return ('h', build_split_tree(sessions[:mid]), build_split_tree(sessions[mid:]))


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

        left = min(sessions, key=lambda s: s.frame.origin.x)
        others = [s for s in sessions if s != left]

        # Build the tree for non-pinned panes first.
        others_tree = build_split_tree(others)

        # Derive total character dimensions without pixel conversion and without
        # needing to parse the full session list as a tree.
        # - total_h: the left pane spans the full tab height by definition.
        # - total_w: left pane's current width + others' current width (from their tree).
        def tree_char_w(tree):
            if not isinstance(tree, tuple):
                return tree.grid_size.width
            kind, a, b = tree
            if kind == 'v':
                return tree_char_w(a) + tree_char_w(b)
            return tree_char_w(a)  # 'h': both halves share the same width

        total_h = left.grid_size.height
        total_w = left.grid_size.width + tree_char_w(others_tree)

        sizes = assign_sizes(others_tree, total_w - LEFT_WIDTH, total_h)
        sizes[left] = (LEFT_WIDTH, total_h)

        print(f"total={total_w}x{total_h}  others_tree={others_tree}")
        for session, (sw, sh) in sizes.items():
            print(f"  {session.name}: {sw}x{sh}")
            session.preferred_size = iterm2.Size(sw, sh)

        await tab.async_update_layout()

    await equalize_panes.async_register(connection)


iterm2.run_forever(main)
