%% A tutorial based introduction to kalman filtering
% Example: Object in freefall assuming no air resistance
% Using errors common for a laser range finder (+- 2m)
% Initialization
N = 1000; % LOOP SIZE
dt = 0.001; % TIME INCREMENT
t = dt*(1:N);
g = 9.80665; % gravity m/s^2

u = g; % INPUT VECTOR
F = [1 dt; 0 1]; % SYSTEM STATE MATRIX
G = [-1/2*(dt^2) -dt]'; % INPUT MATRIX
H = [1 0]; % OBSERVATION MATRIX
Q = [0 0; 0 0]; % PROCESS NOISE COVARIANCE MATRIX
R = 4; % MEASUREMENT NOISE COVARIANCE MATRIX
xohat = [105 0]'; % ASSUMED INITIAL STATE VECTOR
P = [10 0; 0 0.01]; % ASSUMED INITIAL STATE ERROR COVARIANCE MATRIX
I = eye(2);

% Analytically generate the true state
y0 = 100; % init height
v0 = 0; % init velo
xk = zeros(2,N);
xk(:,1) = [y0; v0];
for k = 2:N
    xk(:,k) = F*xk(:,k-1) + G*u;    
end

% Create noisy measurements
v = sqrt(R)*randn(1,N); % measurement noise vector
yk = H*xk + v; % output equation

%% meat and potatoes
x = zeros(2,N);
x(:,1) = xohat;

for k = 2:N
    x(:,k) = F*x(:,k-1) + G*u; % prediction
    P = F*P*F' + Q; % covariance prediction
    K = P*H'/(H*P*H' + R); % kalman gain matrix
    x(:,k) = x(:,k) + K*(yk(k) - H*x(:,k)); % update the state vector
    P = (I - K*H)*P; % update the covariance
end

figure(1);
plot(t, yk);
hold on
plot(t, x(1,:))
