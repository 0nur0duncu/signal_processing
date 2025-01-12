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