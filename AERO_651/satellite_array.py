# imports

from numpy import array, sqrt, pi, cos, sin, tan, radians
import numpy as np
import matplotlib.pyplot as plt

# classes

'''
satellite array configuration at 0 gimbal angle

left panel <--> mast <--> right panel

each part has their left end and their right end location defined,
as well as the center of the array
these are used along with the beta angle to calculate the shadow projection
'''

def array_2B(th1):
  # naming convention
  # right panel right = rpr
  # left panel right = lpr
  # mast right = mp
  # etc
  center = array([0., 0.])
  rpr = array([(450./2)*cos(th1), (450./2)*sin(th1)])
  rpl = array([(450./2 - 175)*cos(th1), (450./2 - 175.)*sin(th1)])
  lpl = -rpr
  lpr = -rpl
  mr = array([sqrt(30./pi)*cos(th1), sqrt(30./pi)*sin(th1)])
  ml = -mr
  return [rpr, rpl, mr, ml, lpr, lpl]

def array_4A(th2):
  center = array([600., 0.])
  rpr = array([(450./2)*cos(th2), (450./2)*sin(th2)])
  rpl = array([(450./2 - 175)*cos(th2), (450./2 - 175.)*sin(th2)])
  lpl = -rpr
  lpr = -rpl
  mr = array([sqrt(30./pi)*cos(th2), sqrt(30./pi)*sin(th2)])
  ml = -mr

  rpr += center
  rpl += center
  lpl += center
  lpr += center
  mr += center
  ml += center
  return [rpr, rpl, mr, ml, lpr, lpl]

def slope_intercept_shadow(b, point):
  # retuns slop and intercept of shadow line coming off of a certain pont
  m = -1/tan(b)
  y0 = point[1] - m*point[0]
  return m, y0

def slope_intercept_4A(th1):
  # returns slope and intercept of the line for the second array
  m = tan(th1)
  y0 = 0.
  return m, y0

def slope_intercept_4A(th2):
  # returns slope and intercept of the line for the second array
  m = tan(th2)
  y0 = -m*600.
  return m, y0

def plot_scenario(th1, th2, b):
  array1 = array_2B(th1)
  array = array_4A(th2)
  array_slope, array_y0 = slope_intercept_4A(th2)
  plot(array_slope, array_y0, "g")
  for point in array1:
    shadow_slope, shadow_y0 = slope_intercept_shadow(b, point)
    plot(shadow_slope, shadow_y0, "k")

  x_vals = np.linspace(600. + -225.*cos(th2), 600. + 225.*cos(th2), num = 1000)
  y_vals = np.linspace(-225.*sin(th2), 225.*sin(th2), num = 1000)
  plt.plot(x_vals, y_vals, 'b')

  x_vals = np.linspace(-225.*cos(th1), 225.*cos(th1), num = 1000)
  y_vals = np.linspace(-225.*sin(th1), 225.*sin(th1), num = 1000)
  plt.plot(x_vals, y_vals, 'b')
  plt.xlim(-300, 900)
  plt.ylim(-600, 600)

def plot(slope, intercept, color):
  x_vals = np.linspace(-500, 1000, num = 10000)
  y_vals = np.linspace(-500, 500, num = 10000)
  for i in range(len(x_vals)):
    y_vals[i] = slope*x_vals[i] + intercept
  plt.plot(x_vals, y_vals, color)

def find_intercept(slope_1, y0_1, slope_2, y0_2):
  # finds the intercepts between two lines and retuns it
  try:
    # find the intercept
    x0 = (y0_2 - y0_1)/(slope_1 - slope_2)
    y0 = -(slope_2*y0_1 - slope_1*y0_2)/(slope_1 - slope_2)
    return x0, y0
  except:
    # there is no intercept
    return None

def find_intercepts(th1, th2, b):
  # testing if right panel of 2B is shadowed on left panel of 4A
  array1 = array_2B(th1)
  array2 = array_4A(th2)
  array_slope, array_y0 = slope_intercept_4A(th2)

  intercepts = []
  for point in array1:
    shadow_slope, shadow_y0 = slope_intercept_shadow(b, point)
    x0, y0 = find_intercept(shadow_slope, shadow_y0, array_slope, array_y0)
    intercepts.append(array([x0, y0]))
  return intercepts


def find_area(th1, th2, b):
  array1 = array_2B(th1)
  array2 = array_4A(th2)
  intercepts = find_intercepts(th1, th2, b)
  print(intercepts)

  # check for shadows on left panel of 4A
  intercept_rpr = intercepts[0]

  # left panel start and end
  array_4A_lpl = array2[4]

  if np.linalg.norm(intercept_rpr)


# -----------------------------
# User Input
# -----------------------------

# define variables
th1 = radians(70.)
th2 = radians(45.)
b = radians(45.)

# ----------------------------
# Plotting
# ----------------------------

plot_scenario(th1, th2, b)
plt.grid()
plt.show()

# ---------------------------
# Calculating Area
# ---------------------------

find_area(th1, th2, b)
