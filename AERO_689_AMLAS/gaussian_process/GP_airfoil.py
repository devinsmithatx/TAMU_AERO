# imports
import numpy as np
import os
import subprocess
import time
from GPyOpt.methods import BayesianOptimization

def NACA_airfoil(max_camber, max_camber_position, max_thickness):
    '''
    NACA Airfoil Generator
    '''

    # convert percentagets to integers
    mc = str(int(max_camber*100))
    mcp = str(int(max_camber_position*10))
    mt = int(max_thickness*100)
    if mt < 10:
        mt = '0' + str(mt)
    else:
        mt = str(mt)

    # create NACAXXXX
    return "NACA{}{}{}".format(mc, mcp, mt)


def xfoil_runner(max_camber, max_camber_position, max_thickness):
    '''
    Xfoil Runner, pulled from the xfoil_runner.py given in CANVAS
    '''

    # xfoil parameters
    airfoil_name = NACA_airfoil(max_camber, max_camber_position, max_thickness)
    alpha_i = 0
    alpha_f = 10
    alpha_step = 0.25
    Re = 1000000
    n_iter = 100
    
    # check if data already exists from previous sim
    if os.path.exists("polar_file.txt"):
        os.remove("polar_file.txt")

    # create the input file to xfoil
    input_file = open("input_file.in", 'w')
    input_file.write("LOAD {0}.dat\n".format(airfoil_name))
    input_file.write(airfoil_name + '\n')
    input_file.write("PANE\n")
    input_file.write("OPER\n")
    input_file.write("Visc {0}\n".format(Re))
    input_file.write("PACC\n")
    input_file.write("polar_file.txt\n\n")
    input_file.write("ITER {0}\n".format(n_iter))
    input_file.write("ASeq {0} {1} {2}\n".format(alpha_i, alpha_f, alpha_step))
    input_file.write("\n\n")
    input_file.write("quit\n")
    input_file.close()

    # run xfoil using the input file
    subprocess.call("xfoil.exe < input_file.in", shell=True)

    # load the generated data from xfoil
    polar_data = np.loadtxt("polar_file.txt", skiprows=12)
    return polar_data


def objective_function(x):
    '''
    generates the airfoils and runs Xfoil on them. Returns Cl/Cd
    '''

    # get airfoil settings
    max_camber, max_camber_position, max_thickness = x[:, 0], x[:, 1], x[:, 2]

    # run xfoil and get data
    data = xfoil_runner(max_camber, max_camber_position, max_thickness)
    time.sleep(0.2)

    # calculate L/D if data converged for the given combo of parameters
    try:
        lift_to_drag_ratio = data[0, 1]/data[0 ,2]
    except:
        lift_to_drag_ratio = 0.

    return lift_to_drag_ratio

# ----------------------------------------------------------------------------------------------

# Bounds of the design variables and the desired step size for NACA naming convention
max_camber_domain = np.arange(0.02, 0.06, 0.01)
max_camber_position_domain = np.arange(0.1, 0.6, 0.1)
max_thickness_domain = np.arange(0.1, 0.19, 0.01)

# Optimization Domain
domain = [{'name': 'max_camber', 'type': 'discrete', 'domain': max_camber_domain},
          {'name': 'max_camber_position', 'type': 'discrete', 'domain': max_camber_position_domain},
          {'name': 'max_thickness', 'type': 'discrete', 'domain': max_thickness_domain}]

# domain = [{'name': 'max_camber', 'type': 'continuous', 'domain': (0.02, 0.05)},
#           {'name': 'max_camber_position', 'type': 'continuous', 'domain': (0.1, 0.5)},
#           {'name': 'max_thickness', 'type': 'continuous', 'domain': (0.1, 0.18)}]

# Create a Bayesian Optimization object
optimizer = BayesianOptimization(f=objective_function,
                                 domain=domain,
                                 model_type='GP',
                                 acquisition_type='EI', # Expected Improvement
                                 acquisition_jitter = 0.05,
                                 exact_feval=True,
                                 maximize=True)         # maximizxe L/D

# Number of initial points and subsequent evaluations
initial_design_numdata = 15
max_iter = 50

# Run the optimization
optimizer.run_optimization(max_iter=max_iter, verbosity=True)

# ----------------------------------------------------------------------------------------------

# get the polar data of optimal design
airfoil = NACA_airfoil(optimizer.x_opt[0], optimizer.x_opt[1], optimizer.x_opt[2])
data = xfoil_runner(optimizer.x_opt[0], optimizer.x_opt[1], optimizer.x_opt[2])
lift_to_drag_ratio = data[0, 1]/data[0 ,2]

# output the optimial design
print("\n\nOptimal design:", optimizer.x_opt)
print("Airfoil Name:", airfoil)
print("L/D:", lift_to_drag_ratio, '\n')
