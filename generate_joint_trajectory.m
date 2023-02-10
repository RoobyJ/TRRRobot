function trajectory_joints = generate_joint_trajectory(start_point, end_point, parameters)

    %% Czasu ruchu
    s1 = end_point.d_1 - start_point.d_1;
    s2 = end_point.theta_2 - start_point.theta_2;
    s3 = end_point.theta_3 - start_point.theta_3;

    t_1_min = (4/3) * abs(s1) / parameters.v_1_max;
    t_2_min = (4/3) * abs(s2) / parameters.v_2_max;
    t_3_min = (4/3) * abs(s3) / parameters.v_3_max;

    t = max([t_1_min, t_2_min, t_3_min]);
    delta = t / 4;
    
    %% Predkosci i pozycje zlaczowe
    v_1_max = s1 / 3 / delta;
    v_2_max = s2 / 3 / delta;
    v_3_max = s3 / 3 / delta;
    
    a_1 = v_1_max / delta;
    a_2 = v_2_max / delta;
    a_3 = v_3_max / delta;

    samples_number = 100;

    t = [linspace(0, delta, samples_number), linspace(delta, 3 * delta, 2 * samples_number), linspace(3 * delta, 4 * delta, samples_number)];

    v_1 = [linspace(0, 1, samples_number) * v_1_max, linspace(1, 1, 2 * samples_number) * v_1_max, linspace(1, 0, samples_number) * v_1_max];
    v_2 = [linspace(0, 1, samples_number) * v_2_max, linspace(1, 1, 2 * samples_number) * v_2_max, linspace(1, 0, samples_number) * v_2_max];
    v_3 = [linspace(0, 1, samples_number) * v_3_max, linspace(1, 1, 2 * samples_number) * v_3_max, linspace(1, 0, samples_number) * v_3_max];

    theta_1 = start_point.d_1 + [(0.5 * a_1 * linspace(0, delta, samples_number).^2), ...
        (0.5 * a_1 * delta^2 + linspace(0, 2 * delta, 2 * samples_number) * v_1_max), ...
        (0.5 * a_1 * delta^2 + 2 * delta * v_1_max + (v_1_max * linspace(0, delta, samples_number) -0.5 * a_1 * linspace(0, delta, samples_number).^2))];
    theta_2 = start_point.theta_2 + [(0.5 * a_2 * linspace(0, delta, samples_number).^2), ...
        (0.5 * a_2 * delta^2 + linspace(0, 2 * delta, 2 * samples_number) * v_2_max), ...
        (0.5 * a_2 * delta^2 + 2 * delta * v_2_max + (v_2_max * linspace(0, delta, samples_number) -0.5 * a_2 * linspace(0, delta, samples_number).^2))];
    theta_3 = start_point.theta_3 + [(0.5 * a_3 * linspace(0, delta, samples_number).^2), ...
        (0.5 * a_3 * delta^2 + linspace(0, 2 * delta, 2 * samples_number) * v_3_max), ...
        (0.5 * a_3 * delta^2 + 2 * delta * v_3_max + (v_3_max * linspace(0, delta, samples_number) -0.5 * a_3 * linspace(0, delta, samples_number).^2))];
    
    %% Struktura wyjściowa
    [t, ia, ~] = unique(t);
    
    trajectory_joints = struct( ...
        't', t, ...
        ...
        'theta_1', theta_1(ia), ...
        'theta_2', theta_2(ia), ...
        'theta_3', theta_3(ia), ...
        ...
        'omega_1', v_1(ia), ...
        'omega_2', v_2(ia), ...
        'omega_3', v_3(ia));
end

