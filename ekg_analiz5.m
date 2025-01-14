% Signal paketini yükle
pkg load signal

% Dosya yolunu kontrol etmek için önce bu satırları ekleyelim
disp(['Çalışma dizini: ' pwd])
ls  % Octave'da dir yerine ls kullanılır

% 1. ADIM: Veri Okuma
dosya_adi = 'C:\Users\odunc\Desktop\Matlab\Kodlar2/mit-bih-arrhythmia-database-1.0.0/101.dat';
dosya = fopen(dosya_adi, 'r');
if dosya == -1
    error('Dosya açılamadı. Lütfen dosya yolunu kontrol edin.');
end

ham_sinyal = fread(dosya, inf, 'int16');
fclose(dosya);

% 2. ADIM: Sinyal Parametrelerini Ayarla
ornekleme_frekansi = 360;
ham_sinyal = ham_sinyal(1:3600);
zaman = (0:length(ham_sinyal)-1)/ornekleme_frekansi;

% 3. ADIM: Çoklu Filtre Uygulaması
% 3.1 Chebyshev I Filtresi
Rp = 1;  % Geçiş bölgesindeki dalgalanma (dB)
Wn1 = 40 / (ornekleme_frekansi/2);
[b_cheby1, a_cheby1] = cheby1(4, Rp, Wn1, 'low');
filtreli_sinyal_cheby1 = filtfilt(b_cheby1, a_cheby1, double(ham_sinyal));

% 3.2 Elliptic Filtre
Rp = 1;  % Geçiş bölgesindeki dalgalanma (dB)
Rs = 40; % Duraklama bölgesindeki dalgalanma (dB)
Wn2 = 40 / (ornekleme_frekansi/2);
[b_ellip, a_ellip] = ellip(4, Rp, Rs, Wn2, 'low');
filtreli_sinyal_ellip = filtfilt(b_ellip, a_ellip, double(ham_sinyal));

% 3.3 İki filtrenin ortalamasını al
filtreli_sinyal = (filtreli_sinyal_cheby1 + filtreli_sinyal_ellip) / 2;

% 4. ADIM: R-Peak Tespiti (Geliştirilmiş)
pencere_ms = 200;
pencere_ornekleri = round(pencere_ms * ornekleme_frekansi / 1000);
esik_degeri = 0.6 * max(filtreli_sinyal);

% Yerel maksimumları bul
r_tepeleri = [];
i = pencere_ornekleri + 1;
while i <= (length(filtreli_sinyal) - pencere_ornekleri)
    if filtreli_sinyal(i) > esik_degeri
        [~, max_idx] = max(filtreli_sinyal(i-pencere_ornekleri:i+pencere_ornekleri));
        r_tepeleri = [r_tepeleri; i-pencere_ornekleri+max_idx-1];
        i = i + pencere_ornekleri;
    else
        i = i + 1;
    end
end

% 5. ADIM: Gelişmiş Kalp Ritmi Analizi
if ~isempty(r_tepeleri)
    % RR aralıklarını hesapla
    rr_araliklari = diff(r_tepeleri)/ornekleme_frekansi;

    % Anlık kalp ritmi
    kalp_ritmi = 60./rr_araliklari;

    % İstatistiksel analizler
    ortalama_kalp_ritmi = mean(kalp_ritmi);
    std_kalp_ritmi = std(kalp_ritmi);

    % RR aralıklarının değişkenliği (HRV göstergesi)
    hrv_sdnn = std(rr_araliklari);
    hrv_rmssd = sqrt(mean(diff(rr_araliklari).^2));
end

% 6. ADIM: Görselleştirme - Her Analiz Ayrı Pencerede

% Pencere 1: Ham ve Filtrelenmiş Sinyal
figure('Name', 'Ham EKG Sinyali ve Filtre Karşılaştırması', 'NumberTitle', 'off');
subplot(2,1,1);
plot(zaman, ham_sinyal, 'b');
title('Ham EKG Sinyali');
xlabel('Zaman (saniye)');
ylabel('Genlik (mV)');
grid on;

subplot(2,1,2);
plot(zaman, filtreli_sinyal_cheby1, 'b', zaman, filtreli_sinyal_ellip, 'r', zaman, filtreli_sinyal, 'g');
title('Filtre Karşılaştırması');
legend('Chebyshev I', 'Elliptic', 'Ortalama');
xlabel('Zaman (saniye)');
ylabel('Genlik (mV)');
grid on;

% Pencere 2: R-Peak Tespiti
figure('Name', 'R-Peak Tespiti', 'NumberTitle', 'off');
plot(zaman, filtreli_sinyal, 'b');
hold on;
if ~isempty(r_tepeleri)
    plot(zaman(r_tepeleri), filtreli_sinyal(r_tepeleri), 'ro');
end
title(['R-Tepeleri (Toplam: ' num2str(length(r_tepeleri)) ' adet)']);
xlabel('Zaman (saniye)');
ylabel('Genlik (mV)');
grid on;
hold off;

% Pencere 3: HRV Analizi
figure('Name', 'Kalp Ritmi Değişkenliği (HRV) Analizi', 'NumberTitle', 'off');
if ~isempty(r_tepeleri) && length(r_tepeleri) > 1
    plot(zaman(r_tepeleri(1:end-1)), kalp_ritmi, 'b.-');
    hold on;
    plot([zaman(r_tepeleri(1)) zaman(r_tepeleri(end-1))], ...
         [ortalama_kalp_ritmi ortalama_kalp_ritmi], 'r--');
    hold off;
    title(['Kalp Ritmi Değişkenliği (Ort: ' num2str(fix(ortalama_kalp_ritmi)) ' BPM, STD: ' ...
           num2str(fix(std_kalp_ritmi)) ' BPM)']);
    ylabel('Kalp Ritmi (BPM)');
else
    title('Kalp Ritmi Hesaplanamadı');
end
xlabel('Zaman (saniye)');
grid on;



% 7. ADIM: Detaylı Sonuçları Yazdır
printf('\nEKG Analiz Sonuçları:\n');
printf('------------------------\n');
if ~isempty(r_tepeleri)
    printf('R-Tepe Analizi:\n');
    printf('  Toplam R-Tepe Sayısı: %d\n', length(r_tepeleri));
    printf('\nKalp Ritmi İstatistikleri:\n');
    printf('  Ortalama Kalp Ritmi: %.1f BPM\n', ortalama_kalp_ritmi);
    printf('  Minimum Kalp Ritmi: %.1f BPM\n', min(kalp_ritmi));
    printf('  Maksimum Kalp Ritmi: %.1f BPM\n', max(kalp_ritmi));
    printf('  Standart Sapma: %.1f BPM\n', std_kalp_ritmi);
    printf('\nHRV Analizi:\n');
    printf('  SDNN: %.3f sn\n', hrv_sdnn);
    printf('  RMSSD: %.3f sn\n', hrv_rmssd);
end
