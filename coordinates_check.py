import numpy as np
from matplotlib import pyplot as plt
from mpl_toolkits import mplot3d


def mat_mul(matrix, vector):
    temp1 = matrix[0][0] * vector[0] + matrix[0][1] * vector[1] + matrix[0][2] * vector[2]
    temp2 = matrix[1][0] * vector[0] + matrix[1][1] * vector[1] + matrix[1][2] * vector[2]
    temp3 = matrix[2][0] * vector[0] + matrix[2][1] * vector[1] + matrix[2][2] * vector[2]
    return temp1, temp2, temp3


x_sw = 0
y_sw = 0
z_sw = 3
rotOX = 0.5
rotOY = 1.2
rotOZ = 0
x0 = 0
y0 = 0
z0 = 0
x1 = x_sw + np.sqrt(2)
y1 = y_sw + np.sqrt(2)
z1 = z_sw
x2 = x_sw - np.sqrt(2)
y2 = y_sw + np.sqrt(2)
z2 = z_sw
x3 = x_sw + np.sqrt(2)
y3 = y_sw - np.sqrt(2)
z3 = z_sw
x4 = x_sw - np.sqrt(2)
y4 = y_sw - np.sqrt(2)
z4 = z_sw

x_arr = [x1, x2, x3, x4, x0]
y_arr = [y1, y2, y3, y4, y0]
z_arr = [z1, z2, z3, z4, z0]
ax_3d = plt.axes(projection="3d")
matRotOX = [[1, 0, 0], [0, np.cos(rotOX), np.sin(rotOX)], [0, -np.sin(rotOX), np.cos(rotOX)]]
matRotOY = [[np.cos(rotOX), 0, -np.sin(rotOX)], [0, 1, 0], [np.sin(rotOX), 0, np.cos(rotOX)]]
matRotOZ = [[np.cos(rotOX), np.sin(rotOX), 0], [-np.sin(rotOX), np.cos(rotOX), 0], [0, 0, 1]]

ax_3d.scatter(x_arr, y_arr, z_arr)
x1, y1, z1 = mat_mul(matRotOX, [x1, y1, z1])
x2, y2, z2 = mat_mul(matRotOX, [x2, y2, z2])
x3, y3, z3 = mat_mul(matRotOX, [x3, y3, z3])
x4, y4, z4 = mat_mul(matRotOX, [x4, y4, z4])

x1, y1, z1 = mat_mul(matRotOY, [x1, y1, z1])
x2, y2, z2 = mat_mul(matRotOY, [x2, y2, z2])
x3, y3, z3 = mat_mul(matRotOY, [x3, y3, z3])
x4, y4, z4 = mat_mul(matRotOY, [x4, y4, z4])

x_arr1 = [x1, x3, x4, x2, x1]
y_arr1 = [y1, y3, y4, y2, y1]
z_arr1 = [z1, z3, z4, z2, z1]

ax_3d.plot(x_arr1, y_arr1, z_arr1, color="red")
plt.show()
