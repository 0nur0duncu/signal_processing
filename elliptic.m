% Sinyal oluşturma
Fs = 1000;
t = 0:1/Fs:1;
x = sin(2*pi*50*t) + sin(2*pi*200*t) + randn(size(t));  % 50 Hz, 200 Hz sinüs dalgaları ve gürültü

% Elliptic düşük geçiş filtresi tasarımı
Rp = 1;  % Geçiş bölgesindeki dalgalanma (dB)
Rs = 40;  % Duraklama bölgesindeki dalgalanma (dB)
Wn = 100 / (Fs / 2);  % Kesme frekansı
[b, a] = ellip(4, Rp, Rs, Wn, 'low');  % 4. dereceden Elliptic filtre

% Filtreleme
y = filter(b, a, x);  % x sinyalini filtrele

% Sonuçları çizme
subplot(2,1,1);
plot(t, x);
title('Orijinal Sinyal');
subplot(2,1,2);
plot(t, y);
title('Elliptic Filtrelenmiş Sinyal');
