% Butterworth filtresi tasarımı ve ileri-geri filtreleme
Fs = 1000;
t = 0:1/Fs:1;
x = sin(2*pi*50*t) + sin(2*pi*200*t) + randn(size(t));  % 50 Hz, 200 Hz sinüs dalgaları ve gürültü
Wn = 100 / (Fs / 2);  % Kesme frekansı
[b, a] = butter(4, Wn, 'low');  % 4. dereceden Butterworth filtresi

% İleri ve geri filtreleme (faz kayması sıfır)
y = filtfilt(b, a, x);  % x sinyalini ileri ve geri filtrele
% Sonuçları çizme
subplot(2,1,1);
plot(t, x);
title('Orijinal Sinyal');
subplot(2,1,2);
plot(t, y);
title('İleri ve Geri Filtrelenmiş Sinyal (filtfilt)');
