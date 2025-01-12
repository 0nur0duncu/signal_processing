% Sinyal oluşturma
Fs = 1000;  % Örnekleme frekansı (Hz)
t = 0:1/Fs:1;  % Zaman vektörü
x = sin(2*pi*50*t) + sin(2*pi*200*t) + randn(size(t));  % 50 Hz, 200 Hz sinüs dalgaları ve gürültü

% Butterworth düşük geçiş filtresi tasarımı
Wn = 100 / (Fs / 2);  % Kesme frekansı (normalize)
[b, a] = butter(4, Wn, 'low');  % 4. dereceden düşük geçiş filtresi

% Filtreleme
y = filter(b, a, x);  % x sinyalini filtrele

% Sonuçları çizme
subplot(2,1,1);
plot(t, x);
title('Orijinal Sinyal');
subplot(2,1,2);
plot(t, y);
title('Filtrelenmiş Sinyal');

%&&Wn: Kesme frekansı, Nyquist frekansına göre normalize edilir.
%b ve a: Butterworth filtresinin katsayıları.
%filter(b, a, x): x sinyalini filtreler.