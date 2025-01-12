% Sinyal oluşturma
fs = 1000; % Örnekleme frekansı (Hz)
t = 0:1/fs:1-1/fs; % Zaman vektörü
signal = sin(2*pi*50*t) + 0.5*sin(2*pi*120*t); % İki farklı frekansta sinyal
noise = 0.5*randn(size(t)); % Gürültü
noisySignal = signal + noise; % Gürültülü sinyal

% Fourier Transformu
Y = fft(noisySignal);
f = (0:length(Y)-1)*(fs/length(Y));

% Filtreleme (50 ve 120 Hz dışındaki frekansları kaldır)
Y_filtered = Y;
Y_filtered(f > 60 & f < 110) = 0;

% Ters Fourier
filteredSignal = ifft(Y_filtered);

% Grafik
figure;
subplot(3,1,1); plot(t, noisySignal); title('Gürültülü Sinyal');
subplot(3,1,2); plot(f, abs(Y)); title('Frekans Bileşenleri');
subplot(3,1,3); plot(t, real(filteredSignal)); title('Filtrelenmiş Sinyal');
%Bu örnekte:

%Amaç: Bir sinyal üzerinde bulunan gürültüyü (noise) temizlemek.
%Kod Açıklaması:
%Sinyal iki farklı frekansta (50 Hz ve 120 Hz) üretiliyor.
%Gürültü (random noise) ekleniyor.
%Fourier dönüşümü ile sinyalin frekans bileşenleri hesaplanıyor.
%İstenmeyen frekans bileşenleri sıfırlanıyor (60-110 Hz arası filtreleniyor).
%Ters Fourier dönüşümü ile filtrelenmiş sinyal zamana geri dönüştürülüyor.
%Sonuç: Gürültü azaltılmış ve net bir sinyal elde ediliyor.