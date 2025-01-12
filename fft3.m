% Örnekleme parametreleri
fs = 1000;            % Örnekleme frekansı (Hz)
T = 1/fs;             % Örnekleme aralığı
L = 1000;             % Sinyal uzunluğu
t = (0:L-1)*T;        % Zaman vektörü
% Sinyal: 50 Hz ve 120 Hz frekanslı bileşenler
x = 0.7*sin(2*pi*50*t) + 2*sin(2*pi*120*t);
% Fourier dönüşümü
Y = fft(x);
% Frekans ekseni
P2 = abs(Y/L);        % Çift taraflı spektrum
P1 = P2(1:L/2+1);     % Tek taraflı spektrum
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(L/2))/L;
% Zaman domainindeki sinyali çiz
figure;
plot(t, x, 'LineWidth', 1.5);
title('Zaman Domainindeki Sinyal');
xlabel('t (s)');
ylabel('x(t)');
grid on;

% Frekans domaininde sinyali çiz
figure;
plot(f, P1, 'LineWidth', 1.5);
title('Frekans Domaininde Sinyal');
xlabel('Frekans (Hz)');
ylabel('|P1(f)|');
grid on;
