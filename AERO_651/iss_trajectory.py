import numpy as np
import matplotlib.pyplot as plt

# Given state vectors for ISS and objects at March 3, 2015 at 00:00:00 UTC
state_iss = {
    'position': np.array([-1845.417850814, -6092.172005845, 2328.337863604]),
    'velocity': np.array([4.281378614, -3.361370008, -5.401755451])
}

state_objects = {
    'object_1': {
        'position': np.array([-1028.950474343, 4449.537440277, 5950.823336375]),
        'velocity': np.array([-6.465924315, 1.850855741, -2.310253829])
    },
    'object_2': {
        'position': np.array([4477.742707811, -1000.611267952, -4986.018302013]),
        'velocity': np.array([-3.433266954, 5.245259077, -4.248918972])
    },
    'object_3': {
        'position': np.array([-4153.267150665, -1917.869489970, 5240.119199598]),
        'velocity': np.array([-1.175696919, 7.333777896, 1.483361702])
    },
    'object_4': {
        'position': np.array([5603.394237177, -2391.195658262, -2974.014294217]),
        'velocity': np.array([-3.089631208, -7.015455966, -0.180761981])
    },
    'object_5': {
        'position': np.array([3606.349446299, -878.424222497, -6024.452460982]),
        'velocity': np.array([2.609985763, 6.964443101, 0.497362247])
    }
}

# Constants
time_interval = .001  # time step in seconds for propagation
duration = 24 * 3600  # total duration in seconds (24 hours)
conjunction_distance = 10.0  # minimum miss distance for a conjunction in km

# Function to propagate the state vectors
def propagate_state(state, dt):
    # Use a simple linear propagation model for demonstration purposes
    position = state['position'] + state['velocity'] * dt
    return {'position': position, 'velocity': state['velocity']}

# Function to compute miss distance
def compute_miss_distance(pos1, pos2):
    return np.linalg.norm(pos1 - pos2)

# Create a time array
time_array = np.arange(0, duration, time_interval)

# Dictionary to store miss distance data for each object
miss_distance_data = {}

# Initialize a list to track objects with conjunctions
conjunctions = []

# Initialize variables to track the closest approach distance
closest_approach_distance = float('inf')
closest_approach_object = None

# Loop through each object and compute miss distance
for obj_name, obj_state in state_objects.items():
    miss_distances = []

    # Propagate and calculate miss distances over the duration
    for t in time_array:
        # Propagate the ISS and object states
        iss_state = propagate_state(state_iss, t)
        obj_state_t = propagate_state(obj_state, t)

        # Calculate the miss distance
        miss_distance = compute_miss_distance(iss_state['position'], obj_state_t['position'])

        # Update the closest approach distance if necessary
        if miss_distance < closest_approach_distance:
            closest_approach_distance = miss_distance
            closest_approach_object = obj_name

        # Append the miss distance to the list
        miss_distances.append(miss_distance)

        # Check if conjunction occurs
        if miss_distance <= conjunction_distance:
            if obj_name not in conjunctions:
                conjunctions.append(obj_name)

    # Store the miss distances in the dictionary
    miss_distance_data[obj_name] = miss_distances

# Plot miss distance over time for each object
plt.figure()
for obj_name, miss_distances in miss_distance_data.items():
    plt.plot(time_array / 3600, miss_distances, label=obj_name)

# Add labels and legend to the plot
plt.xlabel('Time (hours)')
plt.ylabel('Miss Distance (km)')
plt.title('Miss Distance of Objects Relative to ISS Over Time')
plt.legend()
plt.show()

# Print the list of objects with conjunctions
if conjunctions:
    print(f"Objects that conjunct with the ISS within the 24-hour period: {', '.join(conjunctions)}")
else:
    print("No objects conjunct with the ISS within the 24-hour period.")

# Output the closest approach distance of an object to the ISS
print(f"The closest approach distance of {closest_approach_object} to the ISS is: {closest_approach_distance:.2f} km")
