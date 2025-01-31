import numpy as np
import matplotlib.pyplot as plt
import sympy
x, y = sympy.symbols('x, y')

width = 450/12 # ft
length = 120 # ft
phi = 1367.6
n = 0.11
A_2B = width * length

# Solve for the length of 4A that actually is in the sun
# To do this center 2B at the origin and draw a line from the tip of 2B to
# see where (if at all) it intersects with 4A. Then disregard the length
# below that point
beta = np.linspace(0, 70, 25)
ga2B = np.linspace(0, 90, 25)
ga4A = np.linspace(0, 90, 25)
best_angles = np.zeros([25, 3])
i = 0
best_power = 0

for b in beta:
    for gimble_angle_4A in ga4A:
        for gimble_angle_2B in ga2B:
            # Get the equations for tip of 2B
            y1 = np.sin(np.radians(gimble_angle_2B)) * width / 2
            x1 = np.cos(np.radians(gimble_angle_2B)) * width / 2
            # print(x1, y1)
            # Get the equation for the shadow cast by the tip of 2B
            eqn_1 = -np.tan(np.radians(90 - b)) * (x - x1) + y1 - y

            # Get the equation for the 4A panel
            eqn_2 = np.tan(np.radians(gimble_angle_4A)) * (x - 600/12) - y

            l_shadow = 99999

            if b != 0:
                if gimble_angle_4A == 90:
                    y_int = np.tan(np.radians(90 - b)) * (600/12 - x1) + y1
                    x_int = 600/12
                elif gimble_angle_4A != 90:
                    soln = sympy.solve([eqn_1, eqn_2], [y, x])
                    y_int = soln[y]
                    x_int = soln[x]
                l_shadow = (y_int**2 + (x_int - 600/12)**2)**.5
            # print(x_int, y_int, l_shadow, width)
            A_4A = width * width
            if (l_shadow < width/2) and (y_int <= 0):
                if (width/2 - l_shadow) / width/2 < 0.2:
                    A_4A = width * (width/2 + l_shadow)
                else:
                    A_4A = width * (width/2)
            elif (l_shadow < width/2) and (y_int >= 0):
                if (width/2 - l_shadow) / width/2 > 0.8:
                    A_4A = width * (width/2 - l_shadow)
                else:
                    A_4A = 0

            # Setup the equation that calculates the power output
            P_2B = A_2B * phi * n * np.cos(np.radians(gimble_angle_2B - b))
            P_4A = A_4A * phi * n * np.cos(np.radians(gimble_angle_4A - b))
            total_power = P_2B + P_4A
            print(b, gimble_angle_4A, gimble_angle_2B, total_power, A_4A)
            if best_power < total_power:
                best_power = total_power
                best_angles[i] = [b, gimble_angle_4A, gimble_angle_2B]

    i += 1
    print(b)
    best_power = 0

best_angles = np.array(best_angles)
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.scatter(best_angles[:, 0], best_angles[:, 1], best_angles[:, 2])
ax.set_xlabel("beta")
ax.set_ylabel("gimble_angle_4A")
ax.set_zlabel("gimble_angle_2B")
plt.show()

fig = plt.figure(figsize = (15, 10))
ax = fig.add_subplot(projection='3d')
ax.stem(best_angles[:, 0], best_angles[:, 1], best_angles[:, 2])
ax.set_xlabel("beta")
ax.set_ylabel("gimble angle 4A")
ax.set_zlabel("gimble angle 2B")
plt.show()
