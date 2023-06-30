#Anthony Verdone
#CIS 400
#HW7 - May 3rd 2022

#= PROMT ================================================================================
Use Genetic Programming (with no neural network). Compare with the previous results (HW1-6).
Note:HW7 is optional, and is more difficult than HW1-6. 
If you have submitted all of HW1-6, you can use the HW7 grade to replace the lowest HW grade.
If you have not submitted any of HW1-6, you can use the HW7 grade to replace one missed HW grade.
=================================================================================================#

using Flux
using CSV
using DataFrames
using Random
using Statistics
using StatsPlots
using Setfield

mutable struct Individual
    #genes #chromosome values
    fitness::Float64 #fitness 
end
PopulationSize = 1000
Base.show(io::IO, f::Individual) = println(io, "Individual Fitness = ", f.fitness)


#funtions = [+, '-', '*', '/']
function add(x,y)#function 1
    return x + y
end

function sub(x,y)#function 2
    return x - y
end

function mult(x,y)#function 3
    return x * y
end

function div(x,y)#function 4
    return x / y 
end


function FitnessFunc(num1, num2, func)
    if(isequal(func, 1))
        result = add(num1, num2)
    end
    if(isequal(func, 2))
        result = sub(num1, num2)
    end
    if(isequal(func, 3))
        result = mult(num1, num2)
    end
    if(isequal(func, 4))
        result = div(num1, num2)
    end
    return result
end

#create population of computer programs
#initialize population 
function generatePopulation(PopulationSize)
    population = []
    for x in 1:PopulationSize
        num1 = rand(1:10)
        num2 = rand(1:10)
        func = rand(1:4)
        (fitness = FitnessFunc(num1, num2, func))*1.0
        #individual = Individual(fitness)
        push!(population, fitness)
    end
    return population
end

function avgFitness(population)
    total = 0.0
    for iter in (1:length(population))
        total += population[iter]
    end
    return (total / length(population))
end

function Selection(population, New_Population)
    #this function will impliiment crossover
    #by applying the 4 basic functions from the 
    #new population onto the existing
    New_Generation = []
    population = sort(population, rev=true)
    New_Population = sort(New_Population, rev=true)

    for x in 1:PopulationSize 
        func = rand(1:4)
        (fitness = FitnessFunc(population[x], New_Population[x], func))*1.0
        push!(New_Generation, fitness)
    end
    return New_Generation

end

function mutate(individual)
    func = rand(1:4)
    num = rand(1:10)
    (fitness = FitnessFunc(individual, num, func))*1.0
    return fitness

end

function remove!(a, item)
    deleteat!(a, findall(x->x==item, a))
end

function main()
    #Step 1: generate population
    PopulationSize = 1000
    population = generatePopulation(PopulationSize)
    #display(population)
    generations = 250
    currGen = 0
    avgs = []
    mutation_rate = (0.1 * (10 * (length(population))))
    #Step 2: Execute each program in the population and assign it a fitness value 
    #Start of the algorithm
    push!(avgs, avgFitness(population))
    #display(avgs)
    #Step 3: Create a new population of programs
    for currGen in (1:generations)
        #Step 3.1: Copy the best existing programs
        New_Population = generatePopulation(PopulationSize)
        #Step 3.2: Create new computer programs by crossover(sexual reproduction)
        New_Generation = Selection(population, New_Population)
        #Step 3.3: Create new computer programs by mutation (every 10 generations)
        if isequal((currGen % 10), 0)
            mutatedIndividual = rand(population)
            #remove!(population, mutatedIndividual)
            mutatedIndividual= mutate(mutatedIndividual)
            push!(population, mutatedIndividual)
        end
        push!(avgs, avgFitness(New_Generation))
    end
    plot(avgs, c=:black, lw=2);
    yaxis!("Fitness");
    xaxis!("Generation");
    savefig("hw7.png")
    
end
main()