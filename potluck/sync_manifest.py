# Copyright (c) 2026 Benjamin Frohman (GitHub: BenFrohman). MIT License.
"""Integrate the damped driven Duffing equation and record the run.

The path is not a cubic fourfold. The quantity a^2/2 - b^2/2 + b^4/4 is
not invariant once damping and the driving force are present. No database
password is stored. A PostgreSQL write is attempted only when the
environment variable STABILITY_DB_URI is set.
"""

import asyncio
import json
import os
import time

import numpy as np

DB_URI = os.environ.get("STABILITY_DB_URI", "")


def integrate_duffing(steps=2000, dt=0.01):
    gamma, omega, force = 0.35, 1.2, 0.4
    b_arr = np.zeros(steps)
    a_arr = np.zeros(steps)
    t_arr = np.zeros(steps)
    e_arr = np.zeros(steps)
    b, a, t = -1.5, 0.5, 0.0
    for i in range(steps):
        b, a, t = b + a * dt, a + (b - b**3 - gamma * a + force * np.cos(omega * t)) * dt, t + dt
        b_arr[i], a_arr[i], t_arr[i] = b, a, t
        e_arr[i] = 0.5 * a * a - 0.5 * b * b + 0.25 * b**4
    return b_arr, a_arr, t_arr, e_arr


def write_archive(b_arr, a_arr, e_arr):
    path = os.path.join(os.path.dirname(__file__), "finding_mod_chaos_stability_001.npz")
    np.savez_compressed(path, beta=b_arr, alpha=a_arr, energy=e_arr)
    return path


async def stream_if_configured(b_arr, a_arr, e_arr):
    if not DB_URI:
        return "no STABILITY_DB_URI; database step skipped"
    import asyncpg

    pool = await asyncpg.create_pool(dsn=DB_URI, min_size=1, max_size=2)
    try:
        async with pool.acquire() as conn:
            await conn.execute(
                """
                CREATE TABLE IF NOT EXISTS potluck_attractor_data (
                    step_id BIGINT PRIMARY KEY,
                    beta_slope DOUBLE PRECISION,
                    alpha_scale DOUBLE PRECISION,
                    energy DOUBLE PRECISION
                );
                """
            )
            batch = [(i, float(b_arr[i]), float(a_arr[i]), float(e_arr[i])) for i in range(len(b_arr))]
            await conn.executemany(
                """
                INSERT INTO potluck_attractor_data (step_id, beta_slope, alpha_scale, energy)
                VALUES ($1, $2, $3, $4) ON CONFLICT (step_id) DO NOTHING;
                """,
                batch,
            )
    finally:
        await pool.close()
    return "wrote rows to the configured database"


def record(path, db_status):
    manifest = os.path.join(os.path.dirname(__file__), "potluck_manifest.json")
    modules = []
    if os.path.exists(manifest):
        with open(manifest) as handle:
            modules = json.load(handle)
    modules.append(
        {
            "module_id": "MOD_CHAOS_STABILITY_001",
            "category": "Duffing ODE",
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime()),
            "summary": "Duffing integration. Not a variety and not an invariant energy.",
            "files": [os.path.basename(path)],
            "database": db_status,
        }
    )
    with open(manifest, "w") as handle:
        json.dump(modules, handle, indent=2)


def main():
    b_arr, a_arr, _t_arr, e_arr = integrate_duffing()
    path = write_archive(b_arr, a_arr, e_arr)
    db_status = asyncio.run(stream_if_configured(b_arr, a_arr, e_arr))
    record(path, db_status)
    print(f"wrote {path}")
    print(db_status)
    print(f"energy start {e_arr[0]:.6g} end {e_arr[-1]:.6g}")


if __name__ == "__main__":
    main()
