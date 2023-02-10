parameters = define_parameters();

%% Zdefiniowanie punktu poczatkowego i koncowego
disp('Zdefiniuj punkt startowy w przestrzeni złaczy:');
while true
    prompt = ['d_1 startowe z zakresu [', num2str((parameters.d_1_min), 5), ', ', num2str((parameters.d_1_max), 5), '] [mm]:'];
    d_1_start = input(prompt);
    if ( (d_1_start >= parameters.d_1_min) && (d_1_start <= parameters.d_1_max) )
        break;
    else
        warning('Wartość z poza zakresu dopuszczalnego!');
    end
end
 
while true
    prompt = ['theta_2 startowe z zakresu [', num2str(rad2deg(parameters.theta_2_min), 5), ', ', num2str(rad2deg(parameters.theta_2_max), 5), '] [deg]:'];
    theta_2_start = deg2rad(input(prompt));
    if ( (theta_2_start >= parameters.theta_2_min) && (theta_2_start <= parameters.theta_2_max) )
        break;
    else
        warning('Wartość z poza zakresu dopuszczalnego!');
    end
end

while true
    prompt = ['theta_3 startowe z zakresu [', num2str(rad2deg(parameters.theta_3_min), 5), ', ', num2str(rad2deg(parameters.theta_3_max), 5), '] [deg]:'];
    theta_3_start = deg2rad(input(prompt));
    if ( (theta_3_start >= parameters.theta_3_min) && (theta_3_start <= parameters.theta_3_max) )
        break;
    else
        warning('Wartość z poza zakresu dopuszczalnego!');
    end
end
 
start_point.d_1 = d_1_start;
start_point.theta_2 = theta_2_start;
start_point.theta_3 = theta_3_start;

disp('Zdefiniuj punkt końcowy w przestrzeni złaczy:');
while true
    prompt = ['d_1 koniec z zakresu [', num2str((parameters.d_1_min), 5), ', ', num2str((parameters.d_1_max), 5), '] [mm]:'];
    d_1_end = input(prompt);
    if ( (d_1_end >= parameters.d_1_min) && (d_1_end <= parameters.d_1_max) )
        break;
    else
        warning('Wartość z poza zakresu dopuszczalnego!');
    end
end
 
while true
    prompt = ['theta_2 koniec z zakresu [', num2str(rad2deg(parameters.theta_2_min), 5), ', ', num2str(rad2deg(parameters.theta_2_max), 5), '] [deg]:'];
    theta_2_end = deg2rad(input(prompt));
    if ( (theta_2_end >= parameters.theta_2_min) && (theta_2_end <= parameters.theta_2_max) )
        break;
    else
        warning('Wartość z poza zakresu dopuszczalnego!');
    end
end

while true
    prompt = ['theta_3 koniec z zakresu [', num2str(rad2deg(parameters.theta_3_min), 5), ', ', num2str(rad2deg(parameters.theta_3_max), 5), '] [deg]:'];
    theta_3_end = deg2rad(input(prompt));
    if ( (theta_3_end >= parameters.theta_3_min) && (theta_3_end <= parameters.theta_3_max) )
        break;
    else
        warning('Wartość z poza zakresu dopuszczalnego!');
    end
end
 
end_point.d_1 = d_1_end;
end_point.theta_2 = theta_2_end;
end_point.theta_3 = theta_3_end;

%% Obliczenie trajektorii i predkosci
trajectory_joints = generate_joint_trajectory(start_point, end_point, parameters);
trajectory_cartesian = calculate_cartesian_trajectory(trajectory_joints, parameters);

%% Wyrysowanie polozenia i predkosci
available_points = find_work_area(parameters);
 
figure;
title('Obszar dopuszczalny');
grid on;
hold on;
xlabel('x [mm]');
ylabel('y [mm]');
zlabel('z [mm]');
axis tight;
plot3(available_points.x, available_points.y, available_points.z, 'b.', 'DisplayName', 'Obszar dopuszczalny');

figure;
 
subplot(3, 2, 1);
title('Prędkości w złączach');
grid on;
hold on;
xlabel('Czas [s]');
ylabel('d_{1} [mm/s]');
axis tight;
plot(trajectory_joints.t, rad2deg(trajectory_joints.omega_1), 'LineWidth', 2);
 
subplot(3, 2, 2);
title('Pozycje w złączach');
grid on;
hold on;
xlabel('Czas [s]');
ylabel('d_{1} [mm]');
axis tight;
plot(trajectory_joints.t, (trajectory_joints.theta_1), 'LineWidth', 2);
 
subplot(3, 2, 3);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('\omega_{2} [deg/s]');
axis tight;
plot(trajectory_joints.t, rad2deg(trajectory_joints.omega_2), 'LineWidth', 2);
 
subplot(3, 2, 4);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('\theta_{2} [deg]');
axis tight;
plot(trajectory_joints.t, rad2deg(trajectory_joints.theta_2), 'LineWidth', 2);
 
subplot(3, 2, 5);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('\omega_{3} [deg/s]');
axis tight;
plot(trajectory_joints.t, rad2deg(trajectory_joints.omega_3), 'LineWidth', 2);
 
subplot(3, 2, 6);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('\theta_{3} [deg]');
axis tight;
plot(trajectory_joints.t, rad2deg(trajectory_joints.theta_3), 'LineWidth', 2);

[~, max_vel_index] = max(trajectory_cartesian.v);
 
figure;
 
subplot(3, 2, 1);
title('Prędkości kartezjańskie');
grid on;
hold on;
xlabel('Czas [s]');
ylabel('v_{x} [mm/s]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.vx, 'LineWidth', 2);
plot(trajectory_cartesian.t(max_vel_index), trajectory_cartesian.vx(max_vel_index), 'r*', 'LineWidth', 4)
 
subplot(3, 2, 2);
title('Pozycje kartezjańskie');
grid on;
hold on;
xlabel('Czas [s]');
ylabel('x [mm]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.x, 'LineWidth', 2);

subplot(3, 2, 3);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('v_{y} [mm/s]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.vy, 'LineWidth', 2);
plot(trajectory_cartesian.t(max_vel_index), trajectory_cartesian.vy(max_vel_index), 'r*', 'LineWidth', 4)
 
subplot(3, 2, 4);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('y [mm]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.y, 'LineWidth', 2);

subplot(3, 2, 5);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('v_{z} [mm/s]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.vz, 'LineWidth', 2);
plot(trajectory_cartesian.t(max_vel_index), trajectory_cartesian.vz(max_vel_index), 'r*', 'LineWidth', 4)

subplot(3, 2, 6);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('z [mm]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.z, 'LineWidth', 2);

available_points = find_work_area(parameters);
 
figure;
title('Trajektoria 3D i obszar dopuszczalny');
grid on;
hold on;
xlabel('x [mm]');
ylabel('y [mm]');
zlabel('z [mm]');
axis tight;
plot3(available_points.x, available_points.y, available_points.z, 'b.', 'DisplayName', 'Obszar dopuszczalny');
plot3(trajectory_cartesian.x, trajectory_cartesian.y, trajectory_cartesian.z, 'g:o', 'LineWidth', 2, 'DisplayName', 'Trajektoria');
plot3(0, 0, 0, 'r+', 'DisplayName', 'Punkt [0, 0, 0]');
legend('show');

figure;
 
subplot(3, 1, 1);
title('Droga na kierunkach');
grid on;
hold on;
xlabel('Czas [s]');
ylabel('s_{x} [mm]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.sx, 'LineWidth', 2);
 
subplot(3, 1, 2);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('s_{y} [mm]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.sy, 'LineWidth', 2);
 
subplot(3, 1, 3);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('s_{z} [mm]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.sz, 'LineWidth', 2);

figure;

title('Droga w przestrzeni kartezjańskiej');
grid on;
hold on;
xlabel('Czas [s]');
ylabel('s [mm]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.s, 'LineWidth', 2);

figure;

title('Prędkości w przestrzeni kartezjańskiej');
grid on;
hold on;
xlabel('Czas [s]');
ylabel('v [mm/s]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.v, 'LineWidth', 2);
plot(trajectory_cartesian.t(max_vel_index), trajectory_cartesian.v(max_vel_index), 'r*', 'LineWidth', 4)
