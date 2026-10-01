# Copyright (c) 2026 Benjamin Frohman (GitHub: BenFrohman). MIT License.
"""Taylor-Green data and the submitted two-component update.

The 3D incompressible Navier-Stokes regularity problem is open.
This file does not solve it. The submitted step updates only u_x and u_y,
omits the pressure, and omits z-derivatives. The stored sum of squares
is not the dissipation. No database password is stored.
"""

import os

import numpy as np

MODULE_ID = "MOD_NAVIER_STOKES_007"


def taylor_green(grid_size=32):
    axis = np.linspace(-np.pi, np.pi, grid_size)
    step = axis[1] - axis[0]
    x, y, z = np.meshgrid(axis, axis, axis, indexing="ij")
    u_x = np.sin(x) * np.cos(y) * np.cos(z)
    u_y = -np.cos(x) * np.sin(y) * np.cos(z)
    u_z = np.zeros_like(z)
    div = (
        np.gradient(u_x, step, axis=0)
        + np.gradient(u_y, step, axis=1)
        + np.gradient(u_z, step, axis=2)
    )
    return axis, step, u_x, u_y, u_z, div


def submitted_update(grid_size=32, steps=100, dt=0.005, nu=0.01):
    """The update from the draft, including its missing pressure and z terms."""
    _axis, _step, u_x, u_y, _u_z, div0 = taylor_green(grid_size)
    energy = np.zeros(steps)
    max_slice = np.zeros(steps)
    for step in range(steps):
        dux_dy = np.gradient(u_x, axis=1)
        duy_dx = np.gradient(u_y, axis=0)
        vort_z = duy_dx - dux_dy
        max_slice[step] = np.max(np.abs(vort_z[:, :, grid_size // 2]))
        energy[step] = float(np.sum(u_x**2 + u_y**2))
        laplacian_u_x = np.gradient(np.gradient(u_x, axis=0), axis=0) + np.gradient(
            np.gradient(u_x, axis=1), axis=1
        )
        laplacian_u_y = np.gradient(np.gradient(u_y, axis=0), axis=0) + np.gradient(
            np.gradient(u_y, axis=1), axis=1
        )
        u_x = u_x + (-(u_x * np.gradient(u_x, axis=0) + u_y * dux_dy) + nu * laplacian_u_x) * dt
        u_y = u_y + (-(u_x * duy_dx + u_y * np.gradient(u_y, axis=1)) + nu * laplacian_u_y) * dt
    step_x = (_axis[1] - _axis[0])
    div_final = np.gradient(u_x, step_x, axis=0) + np.gradient(u_y, step_x, axis=1)
    return div0, energy, max_slice, div_final


def main():
    div0, energy, max_slice, div_final = submitted_update()
    path = os.path.join(os.path.dirname(__file__), f"finding_{MODULE_ID.lower()}.npz")
    np.savez_compressed(path, energy=energy, max_vorticity_slice=max_slice)
    print(f"wrote {path}")
    print(f"initial physical divergence max {np.max(np.abs(div0)):.6g}")
    print(f"sum of squares first {energy[0]:.6g} last {energy[-1]:.6g}")
    print(f"max |slice vorticity| first {max_slice[0]:.6g} last {max_slice[-1]:.6g}")
    print(f"final physical divergence max of the two updated components {np.max(np.abs(div_final)):.6g}")
    print("database step skipped; Navier-Stokes regularity is not decided by this loop")


if __name__ == "__main__":
    main()
