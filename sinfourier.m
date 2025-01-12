% Sinüs sinyaline gürültü ekleme
fs = 1000; % Örnekleme frekansı (Hz)
t = 0:1/fs:1-1/fs; % Zaman vektörü (1 saniye)
x = sin(2 * pi * 50 * t) + 0.5 * randn(size(t)); % 50 Hz sinüs sinyali ve rastgele gürültü

% Fourier dönüşümünü hesaplama
X = fft(x);
n = length(x);
f = (0:n-1)*(fs/n); % Frekans vektörü

% Genlik spektrumu
amplitude = abs(X)/n;

% Frekans alanında gösterim (ilk yarı)
figure;
plot(f(1:floor(n/2)), amplitude(1:floor(n/2)));
title('Gürültülü Sinüs Sinyalinin Fourier Dönüşümü');
xlabel('Frekans (Hz)');
ylabel('Genlik');
grid on;
