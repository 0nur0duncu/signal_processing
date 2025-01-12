% Veri okuma parametreleri
dosya_adi = './mit-bih-arrhythmia-database-1.0.0/100.dat';  % MIT-BIH veritabanından örnek kayıt
ornekleme_frekansi = 360;  % Örnekleme frekansı (Hz) - MIT-BIH için standart
veri_uzunlugu = 3600;  % 10 saniyelik veri

% Veriyi oku (wfdb toolbox gerekli)
[sinyal,~,~] = rdsamp(dosya_adi, 1, veri_uzunlugu);

% Adım 1: Butterworth bant geçiren filtre tasarımı (0.5-40 Hz)
filtre_derecesi = 4;  % Filtre derecesi
kesme_frekanslari = [0.5 40]/(ornekleme_frekansi/2);  % Normalize edilmiş kesme frekansları
[b, a] = butter(filtre_derecesi, kesme_frekanslari, 'bandpass');

% Adım 2: Sinyali filtreleme
filtrelenmis_sinyal = filtfilt(b, a, sinyal);

% Adım 3: FFT (Hızlı Fourier Dönüşümü) analizi
fft_sonuc = fft(filtrelenmis_sinyal);
frekanslar = (0:length(fft_sonuc)-1)*(ornekleme_frekansi/length(fft_sonuc));
guc_spektrumu = abs(fft_sonuc/length(fft_sonuc));
guc_spektrumu_yarim = guc_spektrumu(1:floor(length(fft_sonuc)/2+1));
frekanslar = frekanslar(1:floor(length(fft_sonuc)/2+1));

% Adım 4: R-tepe noktalarının tespiti
pencere_boyutu = 30;  % Pencere boyutu
esik_degeri = 0.6;  % Eşik değeri
[~, r_tepeleri] = findpeaks(filtrelenmis_sinyal, 'MinPeakHeight', esik_degeri*max(filtrelenmis_sinyal), ...
                        'MinPeakDistance', pencere_boyutu);

% Adım 5: Kalp ritmi hesaplama
rr_araliklari = diff(r_tepeleri)/ornekleme_frekansi;  % R-R aralıkları (saniye)
kalp_atisi = 60./rr_araliklari;  % Kalp atış hızı (bpm)
ortalama_kalp_atisi = mean(kalp_atisi);

% Adım 6: Grafiklerin çizimi
figure;
% 6.1: Orijinal ve filtrelenmiş sinyal karşılaştırması
subplot(3,1,1);
plot(sinyal);
hold on;
plot(filtrelenmis_sinyal, 'r');
title('Orijinal ve Filtrelenmiş EKG Sinyali');
legend('Orijinal', 'Filtrelenmiş');
xlabel('Örnek Sayısı');
ylabel('Genlik');

% 6.2: Frekans spektrumu gösterimi
subplot(3,1,2);
plot(frekanslar, guc_spektrumu_yarim);
title('EKG Sinyalinin Frekans Spektrumu');
xlabel('Frekans (Hz)');
ylabel('Genlik');

% 6.3: R-tepe noktalarının gösterimi
subplot(3,1,3);
plot(filtrelenmis_sinyal);
hold on;
plot(r_tepeleri, filtrelenmis_sinyal(r_tepeleri), 'ro');
title(['R-Tepe Noktaları Tespiti (Ortalama Kalp Ritmi: ' num2str(ortalama_kalp_atisi, '%.1f') ' bpm)']);
xlabel('Örnek Sayısı');
ylabel('Genlik');

% Adım 7: Sonuçların gösterimi
fprintf('Ortalama Kalp Ritmi: %.1f bpm\n', ortalama_kalp_atisi);
fprintf('Minimum Kalp Ritmi: %.1f bpm\n', min(kalp_atisi));
fprintf('Maksimum Kalp Ritmi: %.1f bpm\n', max(kalp_atisi)); 