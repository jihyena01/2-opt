# 2-opt algorithm
import Random,Plots
using Concorde, Test
using Random, Base.Math, Plots
include("../src/functions.jl")
include("../src/implementations.jl")
include("../src/strategies.jl")

n_nodes = 30
# (dist/1000) 해줘야 함!
X, Y, dist = generate_distance_matrix(n_nodes)
opt_tour, opt_len = solve_tsp(X, Y; dist="EUC_2D")


# optimailty gap = (heuristic_tour_length - optimal_tour_length) / optimal_tour_length 

tour = collect(1:n_nodes)

#1. 2-opt algorithm implementations
@time first_imp_tour, first_imp_tour_len = two_opt_first_implement(tour, dist)
@time second_imp_tour, second_imp_tour_len = two_opt_second_implement(tour, dist)

opt_gap_first_imp = (first_imp_tour_len - opt_len) / opt_len
opt_gap_second_imp = (second_imp_tour_len - opt_len) / opt_len

#2. two strategies
@time first_tour, first_tour_len, total_tour_edges = two_opt_first_strategy(tour, dist)
@time second_tour, second_tour_len = two_opt_second_strategy(tour, dist)
@time heuristic_tour, heuristic_tour_len = heuristic_strategy(tour, dist)

opt_gap_first = (first_tour_len - opt_len) / opt_len
opt_gap_second = (second_tour_len - opt_len) / opt_len 
opt_gap_heuristic = (heuristic_tour_len - opt_len) / opt_len 


# show the images
let
    count = 0
    anim = @animate for tour_edges in total_tour_edges
        count +=1
        generate_and_save_plots(X, Y, tour_edges, "png/first_strategy_$count.png")
    end
    gif(anim, "tsp.gif", fps = 1)
end