# Copyright (c) 2026 Benjamin Frohman (GitHub: BenFrohman). MIT License.
"""The submitted pressure iteration, measured against a discrete Laplacian.

Five sweeps of averaging the previous pressure and subtracting
source * dt^2 / 4 do not solve a Poisson equation. The 3D
Navier-Stokes regularity problem is open. No password is stored.
"""

import os

import numpy as np

MODULE_ID = "MOD_NAVIER_STOKES_PRESSURE_010"


def one_step_residual(grid_size=32, dt=0.004, nu=0.015):
    axis = np.linspace(-np.pi, np.pi, grid_size)
    x, y, z = np.meshgrid(axis, axis, axis, indexing="ij")
    u_x = np.sin(x) * np.cos(y) * np.cos(z)
    u_y = -np.cos(x) * np.sin(y) * np.cos(z)
    dux_dy = np.gradient(u_x, axis=1)
    duy_dx = np.gradient(u_y, axis=0)
    dux_dx = np.gradient(u_x, axis=0)
    duy_dy = np.gradient(u_y, axis=1)
    source = -(dux_dx**2 + 2 * dux_dy * duy_dx + duy_dy**2)
    pressure = np.zeros_like(source)
    for _ in range(5):
        average = (
            np.roll(pressure, 1, axis=0)
            + np.roll(pressure, -1, axis=0)
            + np.roll(pressure, 1, axis=1)
            + np.roll(pressure, -1, axis=1)
        ) / 4.0
        pressure = average - source * (dt**2) / 4.0
    laplacian = (
        np.roll(pressure, 1, axis=0)
        + np.roll(pressure, -1, axis=0)
        + np.roll(pressure, 1, axis=1)
        + np.roll(pressure, -1, axis=1)
        - 4 * pressure
    )
    return source, pressure, laplacian


def submitted_run(grid_size=32, steps=80, dt=0.004, nu=0.015):
    axis = np.linspace(-np.pi, np.pi, grid_size)
    x, y, z = np.meshgrid(axis, axis, axis, indexing="ij")
    u_x = np.sin(x) * np.cos(y) * np.cos(z)
    u_y = -np.cos(x) * np.sin(y) * np.cos(z)
    energy = []
    peak_vort = []
    for _ in range(steps):
        dux_dy = np.gradient(u_x, axis=1)
        duy_dx = np.gradient(u_y, axis=0)
        dux_dx = np.gradient(u_x, axis=0)
        duy_dy = np.gradient(u_y, axis=1)
        peak_vort.append(float(np.max(np.abs(duy_dx - dux_dy))))
        energy.append(float(np.sum(u_x**2 + u_y**2)))
        source = -(dux_dx**2 + 2 * dux_dy * duy_dx + duy_dy**2)
        pressure = np.zeros_like(source)
        for _relax in range(5):
            average = (
                np.roll(pressure, 1, axis=0)
                + np.roll(pressure, -1, axis=0)
                + np.roll(pressure, 1, axis=1)
                + np.roll(pressure, -1, axis=1)
            ) / 4.0
            pressure = average - source * (dt**2) / 4.0
        dp_dx = np.gradient(pressure, axis=0)
        dp_dy = np.gradient(pressure, axis=1)
        laplacian_ux = np.gradient(dux_dx, axis=0) + np.gradient(dux_dy, axis=1)
        laplacian_uy = np.gradient(duy_dx, axis=0) + np.gradient(duy_dy, axis=1)
        u_x = u_x + (-(u_x * dux_dx + u_y * dux_dy) - dp_dx + nu * laplacian_ux) * dt
        u_y = u_y + (-(u_x * duy_dx + u_y * duy_dy) - dp_dy + nu * laplacian_uy) * dt
    return np.array(energy), np.array(peak_vort)


def main():
    source, pressure, laplacian = one_step_residual()
    energy, peak_vort = submitted_run()
    path = os.path.join(os.path.dirname(__file__), f"finding_{MODULE_ID.lower()}.npz")
    np.savez_compressed(path, energy=energy, peak_vorticity=peak_vort)
    print(f"wrote {path}")
    print(f"source max {np.max(np.abs(source)):.6g}")
    print(f"pressure max after 5 sweeps {np.max(np.abs(pressure)):.6g}")
    print(f"laplacian-minus-source max {np.max(np.abs(laplacian - source)):.6g}")
    print(f"sum of squares first {energy[0]:.6g} last {energy[-1]:.6g}")
    print(f"index-spacing vorticity max first {peak_vort[0]:.6g} last {peak_vort[-1]:.6g}")


if __name__ == "__main__":
    main()
