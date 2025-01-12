pkg load signal

% 1. ADIM: Ses Dosyasını Okuma
[ses_sinyali, ornekleme_frekansi] = audioread('test.wav');

% 2. ADIM: Stereo sesi mono'ya çevirme (eğer gerekiyorsa)
if size(ses_sinyali, 2) > 1
    ses_sinyali = mean(ses_sinyali, 2);
end

% 3. ADIM: Zaman vektörü oluşturma
% Her örnek için geçen süreyi hesapla
zaman = (0:length(ses_sinyali)-1)/ornekleme_frekansi;

% 4. ADIM: Fourier Dönüşümü ile Frekans Analizi
% Sinyali frekans domenine çevir
frekans_sinyali = fft(ses_sinyali);
N = length(frekans_sinyali);  % Sinyal uzunluğu
frekans_ekseni = (0:N-1)*(ornekleme_frekansi/N);  % Frekans değerleri

% 5. ADIM: Frekans Maskesi ile Filtreleme
% İnsan sesi genellikle 300-3400 Hz aralığındadır
filtreli_frekans = frekans_sinyali;  % Filtrelenecek sinyali kopyala
maske = zeros(N, 1);  % Sıfırlardan oluşan maske dizisi

% Frekans indekslerini hesapla
alt_indeks = round(300 * N/ornekleme_frekansi);   % 300 Hz için indeks
ust_indeks = round(3400 * N/ornekleme_frekansi);  % 3400 Hz için indeks

% Maskeyi oluştur (1: geçir, 0: durdur)
maske(alt_indeks:ust_indeks) = 1;  % İnsan sesi aralığını geçir
% Simetrik olması için ayna görüntüsünü ekle (FFT özelliği gereği)
maske(N-ust_indeks+1:N-alt_indeks+1) = 1;

% Maskeyi uygula
filtreli_frekans = filtreli_frekans .* maske;

% 6. ADIM: Filtrelenmiş Sinyali Zaman Domenine Geri Çevir
filtreli_sinyal = real(ifft(filtreli_frekans));

% 7. ADIM: Sonuçları Görselleştir
figure('Name', 'Ses Sinyali Gürültü Azaltma Analizi', 'Position', [100 100 1200 800]);

% Zaman domenindeki sinyaller
subplot(2,2,1);
plot(zaman, ses_sinyali, 'b', 'LineWidth', 1.5);
title('Orijinal Ses Sinyali', 'FontSize', 12);
xlabel('Zaman (saniye)');
ylabel('Genlik');
grid on;

subplot(2,2,3);
plot(zaman, filtreli_sinyal, 'g', 'LineWidth', 1.5);
title('Filtrelenmiş Ses Sinyali', 'FontSize', 12);
xlabel('Zaman (saniye)');
ylabel('Genlik');
grid on;

% Frekans domenindeki sinyaller
frekans_gosterim = frekans_ekseni(1:floor(N/2));  % Nyquist frekansına kadar göster

subplot(2,2,2);
plot(frekans_gosterim, abs(frekans_sinyali(1:floor(N/2))), 'b', 'LineWidth', 1.5);
title('Orijinal Sinyal Spektrumu', 'FontSize', 12);
xlabel('Frekans (Hz)');
ylabel('Genlik');
grid on;
xlim([0 4000]);  % İnsan sesi için önemli frekans aralığı

subplot(2,2,4);
plot(frekans_gosterim, abs(filtreli_frekans(1:floor(N/2))), 'g', 'LineWidth', 1.5);
title('Filtrelenmiş Sinyal Spektrumu', 'FontSize', 12);
xlabel('Frekans (Hz)');
ylabel('Genlik');
grid on;
xlim([0 4000]);  % İnsan sesi için önemli frekans aralığı

% 8. ADIM: Filtrelenmiş Sesi Kaydet
audiowrite('sonuc.wav', filtreli_sinyal, ornekleme_frekansi); 