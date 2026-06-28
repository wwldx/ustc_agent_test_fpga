"""Reference model for the toy mux2 experiment."""

from __future__ import annotations


def mux2_expected(a: int, b: int, sel: int) -> int:
    """Return the expected 1-bit mux output."""
    if a not in (0, 1) or b not in (0, 1) or sel not in (0, 1):
        raise ValueError("mux2 inputs must be 0 or 1")
    return b if sel else a


def truth_table() -> list[dict[str, int]]:
    rows: list[dict[str, int]] = []
    for sel in (0, 1):
        for b in (0, 1):
            for a in (0, 1):
                rows.append(
                    {
                        "a": a,
                        "b": b,
                        "sel": sel,
                        "expected_y": mux2_expected(a, b, sel),
                    }
                )
    return rows


def render_truth_table_markdown() -> str:
    lines = [
        "| a | b | sel | expected_y |",
        "| --- | --- | --- | --- |",
    ]
    for row in truth_table():
        lines.append(
            f"| {row['a']} | {row['b']} | {row['sel']} | {row['expected_y']} |"
        )
    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    print(render_truth_table_markdown(), end="")
