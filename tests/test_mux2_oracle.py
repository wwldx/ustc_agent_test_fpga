import pathlib
import sys
import unittest


REPO_ROOT = pathlib.Path(__file__).resolve().parents[1]
ORACLE_DIR = REPO_ROOT / "experiments" / "toy_iverilog_loop" / "oracle"
sys.path.insert(0, str(ORACLE_DIR))

from mux2_oracle import mux2_expected, render_truth_table_markdown, truth_table


class Mux2OracleTests(unittest.TestCase):
    def test_expected_output_matches_mux_behavior(self) -> None:
        self.assertEqual(mux2_expected(0, 1, 0), 0)
        self.assertEqual(mux2_expected(0, 1, 1), 1)
        self.assertEqual(mux2_expected(1, 0, 0), 1)
        self.assertEqual(mux2_expected(1, 0, 1), 0)

    def test_rejects_non_bit_inputs(self) -> None:
        with self.assertRaises(ValueError):
            mux2_expected(2, 0, 0)
        with self.assertRaises(ValueError):
            mux2_expected(0, -1, 0)
        with self.assertRaises(ValueError):
            mux2_expected(0, 0, 3)

    def test_truth_table_has_all_input_combinations(self) -> None:
        rows = truth_table()
        combos = {(row["a"], row["b"], row["sel"]) for row in rows}
        self.assertEqual(len(rows), 8)
        self.assertEqual(len(combos), 8)

    def test_markdown_table_is_stable(self) -> None:
        rendered = render_truth_table_markdown()
        self.assertIn("| a | b | sel | expected_y |", rendered)
        self.assertIn("| 0 | 1 | 1 | 1 |", rendered)


if __name__ == "__main__":
    unittest.main()
