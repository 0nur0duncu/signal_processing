% Sürekli zaman sinyali tanımlama
fs = 1000; % Örnekleme frekansı (Hz)
t = 0:1/fs:1-1/fs; % 1 saniye boyunca zaman vektörü
x = cos(2 * pi * 50 * t) + cos(2 * pi * 120 * t); % 50 Hz ve 120 Hz bileşenleri olan sinyal

% Fourier dönüşümünü hesaplama
X = fft(x);
n = length(x); % Örnek sayısı
f = (0:n-1)*(fs/n); % Frekans vektörü

% Genlik spektrumu elde etme
amplitude = abs(X)/n;

% Frekans alanında gösterim (ilk yarı)
figure;
plot(f(1:floor(n/2)), amplitude(1:floor(n/2)));
title('Sinyalin Fourier Dönüşümü');
xlabel('Frekans (Hz)');
ylabel('Genlik');
grid on;

