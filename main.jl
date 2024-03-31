# 2-opt algorithm
import Random
using Concorde, Test
include("generate_dist.jl")

n_nodes = 10
# (dist/1000) 해줘야 함!
X, Y, dist = generate_distance_matrix(n_nodes)
opt_tour, opt_len = solve_tsp(X, Y; dist="EUC_2D")


# optimailty gap = (heuristic_tour_length - optimal_tour_length) / optimal_tour_length 

#1. 2-opt algorithm
# To calculate the tour length after creating a new tour.

function tour_length(tour, dist)
    tour_len = 0
    for i in 1:(length(tour))
        j = i + 1 > length(tour) ? 1 : i + 1
        tour_len += dist[tour[i], tour[j]]
    end
    return tour_len
end

function two_opt_first_implement(tour, dist)
    tour = copy(tour)
    for i in 1:(n_nodes-1)
        for j in (i+1):n_nodes
            new_tour = copy(tour)
            new_edge1 = (new_tour[i], new_tour[j])
            new_edge2_index = j + 1 > n_nodes ? 1 : j + 1
            new_edge2 = (new_tour[i+1], new_tour[new_edge2_index])
            

            middle_part = reverse(new_tour[(i+1):(j)])
            new_tour[(i+1):(j)] = middle_part
            
            new_tour_len = tour_length(new_tour, dist)

            if new_tour_len < tour_len
                tour = new_tour
                tour_len = new_tour_len
                tour_edges = [(tour[i], tour[i+1]) for i in 1:(length(tour)-1)]
                print(new_edge1, new_edge2, tour, tour_len)
            end
        end
    end
    return tour, tour_len
end
print(tour, tour_len/1000)

# To calculate the improvement directly without creating a new tour

function two_opt_second_implement(tour, dist)
    tour = copy(tour)
    n_nodes = length(tour)
    for i in 1:(n_nodes-1)
        for j in (i+1):n_nodes
            cur1 = i
            cur2 = i+1
            new1 = j
            new2 = (j + 1) > n_nodes ? 1 : j + 1

            new_edge1 = (tour[cur1], tour[new1])
            new_edge2 = (tour[cur2], tour[new2])
            
            if (dist[tour[cur1], tour[cur2]] + dist[tour[new1], tour[new2]]) > (dist[tour[cur1], tour[new1]] + dist[tour[cur2], tour[new2]]) 
                improvement = (dist[tour[cur1], tour[cur2]] + dist[tour[new1], tour[new2]]) - (dist[tour[cur1], tour[new1]] + dist[tour[cur2], tour[new2]])
                
                #print(improvement)

                if improvement > 0

                    middle_part = reverse(tour[(cur2):(new1)])
                    tour[(cur2):(new1)] = middle_part
                    tour_len = tour_length(tour, dist)
                    tour_edges = [(tour[i], tour[i+1]) for i in 1:(length(tour)-1)]

                    #print(new_edge1, new_edge2, tour, tour_len)
                end
            end
            
        end
    end
    return tour, tour_len
end
print(tour, tour_len/1000)


tour = collect(1:n_nodes)
#tour_len = tour_length(tour, dist)
#tour_edges = [(tour[i], tour[i+1]) for i in 1:(length(tour)-1)]
first_stratege_tour, first_strategy_tour_len = two_opt_first_implement(tour, dist)
second_strategy_tour, second_strategy_tour_len = two_opt_second_implement(tour, dist)


#2. two strategies
# (i) Among all possible 2-opt swaps, choose the best one.

function two_opt_first_strategy(tour, dist)
    tour = copy(tour)
    improvement = 0
    tour_len = tour_length(tour, dist)
    best_cur1, best_cur2 = 0, 0
    best_new1, best_new2 = 0, 0
    improved = true
    #tour_edges = [(tour[i], tour[i+1]) for i in 1:(length(tour)-1)]
    while improved
        best_improvement = 0
        improved = false
        for i in 1:(length(tour)-1)
            for j in (i+1):(length(tour))
                cur1 = i
                cur2 = i+1
                new1 = j
                new2 = (j + 1) > length(tour) ? 1 : j + 1

                new_edge1 = (tour[cur1], tour[new1])
                new_edge2 = (tour[cur2], tour[new2])
                
                improvement = (dist[tour[cur1], tour[cur2]] + dist[tour[new1], tour[new2]]) - (dist[tour[cur1], tour[new1]] + dist[tour[cur2], tour[new2]])
                if improvement > best_improvement
                    best_improvement = improvement
                    best_cur1, best_cur2 = cur1, cur2
                    best_new1, best_new2 = new1, new2
                    improved = true
                
                else
                    continue
                end

            end
        end
        middle_part = reverse(tour[(best_cur2):(best_new1)])
        tour[(best_cur2):(best_new1)] = middle_part
        tour_len = tour_length(tour, dist)        

    end
    return tour, tour_len
end

# (ii) Accept the first improving 2-opt swap.
function two_opt_second_strategy(tour, dist)
    tour = copy(tour)
    improvement = 0
    tour_len = tour_length(tour, dist)
    best_cur1, best_cur2 = 0, 0
    best_new1, best_new2 = 0, 0
    improved = true
    #tour_edges = [(tour[i], tour[i+1]) for i in 1:(length(tour)-1)]
    while improved
        best_improvement = 0
        improved = false
        for i in 1:(length(tour)-1)
            for j in (i+1):(length(tour))
                cur1 = i
                cur2 = i+1
                new1 = j
                new2 = (j + 1) > length(tour) ? 1 : j + 1

                new_edge1 = (tour[cur1], tour[new1])
                new_edge2 = (tour[cur2], tour[new2])
                
                improvement = (dist[tour[cur1], tour[cur2]] + dist[tour[new1], tour[new2]]) - (dist[tour[cur1], tour[new1]] + dist[tour[cur2], tour[new2]])
                if improvement > 0
                    middle_part = reverse(tour[(cur2):(new1)])
                    tour[(cur2):(new1)] = middle_part
                    tour_len = tour_length(tour, dist)
                    
                end
            end
        end
    end
    return tour, tour_len
end


tour = collect(1:n_nodes)
first_tour, first_tour_len = two_opt_first_strategy(tour, dist)
second_tour, second_tour_len = two_opt_second_strategy(tour, dist)


function heuristic_strategy(tour, dist)
    tour = copy(tour)
    improvement = 0
    temperature = 100
    improved = true
    while improved
        improved = false

        for i in 1:(length(tour)-1)
            for j in (i+1):(length(tour))
                
                cur1 = i
                cur2 = i+1
                new1 = j
                new2 = (j + 1) > length(tour) ? 1 : j + 1

                new_edge1 = (tour[cur1], tour[new1])
                new_edge2 = (tour[cur2], tour[new2])
                
                improvement = (dist[tour[cur1], tour[cur2]] + dist[tour[new1], tour[new2]]) - (dist[tour[cur1], tour[new1]] + dist[tour[cur2], tour[new2]])

                if improvement > 0 || rand() < exp((improvement) / temperature)
                    middle_part = reverse(tour[(cur2):(new1)])
                    tour[(cur2):(new1)] = middle_part
                    tour_len = tour_length(tour, dist)
                    improved = true
                end
            end
        end
    end
    return tour, tour_len
end



tour = collect(1:n_nodes)
heuristic_tour, heuristic_tour_len = heuristic_strategy(tour, dist)