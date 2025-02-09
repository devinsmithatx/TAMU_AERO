# imports
from numpy import pi, sin, cos, array, matrix, cross, dot
from numpy import arccos, arcsin, arctan
from numpy.linalg import norm

# ------------------------------------------

# givens
NC = 40*1.852     # km
Ti = 8*1.852      # km
a = 6793          # assume semimajor axis of ISS
μ = 398600        # km/s^2
N = 1             # number of revolutions

# ------------------------------------------

# part a)

# initial velocity
V0 = (μ/a)**0.5

# change in time and radius for burn 1
dr1 = NC - Ti
dt1 = dr1/V0

# phase SMA for burn 1
a_phase1 = ((((a**3/μ)**.5 - dt1/(2*pi*N))**2)*μ)**(1/3)

# final V after burn 1 and dV for burn 1
V1 = (μ*(2/a - 1/a_phase1))**.5
dV1 = V1 - V0

# change in time and radius for burn 2
dr2 = Ti
dt2 = dr2/V1

# phase SMA for burn 2
a_phase2 = ((((a**3/μ)**.5 - dt2/(2*pi*N))**2)*μ)**(1/3)

# final V after burn 2 and dV for burn 2
V2 = (μ*(2/a - 1/a_phase2))**.5
dV2 = V2 - V1

# total burn
dVt1 = abs(dV1) + abs(dV2)

# results
print("One Rev:")
print("dV1:", dV1)
print("dV2:", dV2)
print("dVt:", dVt1)
print()
# ------------------------------------------

# part b)
N = 2             # number of revolutions

# initial velocity
V0 = (μ/a)**0.5

# change in time and radius for burn 1
dr1 = NC - Ti
dt1 = dr1/V0

# phase SMA for burn 1
a_phase1 = ((((a**3/μ)**.5 - dt1/(2*pi*N))**2)*μ)**(1/3)

# final V after burn 1 and dV for burn 1
V1 = (μ*(2/a - 1/a_phase1))**.5
dV1 = V1 - V0

# change in time and radius for burn 2
dr2 = Ti
dt2 = dr2/V1

# phase SMA for burn 2
N = 1
a_phase2 = ((((a**3/μ)**.5 - dt2/(2*pi*N))**2)*μ)**(1/3)

# final V after burn 2 and dV for burn 2
V2 = (μ*(2/a - 1/a_phase2))**.5
dV2 = V2 - V1

# total burn
dVt2 = abs(dV1) + abs(dV2)

print("Two Rev:")
print("dV1:", dV1)
print("dV2:", dV2)
print("dVt:", dVt2)
print()
print("dV savings:", dVt1 - dVt2)
print()

# ------------------------------------------

# part c)

# initial velocity
V0 = (μ/a)**0.5

# change in time and radius for burn 1
dr1 = NC - Ti
dt1 = dr1/V0

# phase SMA for burn 1
a_phase1 = ((((a**3/μ)**.5 - dt1/(2*pi*N))**2)*μ)**(1/3)

# final V after burn 1 and dV for burn 1
V1 = (μ*(2/a - 1/a_phase1))**.5
dV1 = V1 - V0

# delay burn
dV2 = -dV1

# final burn
dV3 = V0 - V2

# total burn
dVt3 = abs(dV1) + abs(dV2) + abs(dV3)

print("Delayed Rev:")
print("dV1:", dV1)
print("dV2:", dV2)
print("dV3:", dV3)
print("dVt:", dVt3)

# ------------------------------------------

# Given information

# Body properties
m = 1000.             # mass (kg)
T = 1000.             # thrust (N)
Δt = 5.               # burn time (s)

# Earth Properties
μ = 3.986004418E14    # gravitational parameter (m^3/s^2)

# Thruster Angle (Body Frame)
θ_T = -5.0*pi/180.    # pitch (rad)

# Body Attitude (LVLH Frame)
φ_B = 0.*pi/180.      # roll (rad)
θ_B = 15.*pi/180.     # pitch (rad)
ψ_B = 35.*pi/180.     # yaw (rad)

# Initial orbit in keplerian
a_0 = 6778.0*1000     # semimajor axis (m)
e_0 = 0.001           # eccentricity ()
i_0 = 51.6*pi/180.    # inclination (rad)
Ω_0 = 90.0*pi/180.    # raan (rad)
ω_0 = 30.0*pi/180.    # argument of perigee (rad)
ν_0 = 200.0*pi/180.   # true anomaly (rad)

# ------------------------------------------

# Transformation matrices between body and LVLH frames

C_φ_B = matrix([[1., 0.      ,  0.      ],
                [0., cos(φ_B), -sin(φ_B)],
                [0., sin(φ_B),  cos(φ_B)]])

C_θ_B = matrix([[ cos(θ_B), 0., -sin(θ_B)],
                [ 0.      , 1.,  0.,     ],
                [-sin(θ_B), 0.,  cos(θ_B)]])

C_ψ_B = matrix([[ cos(ψ_B), sin(ψ_B), 0.],
                [-sin(ψ_B), cos(ψ_B), 0.],
                [ 0.      , 0.      , 1.]])

C_B_LVLH = C_ψ_B@C_θ_B@C_ψ_B   # LVLH to body
C_LVLH_B = C_B_LVLH.T          # body to LVLH

# ------------------------------------------

# Transformation matrices between Keplarian (orbital) and J2K (cartesian) frames

C_Ω_0 = matrix([[ cos(Ω_0), sin(Ω_0), 0.],
                [-sin(Ω_0), cos(Ω_0), 0.],
                [ 0.      , 0.      , 1.]])

C_i_0 = matrix([[1., 0.      ,  0.      ],
                [0., cos(i_0), -sin(i_0)],
                [0., sin(i_0),  cos(i_0)]])

C_ω_0 = matrix([[ cos(ω_0), sin(ω_0), 0.],
                [-sin(ω_0), cos(ω_0), 0.],
                [ 0.      , 0.      , 1.]])


C_O_I = C_ω_0@C_i_0@C_Ω_0       # Cartesian to orbital
C_I_O = C_O_I.T                 # Orbital to Cartesian

# ------------------------------------------

# Initial radius and velocity vector for orbital and cartesian frames

p_0 = a_0*(1 - e_0**2)
r_0 = p_0/(1 + e_0*cos(ν_0))

r_O = r_0*matrix([[cos(ν_0)], [sin(ν_0)], [0.]])
v_O = ((μ/p_0)**.5)*matrix([[-sin(ν_0)], [e_0 + cos(ν_0)], [0.]])

r_I_mat = C_I_O@r_O
v_I_mat = C_I_O@v_O

r_I_vec = array([r_I_mat[0, 0], r_I_mat[1, 0], r_I_mat[2, 0]])
v_I_vec = array([v_I_mat[0, 0], v_I_mat[1, 0], v_I_mat[2, 0]])

# ------------------------------------------

# Transformation matrices between LVLH and J2K (cartesian) frames

Y_hat = -cross(r_I_vec, v_I_vec)/norm(cross(r_I_vec, v_I_vec))
Z_hat = -r_I_vec/norm(r_I_vec)
X_hat = cross(Y_hat, Z_hat)

C_I_LVLH = matrix([[X_hat[0], Y_hat[0], Z_hat[0]],    # LVLH to cartesian
                   [X_hat[1], Y_hat[1], Z_hat[1]],
                   [X_hat[2], Y_hat[2], Z_hat[2]]])

C_LVLH_I = C_I_LVLH.T                                 # cartesian to LVLH

# ------------------------------------------

# Burn in the Cartersian frame

ΔV = T/m*Δt                                           # delta V magnutude (m/s)
ΔV_B = ΔV*matrix([[cos(θ_T)], [0.], [sin(θ_T)]])     # delta V in body
ΔV_LVLH = C_LVLH_B*ΔV_B                               # delta V in LVLH
ΔV_I = C_I_LVLH*ΔV_LVLH                               # delta V in cartesian

# ------------------------------------------

# Post-burn velocity and radius in the Cartesian frame
v_f_mat = v_I_mat + ΔV_I
v_f_vec = array([v_f_mat[0, 0], v_f_mat[1, 0], v_f_mat[2, 0]])

r_f_vec = r_I_vec       # assume impulse burn
v_f = norm(v_f_vec)     # post burn velocity magnitude
r_f = r_0               # post burn radius magnitude

# ------------------------------------------

# Post-burn orbital elements
a_f = μ/(2*μ/r_f - v_f**2)                # semimajor axis (m)

h_f = cross(r_f_vec, v_f_vec)
h_f_hat = h_f/norm(h_f)

i_f = arccos(h_f_hat[2])                  # inclination (rad)
Ω_f = arccos(-h_f_hat[1]/sin(i_f))        # raan (rad)

e_f_vec = 1/μ*(cross(v_f_vec, h_f) - μ/r_f*r_f_vec)
e_f_mat = matrix([[e_f_vec[0]],
              [e_f_vec[1]],
              [e_f_vec[2]]])
e_f = norm(e_f_vec)                       # eccentricity ()


C_Ω_f = matrix([[ cos(Ω_f), sin(Ω_f), 0.],
                [-sin(Ω_f), cos(Ω_f), 0.],
                [ 0.      , 0.      , 1.]])
C_i_f = matrix([[1.,  0.      , 0.      ],
                [0.,  cos(i_f), sin(i_f)],
                [0., -sin(i_f), cos(i_f)]])
C_iΩ_e = C_i_f@C_Ω_f@e_f_mat

ω_f = arctan(C_iΩ_e[1, 0]/C_iΩ_e[0, 0])   # argument of paragee (rad)
if ω_f < 0:
  ω_f += pi

dot_ν_f = dot(e_f_vec, r_f_vec)/(e_f*r_f)     # true anomaly (rad)
ν_f = arccos(dot_ν_f)
if dot_ν_f < 0:
  ν_f = -ν_f + 2*pi


# ------------------------------------------

# Results

print(ΔV_I)
print("a_0:", a_0/1000.)
print("e_0:", e_0)
print("i_0:", i_0*180./pi)
print("Ω_0:", Ω_0*180./pi)
print("ω_0:", ω_0*180./pi)
print("ν_0:", ν_0*180./pi)
print()
print("a_f:", a_f/1000.)
print("e_f:", e_f)
print("i_f:", i_f*180./pi)
print("Ω_f:", Ω_f*180./pi)
print("ω_f:", ω_f*180./pi)
print("ν_f:", ν_f*180./pi)

# ---------------------------------------------------

# given values
μ = 4.9048695E3
R_m = 1783
h_sma = 100
e = 0.003
ν = pi

# solving starting values
a = h_sma + R_m
p = a*(1. - e**2)
r = p/(1 + e*cos(ν))
v = ((μ/p)**.5)*norm(array([-sin(ν), e + cos(ν), 0.]))

# solving for da/dv
da_dv = -μ*(v)/2*(((v)**2)/2 - μ/(r))**2

# ---------------------------------------------------

# iterating over Δv = 0
Δv = 0
Δa = 0

i = 1
step = 0.00001

print(("iteration #" + str(i) + ":").ljust(20), end='')
print(("Δv: " + '{:0.3e}'.format(Δv)).ljust(20), end='')
print(("h_sma: " + '{:0.3e}'.format(Δa + h_sma)).ljust(20))

while Δa < 20:
  Δa = da_dv*Δv
  if i%50 == 0:
    print(("iteration #" + str(i) + ":").ljust(20), end='')
    print(("Δv: " + '{:0.3e}'.format(Δv)).ljust(20), end='')
    print(("h_sma: " + '{:0.3e}'.format(Δa + h_sma)).ljust(20))
  if Δa < 20:
    i += 1
    Δv -= step

# ---------------------------------------------------

# solving directly for Δv

Δa = 120 - 100
Δv = Δa/da_dv

print()
print("solving directy:")
print("Δv:", Δv)
