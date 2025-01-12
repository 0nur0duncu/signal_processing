% Örnek sinyal parametreleri
fs = 10000; % Örnekleme frekansı (Hz)
t = 0:1/fs:1-1/fs; % 1 saniyelik zaman vektörü

% Arızalı rulman titreşim sinyalinin oluşturulması (örnek)
f_bearing_fault = 150; % Arıza frekansı (örnek olarak 150 Hz)
x = sin(2 * pi * f_bearing_fault * t) + 0.5 * sin(2 * pi * 2 * f_bearing_fault * t); % Harmonikler eklenir
x = x + 0.3 * randn(size(t)); % Gürültü eklenir

% Fourier dönüşümünün hesaplanması
X = fft(x);
n = length(x);
f_vector = (0:n-1)*(fs/n); % Frekans vektörü

% Genlik spektrumu
amplitude = abs(X)/n;

% Spektrumun ilk yarısının gösterimi
figure;
plot(f_vector(1:floor(n/2)), amplitude(1:floor(n/2)));
title('Arızalı Rulman Titreşim Sinyalinin Fourier Dönüşümü');
xlabel('Frekans (Hz)');
ylabel('Genlik');
grid on;
