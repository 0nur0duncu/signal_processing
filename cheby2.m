% Sinyal oluşturma
Fs = 1000;
t = 0:1/Fs:1;
x = sin(2*pi*50*t) + sin(2*pi*200*t) + randn(size(t));  % 50 Hz, 200 Hz sinüs dalgaları ve gürültü

% Chebyshev II düşük geçiş filtresi tasarımı
Rs = 40;  % Duraklama bölgesindeki dalgalanma (dB)
Wn = 100 / (Fs / 2);  % Kesme frekansı
[b, a] = cheby2(4, Rs, Wn, 'low');  % 4. dereceden Chebyshev II filtresi

% Filtreleme
y = filter(b, a, x);  % x sinyalini filtrele

% Sonuçları çizme
subplot(2,1,1);
plot(t, x);
title('Orijinal Sinyal');
subplot(2,1,2);
plot(t, y);
title('Chebyshev II Filtrelenmiş Sinyal');
%Rs: Duraklama bölgesindeki dalgalanma.
%cheby2: Chebyshev II filtresi.