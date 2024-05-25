import numpy as np
from scipy.io import savemat
import matplotlib.pyplot as plt

def initModel(map_size: int, city: int, veh: int, offset: int) -> dict:
    """This function initializes a model with random positions for cities and vehicles.

    Args:
        map_size (int): The size of the map(map_size * map_size).
        city (int): The total number of cities to be generated in the model.
        veh (int): The total number of vehicles to be generated in the model.
        offset (int): The offset value used to create a gap between the coordinates 
        of the cities and vehicles.

    Returns:
        dict: A dictionary containing the generated model with keys as 'cities' and 'vehicles', 
        each containing a list of their respective coordinates.
    """
    model = {'city': city, 'veh': veh}

    # ranges of x and y
    xmin, xmax = 0, map_size
    ymin, ymax = 0, map_size

    maps = np.zeros((city + veh, city + veh))

    # the center of the map
    x0, y0 = map_size // 2, map_size // 2
    model['x0'], model['y0'] = x0, y0

    # for showing multiple vehicles
    x1 = np.random.randint(xmin, xmax / 2 - offset, city // 4)
    x2 = np.random.randint(xmin, xmax / 2 - offset, city // 4)
    x3 = np.random.randint(xmax / 2 + offset, xmax, city // 4)
    x4 = np.random.randint(xmax / 2 + offset, xmax, city // 4)

    y1 = np.random.randint(ymin, ymax / 2 - offset, city // 4)
    y2 = np.random.randint(ymin, ymax / 2 - offset, city // 4)
    y3 = np.random.randint(ymax / 2 + offset, ymax, city // 4)
    y4 = np.random.randint(ymax / 2 + offset, ymax, city // 4)

    x = np.concatenate((x1, x2, x3, x4, [x0] * veh))
    y = np.concatenate((y1, y3, y2, y4, [y0] * veh))

    model['x'], model['y'] = x, y

    n = city + veh

    for i in range(n):
        for j in range(i, n):
            maps[j, i] = np.sqrt((x[i] - x[j])**2 + (y[i] - y[j])**2)
            maps[i, j] = maps[j, i]

    model['maps'] = maps

    return model

if __name__ == '__main__':
    map_size, city, veh, offset = map(int, input(
        "Enter the size of map, number of cities, vehicles and the offset value(separated by space):\n"
    ).split())
    model = initModel(map_size, city, veh, offset)
    """savemat is a function that saves the model dictionary to a .mat file.
    
    You can use the following code to load the file in matlab:
    model = load('model.mat')

    Then you can access the values of the dictionary using the keys as follows:
    city = model.city
    veh = model.veh 
    maps = model.maps
    """
    savemat('model.mat', model)
    
    # Plot the cities and vehicles on the map
    plt.figure(figsize=(10, 10))
    plt.scatter(model['x'][:city], model['y'][:city], c='b', label='Cities')
    plt.scatter(model['x'][city:], model['y'][city:], c='r', label='Vehicles')
    plt.xlim([0, map_size])
    plt.ylim([0, map_size])
    plt.grid(True)
    plt.legend()
    plt.title('Map')
    plt.show()