% Titreşim verisi
fs = 1000;
t = 0:1/fs:2-1/fs;
vibration = sin(2*pi*100*t) + 0.3*sin(2*pi*200*t);

% FFT analizi
V = fft(vibration);
f = (0:length(V)-1)*(fs/length(V));

% Grafik
figure;
subplot(2,1,1); plot(t, vibration); title('Titreşim Verisi');
subplot(2,1,2); plot(f, abs(V)); title('Frekans Analizi');

%Bu örnekte:

%Amaç: Mekanik sistemlerde titreşimlerin frekans analizi.
%Kod Açıklaması:
%100 Hz ve 200 Hz%lik iki farklı frekansın birleşiminden oluşan bir titreşim sinyali üretiliyor.
%Fourier dönüşümü ile titreşim frekansları tespit ediliyor.
%Frekans grafiği, titreşimlerde hangi frekansların baskın olduğunu gösteriyor.
%Sonuç: Titreşimlerin hangi frekanslarda meydana geldiği analiz ediliyor, bu da mekanik sorunların teşhisi için kullanılabilir.