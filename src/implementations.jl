
#1. 2-opt algorithm
# To calculate the tour length after creating a new tour.

function two_opt_first_implement(tour, dist)
    tour = copy(tour)
    tour_len = tour_length(tour, dist)
    n_nodes = length(tour)
    cur_edge1, cur_edge2 = (0, 0), (0, 0)
    
    for i in 1:(n_nodes-1)
        for j in (i+2):(n_nodes)
            new_tour = copy(tour)
            cur1 = i
            cur2 = i+1
            new1 = j
            new2 = (j + 1) > n_nodes ? 1 : j + 1
            # new_edge1 = (new_tour[i], new_tour[j])
            # new_edge2_index = j + 1 > n_nodes ? 1 : j + 1
            # new_edge2 = (new_tour[i+1], new_tour[new_edge2_index])
            cur_edge1 = (tour[cur1], tour[cur2])
            cur_edge2 = (tour[new1], tour[new2])
            
            middle_part = reverse(new_tour[(cur2):(new1)])
            new_tour[(cur2):(new1)] = middle_part
            
            new_tour_len = tour_length(new_tour, dist)

            if new_tour_len < tour_len
                #@show(tour)
                tour = new_tour
                tour_len = new_tour_len
                tour_edges = [(tour[i], tour[i+1]) for i in 1:(length(tour)-1)]
                #@show(cur_edge1, cur_edge2)
                #@show(tour)
                #print(new_edge1, new_edge2, tour, tour_len)
            end
        end
    end
    return tour, tour_len
end


# To calculate the improvement directly without creating a new tour

function two_opt_second_implement(tour, dist)
    tour = copy(tour)
    n_nodes = length(tour)
    tour_len = 0
    cur_edge1, cur_edge2 = (0, 0), (0, 0)

    for i in 1:(n_nodes-1)
        for j in (i+2):(n_nodes)
            cur1 = i
            cur2 = i+1
            new1 = j
            new2 = (j + 1) > n_nodes ? 1 : j + 1

            cur_edge1 = (tour[cur1], tour[cur2])
            cur_edge2 = (tour[new1], tour[new2])
            
            if (dist[tour[cur1], tour[cur2]] + dist[tour[new1], tour[new2]]) > (dist[tour[cur1], tour[new1]] + dist[tour[cur2], tour[new2]]) 
                improvement = (dist[tour[cur1], tour[cur2]] + dist[tour[new1], tour[new2]]) - (dist[tour[cur1], tour[new1]] + dist[tour[cur2], tour[new2]])
                
                #print(improvement)

                if improvement > 0
                    #@show(tour)
                    middle_part = reverse(tour[(cur2):(new1)])
                    tour[(cur2):(new1)] = middle_part
                    tour_len = tour_length(tour, dist)
                    tour_edges = [(tour[i], tour[i+1]) for i in 1:(length(tour)-1)]

                    #@show(cur_edge1, cur_edge2)
                    #@show(tour)
                end
            end
            
        end
    end
    return tour, tour_len
end
