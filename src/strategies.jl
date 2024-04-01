using Random, Base.Math

#2. two strategies
# (i) Among all possible 2-opt swaps, choose the best one.

function two_opt_first_strategy(tour, dist)
    tour = copy(tour)
    tour_len = tour_length(tour, dist)
    total_tour_edges = []
    current_tour_edges = [(tour[i], tour[i % length(tour) + 1]) for i in 1:length(tour)]
    push!(total_tour_edges, current_tour_edges)


    improvement = 0
    best_cur1, best_cur2 = 0, 0
    best_new1, best_new2 = 0, 0
    improved = true

    while improved
        best_improvement = 0
        improved = false
        cur_edge1 = (0, 0)
        cur_edge2 = (0, 0)
        for i in 1:(length(tour)-1)
            for j in (i+2):(length(tour))
                cur1 = i
                cur2 = i+1
                new1 = j
                new2 = (j + 1) > length(tour) ? 1 : j + 1

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
        # @show(tour)
        if improved == true
            cur_edge1 = (tour[best_cur1], tour[best_cur2])
            cur_edge2 = (tour[best_new1], tour[best_new2])
            middle_part = reverse(tour[(best_cur2):(best_new1)])
            tour[(best_cur2):(best_new1)] = middle_part

            tour_len = tour_length(tour, dist)
            current_tour_edges = [(tour[i], tour[i % length(tour) + 1]) for i in 1:length(tour)]
            push!(total_tour_edges, current_tour_edges)
        
            # @show(cur_edge1, cur_edge2)
            # @show(tour)
        end
    end
    return tour, tour_len, total_tour_edges
end

# (ii) Accept the first improving 2-opt swap.
function two_opt_second_strategy(tour, dist)
    tour = copy(tour)
    improvement = 0
    tour_len = tour_length(tour, dist)
    best_cur1, best_cur2 = 0, 0
    best_new1, best_new2 = 0, 0
    cur_edge1, cur_edge2 = (0, 0), (0, 0)
    improved = true
    #tour_edges = [(tour[i], tour[i+1]) for i in 1:(length(tour)-1)]
    while improved
        best_improvement = 0
        improved = false
        for i in 1:(length(tour)-1)
            for j in (i+2):(length(tour))
                cur1 = i
                cur2 = i+1
                new1 = j
                new2 = (j + 1) > length(tour) ? 1 : j + 1

                cur_edge1 = (tour[cur1], tour[cur2])
                cur_edge2 = (tour[new1], tour[new2])
                
                improvement = (dist[tour[cur1], tour[cur2]] + dist[tour[new1], tour[new2]]) - (dist[tour[cur1], tour[new1]] + dist[tour[cur2], tour[new2]])
                if improvement > 0
                    # @show(tour)
                    middle_part = reverse(tour[(cur2):(new1)])
                    tour[(cur2):(new1)] = middle_part
                    tour_len = tour_length(tour, dist)
                    # @show(cur_edge1, cur_edge2)
                    # @show(tour)
                    
                end
            end
        end
    end
    return tour, tour_len
end


function heuristic_strategy(tour, dist)
    tour = copy(tour)
    tour_len = tour_length(tour, dist)
    improvement = 0
    temperature = 100
    t_rate = 0.99
    count = 0
    cur_edge1, cur_edge2 = (0, 0), (0, 0)
    improved = true
    while improved
        improved = false

        for i in 1:(length(tour)-1)
            for j in (i+2):(length(tour))
                
                cur1 = i
                cur2 = i+1
                new1 = j
                new2 = (j + 1) > length(tour) ? 1 : j + 1
                

                new_edge1 = (tour[cur1], tour[new1])
                new_edge2 = (tour[cur2], tour[new2])
                
                improvement = (dist[tour[cur1], tour[cur2]] + dist[tour[new1], tour[new2]]) - (dist[tour[cur1], tour[new1]] + dist[tour[cur2], tour[new2]])

                if improvement > 0 || rand() < exp((improvement) / temperature)
                    # @show(tour)
                    cur_edge1 = (tour[cur1], tour[cur2])
                    cur_edge2 = (tour[new1], tour[new2])
                    middle_part = reverse(tour[(cur2):(new1)])
                    tour[(cur2):(new1)] = middle_part
                    tour_len = tour_length(tour, dist)
                   
                    # @show(cur_edge1, cur_edge2)
                    # @show(tour)
                    improved = true
                end
            end
            count += 1
        end
        temperature *=  t_rate

        if count >= 10000
            break 
        end
    end
    return tour, tour_len
end

