#Anthony Verdone
#CIS 400
#HW3 - March 22nd 2022

#= PROMT ================================================================================
Use (any variant of) Evolution Strategies,
and compare with the previous results (of HW1-2). 
=================================================================================================#
using Flux
using CSV
using DataFrames
using Random
using Statistics
using StatsPlots
using Setfield
using Evolutionary

mutable struct Chromosome
    genes #chromosome values
    objValue::Int #objective fucntion
    fitness::Float64 #fitness 
    fitnessprobability::Float64  #fitness probability
end

#Objective funtion for selection
function objectiveFunc(Arr)
    result = sum(Arr)
    return result
end


#Fitness funtion
function FitnessFunc(ObjValue)
    #since we are trying to result chrmomosome list of only 10's
    result = (1 /(101 - ObjValue))
    #the highest ObjValue can be 100 (expected),
    #using 101 to avoid divide by zero error
    return result
end

#calclulating sum of all fitnesses, needed for fitness probablility
function CalculateTotal(Arr)
    total = 0.0
    for x in eachindex(Arr)
        total = total + (Arr[x].fitness)
    end
    return total
end

#calculating fitness probablility
function FitnessProbability(Arr)
    total = CalculateTotal(Arr)
    for x in eachindex(Arr)
        #s = @set s.a = 5 {how to use the setfield lib}
        Arr[x].fitnessprobability = (Arr[x].fitness / total)
    end
    return Arr
end


#initialize population 
function generatePopulation(PopulationSize)
    population = []
    for x in 1:PopulationSize
        chValues = rand(1:10, 10)
        obj = objectiveFunc(chValues)
        fitness = FitnessFunc(obj)
        ch = Chromosome(chValues, obj, fitness, 0.0)
        push!(population, ch)
         
    end
    return population
end

function crossover(parent1, parent2)
    #one point crossover
    point = 7 #parent1 will pass on genes 1-7

    offspring_half1  = parent1.genes[1:point]
    offspring_half2 = parent2.genes[8:10]

    append!(offspring_half1, offspring_half2)

    obj = objectiveFunc(offspring_half1)
    fitness = FitnessFunc(obj)

    offspring = Chromosome(offspring_half1, obj, fitness, 0.0)

    return offspring
end
#=
function Tournament(population)
    population = shuffle(population)
    NewGeneration = []
    i = 1
    j = 2
    for _ in (1:((length(population)) / 2))
        parent1 = population[i]
        parent2 = population[j]
        if ((parent1.fitnessprobability) > (parent2.fitnessprobability))
            offspring = crossover(parent1, parent2)

        
        elseif ((parent1.fitnessprobability) < (parent2.fitnessprobability))
            offspring = crossover(parent2, parent1)
        
        else #equal fitness probablility
            randParent = [i, j]
            if isequal(randParent, i)
                offspring = crossover(parent1, parent2)
            else
                offspring = crossover(parent2, parent1)
            end
            
        end
        push!(NewGeneration, offspring)
        i += 2
        j += 2
    end
    return NewGeneration
end
=#

function mutate(chromosome)
    randChrom = rand(1:length(chromosome))
    randGene = rand(1:10)
    mutatedGene = rand(1:10)
    shuffle(chromosome.genes)
    popfirst!(chromosome.genes)
    push!((chromosome.genes), mutatedGene)

    #updating values
    obj = objectiveFunc(chromosome.genes)
    fitness = FitnessFunc(obj)

    chromosome.objValue = obj
    chromosome.fitness = fitness

    return chromosome
end

function avgFitness(population)
    total = 0.0
    for iter in (1:length(population))
        total += population[iter].objValue
    end
    return (total / length(population))
end
#=
function run_generation(population, mutation_rate, generations, avgs)
    push!(avgs, avgFitness(population))
    for currGen in (1:generations)
        #println(avgFitness(population))
        New_Generation = Tournament(population)
        #mutations every 10 generations
        if isequal((currGen % 10), 0)
            mutate(New_Generation, mutation_rate)
        end
        push!(avgs, avgFitness(New_Generation))
        if isequal(currGen, generations)
            return New_Generation
        end
    end
    #return New_Generation
end
=#
function es(objective, generations, step_size, mu, lamda)
    currGen = 0
    avgs = []
    # calculate the number of children per parent
    n_children = convert(Int,(lamda / mu))
    #generate popluation and sort by fitness
    population = generatePopulation(lamda)
    fitSort(x::Chromosome) = x.fitness

    for currGen in 1:generations

        population = sort(population, by=fitSort, rev = true)

        #select best of the parent population
        selected = population[1:mu]
        children = []
        #mutate and reporoduce using lamda and mu
        for x in selected
            for z in 1:n_children
                child = mutate(x)
                push!(children, child)
            end
        end

        #calculate averages
        push!(avgs, avgFitness(children))
    end

    plot(avgs, c=:black, lw=2);
    yaxis!("Fitness");
    xaxis!(" generation");
    savefig("hw3.png")

    
end


es(objectiveFunc, 25, 0.1, 100, 1000000)















