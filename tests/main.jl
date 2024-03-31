# 2-opt algorithm
import Random
using Concorde, Test
using Random, Base.Math
include("generate_dist.jl")
include("implementations.jl")
include("Strategies.jl")

n_nodes = 10
# (dist/1000) 해줘야 함!
X, Y, dist = generate_distance_matrix(n_nodes)
opt_tour, opt_len = solve_tsp(X, Y; dist="EUC_2D")


# optimailty gap = (heuristic_tour_length - optimal_tour_length) / optimal_tour_length 

tour = collect(1:n_nodes)
#1. 2-opt algorithm implementations
first_stratege_tour, first_strategy_tour_len = two_opt_first_implement(tour, dist)
second_strategy_tour, second_strategy_tour_len = two_opt_second_implement(tour, dist)

#2. two strategies
first_tour, first_tour_len = two_opt_first_strategy(tour, dist)
second_tour, second_tour_len = two_opt_second_strategy(tour, dist)
heuristic_tour, heuristic_tour_len = heuristic_strategy(tour, dist)

opt_gap_first = (first_tour_len - opt_len) / opt_len
opt_gap_second = (second_tour_len - opt_len) / opt_len
opt_gap_heuristic = (heuristic_tour_len - opt_len) / opt_len


@show 