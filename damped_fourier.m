% Zamanla sönümlenen sinüs sinyali
fs = 1000; % Örnekleme frekansı (Hz)
t = 0:1/fs:2-1/fs; % Zaman vektörü (2 saniye)
x = exp(-0.5*t) .* sin(2 * pi * 50 * t); % 50 Hz sönümlü sinüs dalgası

% Fourier dönüşümünü hesaplama
X = fft(x);
n = length(x);
f = (0:n-1)*(fs/n); % Frekans vektörü

% Genlik spektrumu
amplitude = abs(X)/n;

% Frekans alanında gösterim (ilk yarı)
figure;
plot(f(1:floor(n/2)), amplitude(1:floor(n/2)));
title('Zamanla Sönümlenen Sinüs Sinyalinin Fourier Dönüşümü');
xlabel('Frekans (Hz)');
ylabel('Genlik');
grid on;
