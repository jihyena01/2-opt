using Plots
import Plots

function tour_length(tour, dist)
    tour_len = 0
    for i in 1:(length(tour))
        j = i + 1 > length(tour) ? 1 : i + 1
        tour_len += dist[tour[i], tour[j]]
    end
    return tour_len
end


function plot_tour(X, Y, tour_edges)
    # 각 플롯 호출에 스타일을 직접 적용
    plot = Plots.plot(legend = false, 
                background_color = :white, 
                grid = false, 
                aspect_ratio = 1, 
                xlabel = "X Axis", 
                ylabel = "Y Axis")

    # 노드를 그리는 부분
    scatter!(X, Y, 
             markersize = 4, 
             markercolor = :black, 
             markerstrokecolor = :white)

    # 간선을 그리는 부분
    for (i, j) in tour_edges
        plot!([X[i], X[j]], [Y[i], Y[j]], 
              color = :gray, 
              alpha = 0.5, 
              linewidth = 1)
    end

    return plot
end



function generate_and_save_plots(X, Y, total_tour_edges, filename)
    plot = plot_tour(X, Y, total_tour_edges)
    savefig(plot, filename)
end

function generate_distance_matrix(n_nodes)
    X = rand(n_nodes) .* 1000
    Y = rand(n_nodes) .* 1000


    dist_matrix = zeros(n_nodes, n_nodes)  # dist_matrix 초기화

    for i in 1:n_nodes
        for j in 1:n_nodes
            dist_matrix[i, j] = *(sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2))
        end
    end
    

    return X, Y, dist_matrix
end