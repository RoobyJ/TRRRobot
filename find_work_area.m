function [available_points] = find_work_area(parameters)

    samples_number_per_joint_d_1 = 25;
    d_1_samples = linspace(parameters.d_1_min, parameters.d_1_max, samples_number_per_joint_d_1);
    samples_number_per_joint_theta_2 = 25;
    theta_2_samples = linspace(parameters.theta_2_min, parameters.theta_2_max, samples_number_per_joint_theta_2);
    samples_number_per_joint_theta_3 = 25;
    theta_3_samples = linspace(parameters.theta_3_min, parameters.theta_3_max, samples_number_per_joint_theta_3);
    
    available_points = struct(...
        'x', zeros(samples_number_per_joint_d_1 * samples_number_per_joint_theta_2 * samples_number_per_joint_theta_3, 1), ...
        'y', zeros(samples_number_per_joint_d_1 * samples_number_per_joint_theta_2 * samples_number_per_joint_theta_3, 1), ...
        'z', zeros(samples_number_per_joint_d_1 * samples_number_per_joint_theta_2 * samples_number_per_joint_theta_3, 1));
    
    i = 1;
    for t1_index = 1:samples_number_per_joint_d_1
        for t2_index = 1:samples_number_per_joint_theta_2
            for t3_index = 1:samples_number_per_joint_theta_3
                [~, X] = forward_kinematic(d_1_samples(t1_index), theta_2_samples(t2_index), theta_3_samples(t3_index), parameters);
                available_points.x(i) = X(1);
                available_points.y(i) = X(2);
                available_points.z(i) = X(3);
                i = i + 1;
            end
        end
    end
    
end