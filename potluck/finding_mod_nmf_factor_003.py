# Copyright (c) 2026 Benjamin Frohman (GitHub: BenFrohman). MIT License.
"""Multiplicative NMF updates on one random nonnegative matrix.

V is not a Mukai pairing. The database step runs only when
STABILITY_DB_URI is set. No password is stored in this file.
"""

import asyncio
import os

import numpy as np

DB_URI = os.environ.get("STABILITY_DB_URI", "")
MODULE_ID = "MOD_NMF_FACTOR_003"


def run_non_negative_matrix_factorization(rows=100, cols=80, rank=10, max_iter=200):
    rng = np.random.default_rng(101)
    v = np.abs(rng.normal(5, 2, (rows, cols)))
    w = np.abs(rng.normal(1, 0.5, (rows, rank)))
    h = np.abs(rng.normal(1, 0.5, (rank, cols)))
    history = []
    for iteration in range(max_iter):
        h = h * ((w.T @ v) / (w.T @ w @ h + 1e-9))
        w = w * ((v @ h.T) / (w @ h @ h.T + 1e-9))
        history.append((iteration, float(np.linalg.norm(v - w @ h, "fro"))))
    return w, h, history


def archive(w, h, history):
    path = os.path.join(os.path.dirname(__file__), f"finding_{MODULE_ID.lower()}.npz")
    np.savez_compressed(path, basis_w=w, coefficient_h=h, error_history=np.array(history))
    return path


async def stream_if_configured(history):
    if not DB_URI:
        return "no STABILITY_DB_URI; database step skipped"
    import asyncpg

    records = [(i, int(step), residual) for i, (step, residual) in enumerate(history)]
    pool = await asyncpg.create_pool(dsn=DB_URI, min_size=1, max_size=2)
    try:
        async with pool.acquire() as conn:
            await conn.execute(
                """
                CREATE TABLE IF NOT EXISTS potluck_nmf_manifest (
                    record_id BIGINT PRIMARY KEY,
                    iteration_step INT,
                    frobenius_residual DOUBLE PRECISION
                );
                """
            )
            await conn.executemany(
                """
                INSERT INTO potluck_nmf_manifest (record_id, iteration_step, frobenius_residual)
                VALUES ($1, $2, $3) ON CONFLICT (record_id) DO NOTHING;
                """,
                records,
            )
    finally:
        await pool.close()
    return "wrote rows to the configured database"


def main():
    w, h, history = run_non_negative_matrix_factorization()
    path = archive(w, h, history)
    status = asyncio.run(stream_if_configured(history))
    print(f"wrote {path}")
    print(f"frobenius first {history[0][1]:.6g} last {history[-1][1]:.6g}")
    print(status)


if __name__ == "__main__":
    main()
