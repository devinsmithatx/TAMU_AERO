# -----------------------------------------------------------------------------------------------------------------

'''
PINNs Assignment -- Solve 2D Navier-Stokes Equation.
This assignment involves solving Navier-Stokes for NACA 3414 at an Angle of Attack of 5 degrees.

I chose to use DeepXDE (https://deepxde.readthedocs.io/en/latest/) as my library of choice.
This library is specialized for scientific machine learning and physics-informed learning.
DeepXDE has algorithms for PINNs, DeepONets, and MFNNs
DeepXDE allows you to tensorflow (1 and 2), PyTorch, JAX, and PaddlePaddle as its tensor library backend.
'''

# -----------------------------------------------------------------------------------------------------------------
# imports
import numpy as np
import matplotlib.pyplot as plt
import deepxde as dde

# set backend for deepxde PINN
dde.backend.set_default_backend("tensorflow")

# -----------------------------------------------------------------------------------------------------------------

# define fluid properties
# rho = 1.225              # kg/m^3, air density at SLS
# mu = 1.789E-5            # Pa*s, air viscosity at SLS
rho = 1.                 # kg/m^3, water density
mu = 1.                  # Pa*s, water viscosity

# define inlet velocity
u_inf = 1.               # m/s, inlet velocity

# define wind tunnel parameters
L = 1.                   # m, wind tunnel length
H = 1.                   # m, wind tunnel height

# define airfoil parameters
airfoil_location = [2., 2.5]        # m, location of leading edge
airfoil_scale = 1.0                 # scalar multiplier to change airfoil size
NACA_3414 = [[1.000146, 0.001463],  # NACA 3414 Data of unit airfoil length 1 m
             [0.998630, 0.001868],
             [0.994088, 0.003074],
             [0.986546, 0.005060],
             [0.976045, 0.007789],
             [0.962644, 0.011210],
             [0.946418, 0.015261],
             [0.927457, 0.019873],
             [0.905869, 0.024966],
             [0.881777, 0.030454],
             [0.855322, 0.036249],
             [0.826656, 0.042260],
             [0.795949, 0.048393],
             [0.763382, 0.054555],
             [0.729151, 0.060654],
             [0.693462, 0.066597],
             [0.656532, 0.072296],
             [0.618586, 0.077662],
             [0.579858, 0.082609],
             [0.540591, 0.087055],
             [0.501029, 0.090922],
             [0.461423, 0.094136],
             [0.422025, 0.096633],
             [0.382849, 0.098324],
             [0.344071, 0.098932],
             [0.306262, 0.098394],
             [0.269683, 0.096720],
             [0.234590, 0.093940],
             [0.201224, 0.090107],
             [0.169818, 0.085296],
             [0.140585, 0.079598],
             [0.113719, 0.073123],
             [0.089396, 0.065991],
             [0.067770, 0.058330],
             [0.048970, 0.050272],
             [0.033105, 0.041946],
             [0.020259, 0.033472],
             [0.010495, 0.024960],
             [0.003854, 0.016501],
             [0.000356, 0.008166],
             [0.000000, 0.000000],
             [0.002727,-0.007704],
             [0.008458,-0.014669],
             [0.017135,-0.020887],
             [0.028684,-0.026355],
             [0.043015,-0.031071],
             [0.060023,-0.035037],
             [0.079590,-0.038262],
             [0.101587,-0.040763],
             [0.125875,-0.042566],
             [0.152309,-0.043707],
             [0.180734,-0.044233],
             [0.210990,-0.044205],
             [0.242912,-0.043690],
             [0.276326,-0.042768],
             [0.311055,-0.041523],
             [0.346912,-0.040046],
             [0.383706,-0.038429],
             [0.421541,-0.036712],
             [0.460118,-0.034752],
             [0.498971,-0.032588],
             [0.537868,-0.030286],
             [0.576576,-0.027903],
             [0.614860,-0.025490],
             [0.652485,-0.023092],
             [0.689221,-0.020744],
             [0.724839,-0.018475],
             [0.759116,-0.016305],
             [0.791836,-0.014251],
             [0.822792,-0.012325],
             [0.851785,-0.010534],
             [0.878629,-0.008886],
             [0.903148,-0.007387],
             [0.925183,-0.006042],
             [0.944589,-0.004857],
             [0.961235,-0.003839],
             [0.975011,-0.002994],
             [0.985824,-0.002329],
             [0.993601,-0.001849],
             [0.998288,-0.001560],
             [0.999854,-0.001463]]

# compute location of airfoil points
for i in range(len(NACA_3414)):
    for j in range(2):
        NACA_3414[i][j] *= airfoil_scale
        if j == 0:
            NACA_3414[i][j] += airfoil_location[0]
        else:
            NACA_3414[i][j] += airfoil_location[1]

# define control volume with object in given location
wind_tunnel_geom = dde.geometry.Rectangle(xmin=[0, 0], xmax=[L, H])
# test_article_geom = dde.geometry.Disk([2.5,2.5], 0.1)                 # cylinder
test_article_geom = dde.geometry.Polygon(NACA_3414)                     # airfoil
control_volume = dde.geometry.CSGDifference(wind_tunnel_geom, test_article_geom)
control_volume = wind_tunnel_geom

# -----------------------------------------------------------------------------------------------------------------

# define navier stokes physics
def navier_stokes(X, Y):
    # X is input to the PINN (x, y)
    # Y is output of the PINN (u, v, p)

    # define pde derivatives
    du_dx = dde.grad.jacobian(xs=X, ys=Y, i=0, j=0)
    du_dy = dde.grad.jacobian(xs=X, ys=Y, i=0, j=1)

    dv_dx = dde.grad.jacobian(xs=X, ys=Y, i=1, j=0)
    dv_dy = dde.grad.jacobian(xs=X, ys=Y, i=1, j=1)

    dp_dx = dde.grad.jacobian(xs=X, ys=Y, i=2, j=0)
    dp_dy = dde.grad.jacobian(xs=X, ys=Y, i=2, j=1)

    ddu_dxdx = dde.grad.hessian(xs=X, ys=Y, i=0, j=0, component=0)
    ddu_dydy = dde.grad.hessian(xs=X, ys=Y, i=0, j=1, component=0)

    ddv_dxdx = dde.grad.hessian(xs=X, ys=Y, i=1, j=0, component=1)
    ddv_dydy = dde.grad.hessian(xs=X, ys=Y, i=1, j=1, component=1)
    
    # define continuity eq, x momentum, y momentum
    cont = du_dx + dv_dy
    xmom = rho*(Y[:,0:1]*du_dx + Y[:,1:2]*du_dy) + dp_dx - mu*(ddu_dxdx + ddu_dydy)
    ymom = rho*(Y[:,0:1]*dv_dx + Y[:,1:2]*dv_dy) + dp_dy - mu*(ddv_dxdx + ddv_dydy)

    return [xmom, ymom, cont]

# -----------------------------------------------------------------------------------------------------------------

# define functions to check if flow at boundary
def bc_inlet(X, on_boundary):
    # check if at the inlet of boundary; returns true if so
    return on_boundary and wind_tunnel_geom.on_boundary(X) and np.isclose(X[0], 0)

def bc_outlet(X, on_boundary):
    # check if at outlet of boundary; returns true if so
    return on_boundary and wind_tunnel_geom.on_boundary(X) and np.isclose(X[0], L)

def bc_wall(X, on_boundary):
    # check if on top or bottom of boundary; returns true if so
    return on_boundary and wind_tunnel_geom.on_boundary(X) and (np.isclose(X[1], 0) or np.isclose(X[1], H)) 

def bc_obj(X, on_boundary):
    # check if on or inside test article object; returns true if so
    return on_boundary and not wind_tunnel_geom.on_boundary(X)

# define the boundary conditions
bc_inlet_u = dde.DirichletBC(control_volume, lambda X: u_inf, bc_inlet, component=0)
bc_inlet_v = dde.DirichletBC(control_volume, lambda X: 0., bc_inlet, component=1)

bc_inlet_du = dde.NeumannBC(control_volume, lambda X: u_inf, bc_inlet, component=0)
bc_inlet_dv = dde.NeumannBC(control_volume, lambda X: 0., bc_inlet, component=1)

bc_outlet_p = dde.DirichletBC(control_volume, lambda X: 0., bc_outlet, component=2)
bc_outlet_v = dde.DirichletBC(control_volume, lambda X: 0., bc_outlet, component=1)

bc_wall_u = dde.DirichletBC(control_volume, lambda X: 0., bc_wall, component=0)
bc_wall_v = dde.DirichletBC(control_volume, lambda X: 0., bc_wall, component=1)

bc_obj_u = dde.DirichletBC(control_volume, lambda X: 0., bc_obj, component=0)
bc_obj_v = dde.DirichletBC(control_volume, lambda X: 0., bc_obj, component=1)

# -----------------------------------------------------------------------------------------------------------------

# define bcs
bcs = [bc_inlet_u, bc_inlet_v, bc_wall_u, bc_wall_v]
# bcs.append(bc_outlet_p); # bcs.append(bc_outlet_v)
bcs.append(bc_inlet_du); bcs.append(bc_inlet_dv)
# bcs.append(bc_obj_u); bcs.append(bc_obj_v)

# define the initial physics data sample
physics = dde.data.PDE(control_volume, navier_stokes, bcs, num_domain=5000, num_boundary=500, num_test=200)

# plot the goemetry and data sample to make sure control volume is correct
plt.figure(figsize = (10,8))
plt.scatter(physics.train_x_all[:,0], physics.train_x_all[:,1], s = 0.5)
plt.xlabel('length from inlet (m)')
plt.ylabel('height from bottom (m)')
plt.show()

# define physics informed nueral network
X_dim = [2]
Y_dim = [3]
hidden_layers = [50]*4
nn = dde.maps.FNN(X_dim + hidden_layers + Y_dim, "tanh", "Glorot uniform")
pinn = dde.Model(physics, nn)

# -----------------------------------------------------------------------------------------------------------------

# define optimizer settings then train pinn
pinn.compile("adam", lr=.001)
pinn.train(iterations=15000)
# pinn.compile("L-BFGS")
# pinn.train(iterations=5000)

# -----------------------------------------------------------------------------------------------------------------

# obtain the solution
sample = control_volume.random_points(500000)
solution = pinn.predict(sample)
v = (solution[:, 0]**2 + solution[:, 1]**2)**.5

# -----------------------------------------------------------------------------------------------------------------

# plot the results
plt.figure()
plt.scatter(sample[:, 0],
            sample[:, 1],
            c=v,
            cmap='jet',
            s=2)
plt.colorbar(); plt.clim([min(v), max(v)])
plt.xlim((0, L)); plt.ylim((0, H))
plt.xlabel("X"); plt.ylabel("Y")
plt.tight_layout()
plt.title("Velocity Magnitude Across Region")
plt.show()
