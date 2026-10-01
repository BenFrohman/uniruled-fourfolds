# Copyright (c) 2026 Benjamin Frohman (GitHub: BenFrohman). MIT License.
"""Spectral radii of omega*A - d*I for one random matrix.

This is not a stability condition on a variety. The database step runs
only when STABILITY_DB_URI is set. No password is stored in this file.
"""

import asyncio
import os

import numpy as np

DB_URI = os.environ.get("STABILITY_DB_URI", "")
MODULE_ID = "MOD_SPECTRAL_MAP_002"


def compute_operator_spectral_mesh(dimension=20, resolution=25):
    omega_space = np.linspace(-3.0, 3.0, resolution)
    damping_space = np.linspace(0.01, 1.5, resolution)
    spectral_radii = np.zeros((resolution, resolution))
    rng = np.random.default_rng(42)
    base = rng.normal(0, 1, (dimension, dimension))
    eye = np.eye(dimension)
    for i, omega in enumerate(omega_space):
        for j, damping in enumerate(damping_space):
            eigenvalues = np.linalg.eigvals(base * omega - damping * eye)
            spectral_radii[i, j] = np.max(np.abs(eigenvalues))
    return omega_space, damping_space, spectral_radii


def archive(omega, damping, radii):
    path = os.path.join(os.path.dirname(__file__), f"finding_{MODULE_ID.lower()}.npz")
    np.savez_compressed(path, omega=omega, damping=damping, spectral_radii=radii)
    return path


async def stream_if_configured(radii, omega, damping):
    if not DB_URI:
        return "no STABILITY_DB_URI; database step skipped"
    import asyncpg

    records = []
    node = 0
    for i in range(len(omega)):
        for j in range(len(damping)):
            records.append((node, float(omega[i]), float(damping[j]), float(radii[i, j])))
            node += 1
    pool = await asyncpg.create_pool(dsn=DB_URI, min_size=1, max_size=2)
    try:
        async with pool.acquire() as conn:
            await conn.execute(
                """
                CREATE TABLE IF NOT EXISTS potluck_spectral_manifest (
                    node_id BIGINT PRIMARY KEY,
                    omega_parameter DOUBLE PRECISION,
                    damping_parameter DOUBLE PRECISION,
                    max_spectral_radius DOUBLE PRECISION
                );
                """
            )
            await conn.executemany(
                """
                INSERT INTO potluck_spectral_manifest
                (node_id, omega_parameter, damping_parameter, max_spectral_radius)
                VALUES ($1, $2, $3, $4) ON CONFLICT (node_id) DO NOTHING;
                """,
                records,
            )
    finally:
        await pool.close()
    return "wrote rows to the configured database"


def main():
    omega, damping, radii = compute_operator_spectral_mesh()
    path = archive(omega, damping, radii)
    status = asyncio.run(stream_if_configured(radii, omega, damping))
    print(f"wrote {path}")
    print(f"radius min {radii.min():.6g} max {radii.max():.6g}")
    print(status)


if __name__ == "__main__":
    main()
