% 1. ADIM: Veri Okuma
% MIT-BIH veri tabanından EKG verisini oku
dosya_adi = './mit-bih-arrhythmia-database-1.0.0/101.dat';
dosya = fopen(dosya_adi, 'r');
if dosya == -1
    error('Dosya açılamadı. Lütfen dosya yolunu kontrol edin.');
end

% Binary formatında veriyi oku (16-bit tamsayı olarak)
ham_sinyal = fread(dosya, inf, 'int16');
fclose(dosya);

% 2. ADIM: Sinyal Parametrelerini Ayarla
ornekleme_frekansi = 360; % MIT-BIH için standart örnekleme frekansı (Hz)
ham_sinyal = ham_sinyal(1:3600); % İlk 10 saniyelik veriyi al (360 Hz * 10 sn = 3600 örnek)
zaman = (0:length(ham_sinyal)-1)/ornekleme_frekansi; % Zaman vektörü (saniye)

% 3. ADIM: Butterworth Alçak Geçiren Filtre Tasarımı
kesme_frekansi = 40; % Kesme frekansı (Hz)
normalize_kesme = kesme_frekansi/(ornekleme_frekansi/2); % Normalize edilmiş kesme frekansı
[filtre_b, filtre_a] = butter(4, normalize_kesme, 'low'); % 4. dereceden alçak geçiren filtre

% 4. ADIM: Filtreleme İşlemi
filtreli_sinyal = filter(filtre_b, filtre_a, ham_sinyal);

% 5. ADIM: R-Peak Tespiti
pencere_ms = 200; % 200 ms'lik pencere
pencere_ornekleri = round(pencere_ms * ornekleme_frekansi / 1000); % Pencere örnek sayısı
esik_degeri = 0.6 * max(filtreli_sinyal); % Maksimum genliğin %60'ı

% R-peak konumlarını bul
r_tepeleri = [];
i = pencere_ornekleri + 1;
while i <= (length(filtreli_sinyal) - pencere_ornekleri)
    if filtreli_sinyal(i) > esik_degeri
        % Pencere içindeki maksimum noktayı bul
        [~, max_idx] = max(filtreli_sinyal(i-pencere_ornekleri:i+pencere_ornekleri));
        r_tepeleri = [r_tepeleri; i-pencere_ornekleri+max_idx-1];
        i = i + pencere_ornekleri; % Bir pencere kadar ilerle
    else
        i = i + 1;
    end
end

% 6. ADIM: Kalp Ritmi Hesaplama
if ~isempty(r_tepeleri)
    rr_araliklari = diff(r_tepeleri)/ornekleme_frekansi; % RR aralıkları (saniye)
    kalp_ritmi = 60./rr_araliklari; % Dakika başına atım (BPM)
    ortalama_kalp_ritmi = mean(kalp_ritmi);
end

% 7. ADIM: Fourier Dönüşümü
fourier_donusumu = fft(filtreli_sinyal);
sinyal_uzunlugu = length(filtreli_sinyal);
frekans_vektoru = (0:sinyal_uzunlugu-1)*(ornekleme_frekansi/sinyal_uzunlugu);
genlik_spektrumu = abs(fourier_donusumu)/sinyal_uzunlugu;

% 8. ADIM: Görselleştirme
figure('Position', [200 100 800 600]); % Grafik boyutunu küçülttük

% 8.1 Ham EKG Sinyali
subplot(4,1,1);
plot(zaman, ham_sinyal, 'LineWidth', 1);
title('Ham EKG Sinyali', 'FontSize', 10);
xlabel('Zaman (saniye)', 'FontSize', 9);
ylabel('Genlik (mV)', 'FontSize', 9);
grid on;

% 8.2 Filtrelenmiş EKG Sinyali ve R-Peaks
subplot(4,1,2);
plot(zaman, filtreli_sinyal, 'b', 'LineWidth', 1);
hold on;
if ~isempty(r_tepeleri)
    plot(zaman(r_tepeleri), filtreli_sinyal(r_tepeleri), 'ro', 'MarkerSize', 6);
end
title(['Filtrelenmiş EKG Sinyali ve R-Tepeleri (Toplam: ' num2str(length(r_tepeleri)) ' adet)'], 'FontSize', 10);
xlabel('Zaman (saniye)', 'FontSize', 9);
ylabel('Genlik (mV)', 'FontSize', 9);
grid on;

% 8.3 Kalp Ritmi Grafiği
subplot(4,1,3);
if ~isempty(r_tepeleri) && length(r_tepeleri) > 1
    plot(zaman(r_tepeleri(1:end-1)), kalp_ritmi, 'b.-', 'LineWidth', 1, 'MarkerSize', 6);
    title(['Kalp Ritmi (Ortalama: ' num2str(round(ortalama_kalp_ritmi)) ' BPM)'], 'FontSize', 10);
    ylabel('Kalp Ritmi (BPM)', 'FontSize', 9);
else
    title('Kalp Ritmi Hesaplanamadı', 'FontSize', 10);
end
xlabel('Zaman (saniye)', 'FontSize', 9);
grid on;

% 8.4 Frekans Spektrumu
subplot(4,1,4);
plot(frekans_vektoru(1:floor(sinyal_uzunlugu/2)), genlik_spektrumu(1:floor(sinyal_uzunlugu/2)), 'LineWidth', 1);
title('EKG Sinyalinin Frekans Spektrumu', 'FontSize', 10);
xlabel('Frekans (Hz)', 'FontSize', 9);
ylabel('Genlik', 'FontSize', 9);
grid on;
xlim([0 50]); % Sadece 0-50 Hz arası frekansları göster

% Grafik düzenini iyileştir
set(gcf, 'Color', 'white'); % Arka plan rengini beyaz yap
set(findall(gcf,'type','axes'), 'FontName', 'Arial'); % Font tipini Arial yap

% 9. ADIM: Sonuçları Yazdır
fprintf('\nAnaliz Sonuçları:\n');
if ~isempty(r_tepeleri)
    fprintf('Toplam R-Tepe Sayısı: %d\n', length(r_tepeleri));
    fprintf('Ortalama Kalp Ritmi: %.1f BPM\n', ortalama_kalp_ritmi);
    fprintf('Minimum Kalp Ritmi: %.1f BPM\n', min(kalp_ritmi));
    fprintf('Maksimum Kalp Ritmi: %.1f BPM\n', max(kalp_ritmi));
end
