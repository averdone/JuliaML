#Anthony Verdone
#CIS 400
#HW6 - April 26th 2022

#= PROMT ================================================================================
Use a Learning Classifier System for the same problem
     (with no neural network model). Compare with the previous results (HW1-5).
=================================================================================================#

using LIBLINEAR
using Statistics
using Flux
using CSV
using DataFrames
using Random
using PyCall
skXCS = pyimport("skXCS")
a = pyimport("xcs")

DBDATA = CSV.read("messidor_features.arff",DataFrame)

py"""
from skXCS import XCS
import numpy 
import pandas
from sklearn.model_selection import cross_val_score
import sklearn

DBDATA = pandas.read_csv("messidor_features.csv", lineterminator= '\n')
columnName = ["id","0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18"]


DBDATA.columns = columnName
actionLabel = "17"
dataFeatures = DBDATA.drop(actionLabel,axis=1).values
dataActions = DBDATA[actionLabel].values


model = XCS(learning_iterations = 10000)
print(numpy.mean(cross_val_score(model,dataFeatures,dataActions,cv=2)))
"""


println("Homework 6 complete!")