import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

N = 50
ON = 255
OFF = 0
vals = [ON, OFF]


grid = np.random.choice(vals, N*N, p=[0.6, 0.4]).reshape(N, N)

def game_of_life(data):
  global grid

  newGrid = grid.copy()
  for i in range(N):
    for j in range(N):

      #taking a toroidal boundary conditions
      total = (grid[i, (j-1)%N] + grid[i, (j+1)%N] +
               grid[(i-1)%N, j] + grid[(i+1)%N, j] +
               grid[(i-1)%N, (j-1)%N] + grid[(i-1)%N, (j+1)%N] +
               grid[(i+1)%N, (j-1)%N] + grid[(i+1)%N, (j+1)%N])/255

      if grid[i, j]  == ON:
        if (total < 2) or (total > 3):
          newGrid[i, j] = OFF
      else:
        if total == 3:
          newGrid[i, j] = ON
  mat.set_data(newGrid)
  grid = newGrid
  #print grid
  return [mat]

fig, ax = plt.subplots()
mat = ax.matshow(grid)
ani = animation.FuncAnimation(fig, game_of_life, interval=5,
                              save_count=50)
plt.show()
