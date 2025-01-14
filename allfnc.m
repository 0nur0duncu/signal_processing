% Örnek sinyal parametreleri
fs = 10000; % Örnekleme frekansı (Hz)
t = 0:1/fs:1-1/fs; % 1 saniyelik zaman vektörü

% Arızalı rulman titreşim sinyalinin oluşturulması (örnek)
f_bearing_fault = 150; % Arıza frekansı (örnek olarak 150 Hz)
x = sin(2 * pi * f_bearing_fault * t) + 0.5 * sin(2 * pi * 2 * f_bearing_fault * t); % Harmonikler eklenir
x = x + 0.3 * randn(size(t)); % Gürültü eklenir

% Fourier dönüşümünün hesaplanması
X = fft(x);
n = length(x);
f_vector = (0:n-1)*(fs/n); % Frekans vektörü

% Genlik spektrumu
amplitude = abs(X)/n;

% Spektrumun ilk yarısının gösterimi
figure;
plot(f_vector(1:floor(n/2)), amplitude(1:floor(n/2)));
title('Arızalı Rulman Titreşim Sinyalinin Fourier Dönüşümü');
xlabel('Frekans (Hz)');
ylabel('Genlik');
grid on;


% Sinyal oluşturma
Fs = 1000;
t = 0:1/Fs:1;
x = sin(2*pi*50*t) + sin(2*pi*200*t) + randn(size(t));  % 50 Hz, 200 Hz sinüs dalgaları ve gürültü
% Chebyshev I düşük geçiş filtresi tasarımı
Rp = 1;  % Geçiş bölgesindeki dalgalanma (dB)
Wn = 100 / (Fs / 2);  % Kesme frekansı
[b, a] = cheby1(4, Rp, Wn, 'low');  % 4. dereceden Chebyshev I filtresi
% Filtreleme
y = filter(b, a, x);  % x sinyalini filtrele
% Sonuçları çizme
subplot(2,1,1);
plot(t, x);
title('Orijinal Sinyal');
subplot(2,1,2);
plot(t, y);
title('Chebyshev I Filtrelenmiş Sinyal');
%Rp: Geçiş bölgesindeki dalgalanma.
%cheby1: Chebyshev I filtresi.


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

% Zamanla sönümlenen sinüs sinyali
fs = 1000; % Örnekleme frekansı (Hz)
t = 0:1/fs:2-1/fs; % Zaman vektörü (2 saniye)
x = exp(-0.5*t) .* sin(2 * pi * 50 * t); % 50 Hz sönümlü sinüs dalgası

% Fourier dönüşümünü hesaplama
X = fft(x);
n = length(x);
f = (0:n-1)*(fs/n); % Frekans vektörü

% Genlik spektrumu
amplitude = abs(X)/n;

% Frekans alanında gösterim (ilk yarı)
figure;
plot(f(1:floor(n/2)), amplitude(1:floor(n/2)));
title('Zamanla Sönümlenen Sinüs Sinyalinin Fourier Dönüşümü');
xlabel('Frekans (Hz)');
ylabel('Genlik');
grid on;


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


% Örnekleme parametreleri
fs = 1000;            % Örnekleme frekansı (Hz)
T = 1/fs;             % Örnekleme aralığı
L = 1000;             % Sinyal uzunluğu
t = (0:L-1)*T;        % Zaman vektörü
% Sinyal: 50 Hz ve 120 Hz frekanslı bileşenler
x = 0.7*sin(2*pi*50*t) + 2*sin(2*pi*120*t);
% Fourier dönüşümü
Y = fft(x);
% Frekans ekseni
P2 = abs(Y/L);        % Çift taraflı spektrum
P1 = P2(1:L/2+1);     % Tek taraflı spektrum
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(L/2))/L;
% Zaman domainindeki sinyali çiz
figure;
plot(t, x, 'LineWidth', 1.5);
title('Zaman Domainindeki Sinyal');
xlabel('t (s)');
ylabel('x(t)');
grid on;

% Frekans domaininde sinyali çiz
figure;
plot(f, P1, 'LineWidth', 1.5);
title('Frekans Domaininde Sinyal');
xlabel('Frekans (Hz)');
ylabel('|P1(f)|');
grid on;


% Butterworth filtresi tasarımı ve ileri-geri filtreleme
Fs = 1000;
t = 0:1/Fs:1;
x = sin(2*pi*50*t) + sin(2*pi*200*t) + randn(size(t));  % 50 Hz, 200 Hz sinüs dalgaları ve gürültü
Wn = 100 / (Fs / 2);  % Kesme frekansı
[b, a] = butter(4, Wn, 'low');  % 4. dereceden Butterworth filtresi

% İleri ve geri filtreleme (faz kayması sıfır)
y = filtfilt(b, a, x);  % x sinyalini ileri ve geri filtrele
% Sonuçları çizme
subplot(2,1,1);
plot(t, x);
title('Orijinal Sinyal');
subplot(2,1,2);
plot(t, y);
title('İleri ve Geri Filtrelenmiş Sinyal (filtfilt)');


% Butterworth filtresi tasarımı ve ileri-geri filtreleme
Fs = 1000;
t = 0:1/Fs:1;
x = sin(2*pi*50*t) + sin(2*pi*200*t) + randn(size(t));  % 50 Hz, 200 Hz sinüs dalgaları ve gürültü
Wn = 100 / (Fs / 2);  % Kesme frekansı
[b, a] = butter(4, Wn, 'low');  % 4. dereceden Butterworth filtresi
% İleri ve geri filtreleme (faz kayması sıfır)
y = filtfilt(b, a, x);  % x sinyalini ileri ve geri filtrele
% Sonuçları çizme
subplot(2,1,1);
plot(t, x);
title('Orijinal Sinyal');
subplot(2,1,2);
plot(t, y);
title('İleri ve Geri Filtrelenmiş Sinyal (filtfilt)');


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

% Sürekli zaman sinyali tanımlama
fs = 1000; % Örnekleme frekansı (Hz)
t = 0:1/fs:1-1/fs; % 1 saniye boyunca zaman vektörü
x = cos(2 * pi * 50 * t) + cos(2 * pi * 120 * t); % 50 Hz ve 120 Hz bileşenleri olan sinyal

% Fourier dönüşümünü hesaplama
X = fft(x);
n = length(x); % Örnek sayısı
f = (0:n-1)*(fs/n); % Frekans vektörü

% Genlik spektrumu elde etme
amplitude = abs(X)/n;

% Frekans alanında gösterim (ilk yarı)
figure;
plot(f(1:floor(n/2)), amplitude(1:floor(n/2)));
title('Sinyalin Fourier Dönüşümü');
xlabel('Frekans (Hz)');
ylabel('Genlik');
grid on;



% Sürekli zaman sinyali tanımlama
fs_continuous = 10000; % Sürekli zaman için yüksek örnekleme frekansı (Hz)
t_continuous = 0:1/fs_continuous:1; % Zaman vektörü (1 saniye)
x_continuous = sin(2 * pi * 50 * t_continuous); % 50 Hz'lik bir sinüs dalgası

% Örnekleme frekansını belirleme
fs_sample = 200; % Örnekleme frekansı (Hz)
t_sampled = 0:1/fs_sample:1; % Örnekleme zaman vektörü
x_sampled = sin(2 * pi * 50 * t_sampled); % Örneklenmiş sinyal

% Sinyalin yeniden oluşturulması (spline interpolasyonu)
t_reconstructed = 0:1/fs_continuous:1; % Yeniden yapılandırma için zaman vektörü
x_reconstructed = interp1(t_sampled, x_sampled, t_reconstructed, 'spline');

% Grafik çizimi
figure;
subplot(3, 1, 1);
plot(t_continuous, x_continuous, 'b');
title('Sürekli Zaman Sinyali');
xlabel('Zaman (s)');
ylabel('Genlik');
grid on;

subplot(3, 1, 2);
stem(t_sampled, x_sampled, 'r');
title('Örneklenmiş Sinyal');
xlabel('Zaman (s)');
ylabel('Genlik');
grid on;

subplot(3, 1, 3);
plot(t_reconstructed, x_reconstructed, 'g');
title('Yeniden Yapılandırılmış Sinyal');
xlabel('Zaman (s)');
ylabel('Genlik');
grid on;


% Sinüs sinyaline gürültü ekleme
fs = 1000; % Örnekleme frekansı (Hz)
t = 0:1/fs:1-1/fs; % Zaman vektörü (1 saniye)
x = sin(2 * pi * 50 * t) + 0.5 * randn(size(t)); % 50 Hz sinüs sinyali ve rastgele gürültü

% Fourier dönüşümünü hesaplama
X = fft(x);
n = length(x);
f = (0:n-1)*(fs/n); % Frekans vektörü

% Genlik spektrumu
amplitude = abs(X)/n;

% Frekans alanında gösterim (ilk yarı)
figure;
plot(f(1:floor(n/2)), amplitude(1:floor(n/2)));
title('Gürültülü Sinüs Sinyalinin Fourier Dönüşümü');
xlabel('Frekans (Hz)');
ylabel('Genlik');
grid on;


% Iris veri setini yükle
load fisheriris

% Özellikler (X) ve etiketler (Y)
X = meas; % Özellikler (4 özellik)
Y = grp2idx(species); % Etiketler (3 sınıf: setosa, versicolor, virginica)

% Eğitim ve test verisi olarak veriyi bölelim (80% eğitim, 20% test)
cv = cvpartition(length(Y), 'HoldOut', 0.2);
X_train = X(training(cv), :);
Y_train = Y(training(cv));
X_test = X(test(cv), :);
Y_test = Y(test(cv));

% 1. Min-Max Normalizasyonu
X_train_normalized_minmax = (X_train - min(X_train)) ./ (max(X_train) - min(X_train));
X_test_normalized_minmax = (X_test - min(X_train)) ./ (max(X_train) - min(X_train));

% 2. PCA için SVD kullanma (Min-Max Normalizasyonu ile)
% Veriyi merkezleme
X_train_centered = X_train_normalized_minmax - mean(X_train_normalized_minmax);
X_test_centered = X_test_normalized_minmax - mean(X_train_normalized_minmax);  % Test verisini de eğitim verisine göre merkezleyin

% SVD ile PCA dönüşümü
[U, S, V] = svd(X_train_centered, 'econ');  % 'econ' küçük boyutlu sonuç döndürür

% İlk 2 ana bileşeni seçme
num_components = 2;
X_train_pca = U(:, 1:num_components) * S(1:num_components, 1:num_components);  % Eğitim verisi için PCA dönüşümü
X_test_pca = X_test_centered * V(:, 1:num_components);  % Test verisi için PCA dönüşümü

% 3. PCA ile YSA modeli oluşturma (Min-Max Normalizasyonu ile)
net_pca_minmax = feedforwardnet(10);  % 10 nöronlu bir sinir ağı
net_pca_minmax = train(net_pca_minmax, X_train_pca', Y_train');
Y_pred_pca_minmax = net_pca_minmax(X_test_pca')';

% 4. PCA'sız YSA modeli oluşturma (Min-Max Normalizasyonu ile)
X_train_raw_minmax = X_train_normalized_minmax;
X_test_raw_minmax = X_test_normalized_minmax;

net_raw_minmax = feedforwardnet(10);  % 10 nöronlu bir sinir ağı
net_raw_minmax = train(net_raw_minmax, X_train_raw_minmax', Y_train');
Y_pred_raw_minmax = net_raw_minmax(X_test_raw_minmax')';

% Sonuçları görselleştirme ve karşılaştırma
disp('Min-Max Normalizasyonu ile PCA ile tahmin sonuçları:');
disp(Y_pred_pca_minmax);
disp('Min-Max Normalizasyonu ile PCA\sız tahmin sonuçları:');
disp(Y_pred_raw_minmax);

% Doğruluk oranı hesaplama
accuracy_pca_minmax = sum(round(Y_pred_pca_minmax) == Y_test) / length(Y_test) * 100;
accuracy_raw_minmax = sum(round(Y_pred_raw_minmax) == Y_test) / length(Y_test) * 100;

disp(['Min-Max Normalizasyonu ile PCA ile doğruluk: ', num2str(accuracy_pca_minmax), '%']);
disp(['Min-Max Normalizasyonu ile PCA\sız doğruluk: ', num2str(accuracy_raw_minmax), '%']);


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


% Görüntü yükleme
img = imread('cameraman.tif');
img_fft = fftshift(fft2(img)); % Fourier Transformu

% Magnitude spektrumu
magnitude = abs(img_fft);

% Grafik
figure;
subplot(1,2,1); imshow(img); title('Orijinal Görüntü');
subplot(1,2,2); imshow(log(1+magnitude), []); title('Frekans Spektrumu');
%/*Bu örnekte:

%Amaç: Görüntünün frekans bileşenlerini analiz etmek.
%Kod Açıklaması:
%Görüntü (örneğin cameraman.tif) yükleniyor.
%fft2 kullanılarak görüntü frekans uzayına dönüştürülüyor.
%Frekans spektrumu hesaplanıyor ve logaritmik olarak görselleştiriliyor.
%Sonuç: Görüntünün frekans bileşenleri inceleniyor. Düşük frekanslar görüntüdeki büyük yapıları, 
%yüksek frekanslar ise keskin detayları temsil eder.*/


% Titreşim sinyali oluşturma
fs = 1000; 
t = 0:1/fs:1-1/fs;
signal = sin(2*pi*50*t).*(t<0.5) + sin(2*pi*150*t).*(t>=0.5);
% Süre ve frekans analizi
spectrogram(signal,128,120,128,fs,'yaxis');
% Grafik
title('Zaman-Frekans Analizi (Spektrogram)');
%Bu örnekte:
%Amaç: Frekansı zaman içinde değişen bir sinyalin analizini yapmak.
%Kod Açıklaması:
%Zamanın ilk yarısında düşük frekanslı, ikinci yarısında yüksek frekanslı bir sinyal oluşturuluyor.
%MATLAB'ın spectrogram fonksiyonu ile sinyalin zaman-frekans analizi yapılıyor.
%Sonuç: Spektrogram grafiği sayesinde sinyalin frekanslarının zaman içinde nasıl değiştiği gözlemleniyor.


% Sinyal oluşturma
fs = 1000; 
t = 0:1/fs:1-1/fs;
message = sin(2*pi*10*t); % Mesaj sinyali
fc = 100; % Taşıyıcı frekans
fm_signal = cos(2*pi*fc*t + 2*pi*10*message); % FM modüle edilmiş sinyal

% Grafik
figure;
subplot(2,1,1); plot(t, message); title('Mesaj Sinyali');
subplot(2,1,2); plot(t, fm_signal); title('FM Modüle Sinyal');

%Bu örnekte:

%Amaç: Mesaj sinyalini taşıyıcı frekans ile modüle ederek iletim için bir FM sinyali oluşturmak.
%Kod Açıklaması:
%10 Hz%lik bir mesaj sinyali ve 100 Hz’lik bir taşıyıcı frekans üretiliyor.
%Mesaj sinyali taşıyıcı frekansa bindiriliyor (frekans modülasyonu).
%Modüle edilmiş sinyal zaman alanında görselleştiriliyor.
%Sonuç: İletişim sistemlerinde kullanılan bir FM sinyali elde ediliyor.

% Radar sinyali
c = 3e8; % Işık hızı
fs = 1e9; % Örnekleme frekansı
t = 0:1/fs:1e-6; % Sinyal süresi
f0 = 77e9; % Taşıyıcı frekans
bw = 200e6; % Band genişliği
chirpSignal = chirp(t,0,bw,fs);

% Geri dönen sinyal (yansıma)
delay = 2e-6; % Gecikme (s)
reflectedSignal = [zeros(1,round(delay*fs)), chirpSignal];

% Zaman gecikmesinden mesafe hesaplama
correlation = xcorr(reflectedSignal, chirpSignal);
[~, idx] = max(correlation);
distance = (idx/fs)*c/2;

% Sonuç
disp(['Hedef mesafesi: ', num2str(distance), ' metre']);

%Bu örnekte:

%Amaç: Radar veya sonar sistemlerinde bir nesnenin mesafesini hesaplamak.
%Kod Açıklaması:
%Radar tarafından gönderilen bir sinyal (chirp) oluşturuluyor.
%Geri dönen yansıma sinyali gecikmeli olarak modelleniyor.
%İki sinyal arasındaki zaman gecikmesi, mesafeyi hesaplamak için kullanılıyor.
%Sonuç: Hedefin mesafesi ışık hızına ve gecikmeye bağlı olarak hesaplanıyor.

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