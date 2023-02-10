function parameters = define_parameters()

    parameters = struct( ...
      'a1', 380, ...  [mm]
        'a2', 1040, ...  [mm]
        'a3', 1191, ...  [mm]
        ...
        'd_1_min', 0, ...                   [mm]
        'd_1_max', 1900, ...                [mm]
        'theta_2_min', -deg2rad(90), ...    [rad]
        'theta_2_max', deg2rad(90), ...     [rad]
        'theta_3_min', -deg2rad(120), ...   [rad]
        'theta_3_max', deg2rad(120), ...    [rad]
        ...
         'v_1_max', 166.6, ...             [mm/s]
        'v_2_max', deg2rad(89.1), ...    [rad/s]
        'v_3_max', deg2rad(187.5));   %   [rad/s]

end