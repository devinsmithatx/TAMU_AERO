from numpy import pi, sqrt, arccos, cos

R = 3389.5
h = 280
r = R + h
beta = 0
phi = 589.2
theta = 0
Isc = .35

G = 6.67384E-20
m_m = 6.41693E23
V_batt = 160
Acell = .0064

P_users = 9.5
n_dist = .9
n_star = .8
n_array = .23
DOD = 0.35

t0 = 2*pi*sqrt(r**3/(G*m_m))
tE = t0/pi*arccos(sqrt(h**2 +2*h*R)/((h+R)*cos(beta)))

life_ratio = 1/.8

P_array = P_users/n_dist*life_ratio*(1+tE/(n_star*(t0 - tE)))
A_array = P_array*1000/(phi*n_array*cos(theta))
C_tot = P_users*1000*(tE/3600)/(n_dist*V_batt*DOD)

cell_array = A_array/Acell
cell_bat = C_tot/(tE/3600)/Isc

print(t0/3600)
print(tE/3600)
print(life_ratio)
print(P_array)
print(A_array)
print(C_tot)
print(cell_bat)
print(cell_array)
print(cell_bat + cell_array)

I_total = P_array*1000/V_batt
print(I_total)
print(I_total/Isc)
print((cell_bat + cell_array)/(I_total/Isc))

lb = 6.6
p = 0.1107

q = lb/p

grad = q/(100*60*24)
print(q)
print(grad)
