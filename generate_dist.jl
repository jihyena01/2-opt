

function generate_distance_matrix(n_nodes)
    X = rand(n_nodes) .* 1000
    Y = rand(n_nodes) .* 1000


    dist_matrix = zeros(n_nodes, n_nodes)  # dist_matrix 초기화

    for i in 1:n_nodes
        for j in 1:n_nodes
            dist_matrix[i, j] = sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2)
        end
    end
    
    
    dist_matrix = round.(Int, 1000 .* dist_matrix)
    return X, Y, dist_matrix
end