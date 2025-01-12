pkg load signal

% Ses dosyasını okuma
[sinyal, ornekleme_frekansi] = audioread('test.wav');

% Butterworth alçak geçiren filtre tasarımı
kesme_frekansi = 2400;  % İnsan sesi için kesme frekansı (Hz)
filtre_derecesi = 3;  % Daha keskin bir filtre için derece artırıldı
Wn = kesme_frekansi / (ornekleme_frekansi/2);  % Normalize edilmiş kesme frekansı
[b, a] = butter(filtre_derecesi, Wn, 'low');  % Butterworth filtre katsayıları

% Sinyali filtreleme
filtrelenmis_sinyal = filter(b, a, sinyal);

% Filtrelenmiş sesi kaydetme
audiowrite('filtrelenmis.wav', filtrelenmis_sinyal, ornekleme_frekansi);

% Figure 1: Zaman Domaininde Karşılaştırma
figure('Name', 'Zaman Domain Analizi', 'Position', [100 100 1200 800]);
zaman = (0:length(sinyal)-1) / ornekleme_frekansi;

% Orijinal sinyal
subplot(3,1,1);
plot(zaman, sinyal, 'b', 'LineWidth', 1.5);
title('Orijinal Ses Sinyali', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Zaman (s)', 'FontSize', 10);
ylabel('Genlik', 'FontSize', 10);
grid on;
ylim([-1 1]);  % Genlik sınırları

% Filtrelenmiş sinyal
subplot(3,1,2);
plot(zaman, filtrelenmis_sinyal, 'r', 'LineWidth', 1.5);
title('Filtrelenmiş Ses Sinyali (İnsan Sesi)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Zaman (s)', 'FontSize', 10);
ylabel('Genlik', 'FontSize', 10);
grid on;
ylim([-1 1]);  % Genlik sınırları

% Üst üste bindirilmiş görüntüleme
subplot(3,1,3);
plot(zaman, sinyal, 'b', 'DisplayName', 'Orijinal', 'LineWidth', 1.5);
hold on;
plot(zaman, filtrelenmis_sinyal, 'r', 'DisplayName', 'Filtrelenmiş', 'LineWidth', 1.5);
title('Karşılaştırma (Orijinal vs Filtrelenmiş)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Zaman (s)', 'FontSize', 10);
ylabel('Genlik', 'FontSize', 10);
legend('Location', 'northeast');
grid on;
ylim([-1 1]);  % Genlik sınırları

% Figure 2: Frekans Spektrum Analizi
figure('Name', 'Frekans Spektrum Analizi', 'Position', [100 100 1200 800]);
N = length(sinyal);
frekans = (0:N-1)*(ornekleme_frekansi/N);

% Orijinal sinyalin frekans spektrumu
X = fft(sinyal);
X_genlik = abs(X)/N;

% Filtrelenmiş sinyalin frekans spektrumu
Y = fft(filtrelenmis_sinyal);
Y_genlik = abs(Y)/N;

% Orijinal spektrum
subplot(3,1,1);
plot(frekans(1:floor(N/2)), X_genlik(1:floor(N/2)), 'b', 'LineWidth', 1.5);
title('Orijinal Sinyal Frekans Spektrumu', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Frekans (Hz)', 'FontSize', 10);
ylabel('Genlik', 'FontSize', 10);
grid on;
xlim([0 5000]);  % İlgilendiğimiz frekans aralığı
set(gca, 'XTick', 0:500:5000);  % X ekseni işaretleri

% Filtrelenmiş spektrum
subplot(3,1,2);
plot(frekans(1:floor(N/2)), Y_genlik(1:floor(N/2)), 'r', 'LineWidth', 1.5);
title('Filtrelenmiş Sinyal Frekans Spektrumu', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Frekans (Hz)', 'FontSize', 10);
ylabel('Genlik', 'FontSize', 10);
grid on;
xlim([0 5000]);  % İlgilendiğimiz frekans aralığı
set(gca, 'XTick', 0:500:5000);  % X ekseni işaretleri

% Üst üste bindirilmiş spektrumlar
subplot(3,1,3);
plot(frekans(1:floor(N/2)), X_genlik(1:floor(N/2)), 'b', 'DisplayName', 'Orijinal', 'LineWidth', 1.5);
hold on;
plot(frekans(1:floor(N/2)), Y_genlik(1:floor(N/2)), 'r', 'DisplayName', 'Filtrelenmiş', 'LineWidth', 1.5);
title('Frekans Spektrumlarının Karşılaştırması', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Frekans (Hz)', 'FontSize', 10);
ylabel('Genlik', 'FontSize', 10);
legend('Location', 'northeast');
grid on;
xlim([0 5000]);  % İlgilendiğimiz frekans aralığı
set(gca, 'XTick', 0:500:5000);  % X ekseni işaretleri

% Kesme frekansını göster
hold on;
plot([kesme_frekansi kesme_frekansi], ylim, '--k', 'DisplayName', 'Kesme Frekansı', 'LineWidth', 1.2);
