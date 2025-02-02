# -*- coding: utf-8 -*-
"""attitude_kinematics.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1VNCtUFJw5DxaN_lpK1nJFV5uRYOTaSzg
"""

from sympy import Matrix, sqrt

# ----- a) -----

# given DCM
T = Matrix([[0 - 1,  1/sqrt(2)    , 1/sqrt(2)],
            [0    , -1/sqrt(2) - 1, 1/sqrt(2)],
            [1    ,  0            , 0 - 1    ]])

# RREF of T
T_rref = T.rref()
print(T_rref)
print()

# l obtained from hand calcs using T_rref
from numpy import sqrt, matrix, arccos, degrees, cos, sin
l = 1/sqrt(5-2*sqrt(2))*matrix([[1          ],
                                [sqrt(2) - 1],
                                [1          ]])
print(l)
print()

# ----- b) -----

phi = arccos(1/2*(-1/sqrt(2) - 1))
print(degrees(phi))
print()

# ----- c) -----

b0 = cos(phi/2)
b1 = l[0, 0]*sin(phi/2)
b2 = l[1, 0]*sin(phi/2)
b3 = l[2, 0]*sin(phi/2)

eulers = matrix([[b0],
                 [b1],
                 [b2],
                 [b3]])

print(eulers)

from numpy import matrix, cos, sin, radians, tan, degrees, cross, array

def sec(angle):
  return 1/cos(angle)

# --- part a ---

# given euler angles
phi = radians(20)
theta = radians(5)
psi = radians(0)

# given velocity in body wrt inertial
v_b = matrix([[500],
              [0],
              [40]])

# transformation matrices
T3 = matrix([[ cos(psi), sin(psi), 0],
             [-sin(psi), cos(psi), 0],
             [ 0       , 0       , 1]])

T2 = matrix([[cos(theta), 0, -sin(theta)],
             [0         , 1,  0         ],
             [sin(theta), 0,  cos(theta)]])

T1 = matrix([[1,  0       , 0       ],
             [0,  cos(phi), sin(phi)],
             [0, -sin(phi), cos(phi)]])

# velocity in intertal wrt inertial
v_i = T3.T*T2.T*T1.T*v_b
print(v_i)
print()

# --- part b ---

# given anglular velocity in body wrt inertial
w_b = matrix([[radians(0)],
              [radians(10)],
              [radians(20)]])

# kinetmatics matrix for euler rates
kinematics = matrix([[1, tan(theta)*sin(phi),  tan(theta)*cos(phi)],
                     [0, cos(phi)           , -sin(phi)           ],
                     [0, sin(phi)*sec(theta),  cos(phi)*sec(theta)]])

# euler rates
e_rates = degrees(kinematics*w_b)

print(e_rates)
print()

# --- part c ---

# given velocity, acceleration, and angular velocity in body wrt body
v_b = array([500, 0, 40])
a_b = array([20, 10, 0])
w_b = array([radians(0), radians(10), radians(20)])

# acceleration in body wrt inertial
a_b_I = a_b + cross(w_b, v_b)

g = 32.2
a_n = -(a_b_I[2] - g*cos(theta)*cos(phi))/g
a_l =  (a_b_I[1] - g*cos(theta)*sin(phi))/g

print(a_l, a_n)

from numpy import sqrt, pi, array, matrix, radians, sign

# EULER ANGLE DYNAMICS ------------------------------------

def ModelDynamics_Euler(t, x):
  # euler angles
  phi, theta, psi = x[0:3]

  # constant angular rotation in body w.r.t. inertial
  P, Q, R = pi*sqrt(2)/12, 0, pi*sqrt(2)/12

  # kinematic matrix
  dphi = P + Q*tan(theta)*sin(phi) + R*tan(theta)*cos(phi)
  dtheta = Q*cos(phi) - R*sin(phi)
  dpsi = Q*sin(phi)*sec(theta) + R*cos(phi)*sec(theta)

  return array([dphi, dtheta, dpsi])

# EULER PARAMETER DYNAMICS ------------------------------------

def ModelDynamics_Quaternion(t, x):
  # euler parameters
  b0, b1, b2, b3 = x[0:4]

  # constant angular rotation in body w.r.t. inertial
  P, Q, R = pi*sqrt(2)/12, 0, pi*sqrt(2)/12
  w_b = matrix([[0], [P], [Q], [R]])

  # kinematic matrix
  kinematics = 1/2*matrix([[b0, -b1,  -b2, -b3],
                           [b1,  b0,  -b3,  b2],
                           [b2,  b3,   b0, -b1],
                           [b3, -b2,   b1,  b0]])

  # getting euler rates
  e_rates = kinematics*w_b
  db0, db1, db2, db3 = e_rates[0, 0], e_rates[1, 0], e_rates[2, 0], e_rates[3, 0]
  return array([db0, db1, db2, db3])

import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
from numpy import linspace

def ModelSimulation(euler0, t_range, model):
  sol = solve_ivp(model, t_range, euler0, dense_output=True)
  t = linspace(t_range[0], t_range[1], 200)
  x = sol.sol(t)
  plt.title("Simulation of Euler Rates")
  plt.xlabel("Time (s)")
  if model == ModelDynamics_Euler:
    plt.plot(t, degrees(x[0]), label="phi")
    plt.plot(t, degrees(x[1]), label='theta')
    plt.plot(t, degrees(x[2]), label='psi')
    plt.ylabel("Angle (degrees)")
  else:
    plt.plot(t, x[0], label="b0")
    plt.plot(t, x[1], label='b1')
    plt.plot(t, x[2], label='b2')
    plt.plot(t, x[3], label='b3')
    plt.ylabel("Quaternion")

  plt.legend()
  plt.show()

euler0 = array([0, 0, 0])
ModelSimulation(euler0, [0, 25], ModelDynamics_Euler)

b0_0 =  cos(0)*cos(0)*cos(0) + sin(0)*sin(0)*sin(0)
b1_0 =  sin(0)*cos(0)*cos(0) - cos(0)*sin(0)*sin(0)
b2_0 =  cos(0)*sin(0)*cos(0) + sin(0)*cos(0)*sin(0)
b3_0 = -sin(0)*sin(0)*cos(0) + cos(0)*cos(0)*sin(0)

euler0 = array([b0_0, b1_0, b2_0, b3_0])
ModelSimulation(euler0, [0, 25], ModelDynamics_Quaternion)