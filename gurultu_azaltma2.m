pkg load signal

% 1. ADIM: Ses Dosyasını Okuma
[y, fs] = audioread('test.wav'); % Ses dosyasını oku (test.wav dosyasını aynı dizine koyun)
t = (0:length(y)-1)/fs; % Zaman vektörü
noisySignal = y; % Gürültülü sinyali ses dosyasından gelen sinyale atayalım

% 2. ADIM: Butterworth düşük geçiş ve yüksek geçiş filtresi tasarımı
alt_frekans = 300 / (fs/2); % Normalize edilmiş alt kesme frekansı (0-1 arası)
ust_frekans = 3400 / (fs/2); % Normalize edilmiş üst kesme frekansı (0-1 arası)

% Düşük geçiş filtresi
[b_low, a_low] = butter(4, ust_frekans, 'low');

% Yüksek geçiş filtresi
[b_high, a_high] = butter(4, alt_frekans, 'high');

% 3. ADIM: İleri ve geri filtreleme (faz kayması sıfır)
filteredSignal = filtfilt(b_low, a_low, noisySignal);  % Sinyali düşük geçiş filtresi ile filtrele
filteredSignal = filtfilt(b_high, a_high, filteredSignal);  % Sinyali yüksek geçiş filtresi ile filtrele

% 4. ADIM: Fourier dönüşümü ve frekans vektörü hesaplama
N = length(noisySignal);
orijinal_fft = fft(noisySignal);
filtreli_fft = fft(filteredSignal);
f = (0:N-1)*(fs/N); % Frekans vektörü

% 5. ADIM: Genlik spektrumları
amplitude_original = abs(orijinal_fft)/N;
amplitude_filtered = abs(filtreli_fft)/N;

% 6. ADIM: Grafik çizimi
figure;
% Orijinal ve filtrelenmiş sinyaller (zaman domeninde)
subplot(2,1,1);
plot(t, noisySignal, 'b', t, filteredSignal, 'r', 'LineWidth', 1.5);
title('Zaman Domeni Sinyalleri');
xlabel('Zaman (s)');
ylabel('Genlik');
legend('Gürültülü Sinyal', 'Filtrelenmiş Sinyal');
grid on;

% Frekans spektrumları
subplot(2,1,2);
plot(f(1:floor(N/2)), amplitude_original(1:floor(N/2)), 'b', ...
     f(1:floor(N/2)), amplitude_filtered(1:floor(N/2)), 'r', 'LineWidth', 1.5);
title('Frekans Spektrumu');
xlabel('Frekans (Hz)');
ylabel('Genlik');
legend('Gürültülü Sinyal', 'Filtrelenmiş Sinyal');
grid on;
xlim([0 5000]);

% 7. ADIM: Filtrelenmiş sinyali yeni bir dosyaya kaydet
audiowrite('output.wav', filteredSignal, fs); % Filtrelenmiş ses dosyasını kaydet
fprintf('Filtrelenmiş ses dosyası "output.wav" olarak kaydedildi.\n');