#Anthony Verdone
#CIS 400
#HW4 - April 2nd 2022

#= PROMT ================================================================================
Use Particle Swarm Optimization. Compare with the previous results (HW1-3). 
=================================================================================================#

using PyCall
pyswarm = pyimport("pyswarms")

py"""
import matplotlib.pyplot as plt
import numpy as np
from IPython.display import Image

import pyswarms as ps
from pyswarms.utils.functions import single_obj as fx
from pyswarms.utils.plotters import (plot_cost_history, plot_contour, plot_surface)

from pyswarms.utils.plotters import plot_contour, plot_surface
from pyswarms.utils.plotters.formatters import Designer
from pyswarms.utils.plotters.formatters import Mesher

#implimenting the optimization function and the PSO parameters
options = {'c1': 0.5, 'c2': 0.3, 'w':0.9}
optimizer = ps.single.GlobalBestPSO(n_particles=10, dimensions=2, options=options)
cost, pos = optimizer.optimize(fx.sphere, iters=100)


#Graphing PSO cost history
#plot_cost_history(cost_history=optimizer.cost_history)
#plt.show()

#Graphing Swarm
mesh = Mesher(func=fx.sphere)
anim = plot_contour(pos_history=optimizer.pos_history,mesher=mesh,mark=(0,0))
anim.save("HW4.gif",writer='imagemagick')


"""



