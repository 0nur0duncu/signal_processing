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