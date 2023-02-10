parameters = define_parameters();

%% Startowy i koncowy punkt
disp('Zdefiniuj punkt startowy w przestrzeni kartezjanskiej:');
start_point = select_point_in_cartesian(parameters);
disp('Zdefiniuj punkt końcowy w przestrzeni kartezjanskiej:');
end_point = select_point_in_cartesian(parameters);

%% Wyznaczenie trajektorii
trajectory = struct('x', [], 'y', [], 'z', [], 'points_number_in_trajectory', 0, 'knot_number', 0, 'spline_points', start_point);

spline_points = generate_trajectory(start_point, end_point, parameters, trajectory);
[trajectory_cartesian, bezier_points] = generate_bezier_curves(spline_points.spline_points);
trajectory_joints = calculate_joint_trajectory(trajectory_cartesian, parameters);

rozmiar1= size(trajectory_joints.theta_2_velocity);


tt1= trajectory_joints.t(end)/rozmiar1(2);
tt2= trajectory_joints.t(end)/rozmiar1(2);

xp=trajectory_joints.theta_2(1);
yp=trajectory_joints.theta_3(1);
vt1=trajectory_joints.theta_2_velocity;
vt2=trajectory_joints.theta_3_velocity;

for i=1:1:rozmiar1(2)                     
    xx(i)=xp+vt1(i)*tt1;
    yy(i)=yp+vt2(i)*tt2;
    xp=xx(i);
    yp=yy(i);
end

%% Ploty



figure;

subplot(3, 2, 1);
title('Prędkości w złączach');
grid on;
hold on;
xlabel('Czas [s]');
ylabel('d''_{1} [mm/s]');
axis tight;
plot(trajectory_joints.t, rad2deg(trajectory_joints.d_1_velocity), 'LineWidth', 2);

subplot(3, 2, 2);
title('Pozycje w złączach');
grid on;
hold on;
xlabel('Czas [s]');
ylabel('d_{1} [mm]');
axis tight;
plot(trajectory_joints.t, trajectory_joints.d_1, 'LineWidth', 2 );

subplot(3, 2, 3);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('\theta''_{2} [deg/s]');
axis tight;
plot(trajectory_joints.t, rad2deg(trajectory_joints.theta_2_velocity), 'LineWidth', 2);

subplot(3, 2, 4);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('\theta_{2} [deg]');
axis tight;

plot(trajectory_joints.t, rad2deg(xx), 'LineWidth', 2);

subplot(3, 2, 5);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('\theta''_{3} [deg/s]');
axis tight;
plot(trajectory_joints.t, rad2deg(trajectory_joints.theta_3_velocity), 'LineWidth', 2);

subplot(3, 2, 6);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('\theta_{3} [deg]');
axis tight;


plot(trajectory_joints.t, rad2deg(yy), 'LineWidth', 2);

figure;

subplot(3, 2, 1);
title('Prędkości kartezjańskie');
grid on;
hold on;
xlabel('Czas [s]');
ylabel('x'' [mm/s]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.vx, 'LineWidth', 2);

subplot(3, 2, 2);
title('Pozycje w złączach');
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
ylabel('y'' [mm/s]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.vy, 'LineWidth', 2);

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
ylabel('z'' [mm/s]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.vz, 'LineWidth', 2);

subplot(3, 2, 6);
grid on;
hold on;
xlabel('Czas [s]');
ylabel('z [mm]');
axis tight;
plot(trajectory_cartesian.t, trajectory_cartesian.z, 'LineWidth', 2);

figure;
available_points = find_work_area(parameters);
title('Trajektoria na tle przestrzeni roboczej');
grid on;
hold on;
xlabel('x [mm]');
ylabel('y [mm]');
zlabel('z [mm]');
axis tight;
axis equal;
plot3(available_points.x, available_points.y, available_points.z, 'b.', 'DisplayName', 'Przestrzen robocza');
plot3(bezier_points.x, bezier_points.y, bezier_points.z, 'go', 'LineWidth', 2, 'DisplayName', 'Punkty definiujace krzywe Beziera');
plot3(trajectory_cartesian.x, trajectory_cartesian.y, trajectory_cartesian.z, 'r:', 'LineWidth', 2, 'DisplayName', 'Trajektoria');

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
plot(trajectory_cartesian.t, trajectory_cartesian.droga, 'LineWidth', 2);
