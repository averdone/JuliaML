#Anthony Verdone
#CIS 400
#HW1 - February 8th 2022

#= PROMT ================================================================================
Select a 2-class classification problem with at least ten input attributes or features and 
at least 1000 labeled data points, using the datasets publicly available on the internet.  
Balance the data, so that you have equal numbers of data points from each class, 
e.g., by duplicating randomly chosen members of the minority class and adding a little random noise.
Use 70% of the data for training, and 30% for testing, ensuring that both sets are balanced.  
Train a shallow feedforward neural network (with sigmoidal node functions and one hidden layer with twice 
as many nodes as the input dimensionality) using back-propagation, while keeping track of performance on 
test data during the training process.  Repeat the experiment ten times, each time starting with a different 
set of randomly initialized weights; store these initial weights for future assignments. Summarize the results 
using one graph, plotting the average accuracy (on the y-axis) against log(number of weight updates), 
for training data and for test data; the graph will hence show two curves.  Also show the confusion matrix.
=================================================================================================#


using Flux
using CSV
using DataFrames
using Random
using Statistics
using StatsPlots



#Sigmoid function for later
sigmoid(x) = 1.0 ./ (1.0 .+ exp.(-x))

#=Confusion Matrix: A table layout that allows visualization of the performance of an algorithm
[ TP    FN]         function conf. Matrix (prediction, references)
[FP     TN]                 matric = Flux.onehotbatch(Flux.onecold(layer, 1:3)
                            references * matric'
=#
function ConfusionMatrix(prediction, references)
    matric = Flux.onehotbatch(Flux.onecold(hiddenLayerModel(prediction)), 1:2)
    prediction * matric'
end


#Diabetic Retinopathy Dataset 
DBDATA = CSV.read("messidor_features.arff",DataFrame)


#Renaming the collumns
DataFrames.rename!(DBDATA, [Symbol("Col$i") for i in 1:size(DBDATA,2)])
#println(first(DBDATA, 5))



#The Discrete Factor will be column 18, The binary result of the AM/FM-based classification.
#Flux.onehotbatch(DBDATA[!, Col18], unique(DBDATA[!, Col18]))

#establishing the testing/training data portions
Random.seed!(42)
n_train = convert(Int64, round(0.7*size(DBDATA, 1); digits=0))
training_indices = unique(rand(1:size(DBDATA, 1), n_train))
testing_indices = filter(x -> !(x in training_indices), 1:size(DBDATA,1))


#code block to set up the training and testing data
#features
train = Array(DBDATA[training_indices, 1:(end-1)])'
testing = Array(DBDATA[testing_indices, 1:(end-1)])' #testing features
#descrete factors
trainClassification = DBDATA[training_indices, end]
testClassification = DBDATA[testing_indices, end]
#labels
trainLabels = Flux.onehotbatch(trainClassification, sort(unique(trainClassification)))
testLabels = Flux.onehotbatch(testClassification, sort(unique(testClassification)))

#Model is defined with 19 features and 2 Possible outputs (Problematic or Non-Problematic)
one_layer = Chain(Dense(19, 2), sigmoid)

untrained_pred = Flux.onecold(one_layer(testing))
untrained_acc = mean(untrained_pred .== Flux.onecold(testLabels))
#println(untrained_acc)
#Result: 0.49568221070811747
#println(untrained_pred)
#Result: List of only 1's


#Hidden Layer info:
hiddenNodes = 38
hiddenLayerModel = Chain(  Dense(19, hiddenNodes, sigmoid), Dense( hiddenNodes, 2), sigmoid)



#Gradient Decent Optimizer
optimizer = Descent(0.01)

#Loss Function
loss_func(x, y) = Flux.crossentropy(hiddenLayerModel(x), y)


#=       TRAINING THE Model
#Training pseudo

training --> (loss fucntion, params(layer), [features, labels] )
    prediction = Flux.onecold(one_layer(tst_features))
    accuracy = mean(prediction data vectorize(.==) test labels)


#Results: 0.5077720207253886
println(epoch_1_prediction)
#Results: : List of Only 2's
LOOPED TRAINING      =#

e = Int64[]
TrainingLoss = Float64[]
TestingLoss = Float64[]

#Training and Testing
for epoch in 1:500
    #weight = rand(-1.0:.001:1.0)
    Flux.train!(loss_func, params(hiddenLayerModel), [(train, trainLabels)], optimizer)
    push!(e, epoch)
    push!(TestingLoss, loss_func(testing, testLabels))
    push!(TrainingLoss, loss_func(train, trainLabels))
    #println(mean(Flux.onecold(hiddenLayerModel(test)) .== Flux.onecold(testLabels)))
end


#Graphing
plot(e, TrainingLoss, lab="Training", c=:black, lw=2);
plot!(e, TestingLoss, lab="Testing", c=:teal, ls=:dot);
#plot(mean(Flux.onecold(hiddenLayerModel(train)) .== Flux.onecold(trainLabels)))
    #Error: oadError: Cannot convert Float64 to series data for plotting
yaxis!("Loss Function", :log);
xaxis!("Training epoch");
savefig("plot.png")
#Accurracy
println(mean(Flux.onecold(hiddenLayerModel(train)) .== Flux.onecold(trainLabels)))

println(ConfusionMatrix(testing, testLabels))


println()