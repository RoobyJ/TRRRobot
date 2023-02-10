function [R, X] = forward_kinematic(d_1, theta_2, theta_3, parameters)

    T01 = makehgtform('zrotate', 0)       * makehgtform('translate', [0 0 d_1]) * makehgtform('translate', [parameters.a1 0 0]) * makehgtform('xrotate', 0);
    T12 = makehgtform('zrotate', theta_2) * makehgtform('translate', [0 0 0])   * makehgtform('translate', [parameters.a2 0 0]) * makehgtform('xrotate', 0);
    T23 = makehgtform('zrotate', theta_3) * makehgtform('translate', [0 0 0])   * makehgtform('translate', [parameters.a3 0 0]) * makehgtform('xrotate', 0);

    T = T01 * T12 * T23;
    R = T(1:3, 1:3);
    X = T(1:3, 4);
    
end