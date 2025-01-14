% Signal paketini yükle
pkg load signal

% Ses kayıtlarını okuma
[ofkeli_ses, ofkeli_fs] = audioread('angry.wav');
[neseli_ses, neseli_fs] = audioread('happy.wav');
[notr_ses, notr_fs] = audioread('neutral.wav');
[saskin_ses, saskin_fs] = audioread('suprised.wav');

% Çoklu filtre tasarımı
kesme_frekansi = 4000;
Wn = kesme_frekansi / (ofkeli_fs/2);
Rp = 1;
Rs = 40;

[b_cheby1, a_cheby1] = cheby1(4, Rp, Wn, 'low');
[b_cheby2, a_cheby2] = cheby2(4, Rs, Wn, 'low');
[b_ellip, a_ellip] = ellip(4, Rp, Rs, Wn, 'low');

% Her duygu için filtreleme
% Öfkeli ses
ofkeli_cheby1 = filtfilt(b_cheby1, a_cheby1, ofkeli_ses);
ofkeli_cheby2 = filtfilt(b_cheby2, a_cheby2, ofkeli_ses);
ofkeli_ellip = filtfilt(b_ellip, a_ellip, ofkeli_ses);
ofkeli_filtrelenmis = (ofkeli_cheby1 + ofkeli_cheby2 + ofkeli_ellip) / 3;

% Neşeli ses
neseli_cheby1 = filtfilt(b_cheby1, a_cheby1, neseli_ses);
neseli_cheby2 = filtfilt(b_cheby2, a_cheby2, neseli_ses);
neseli_ellip = filtfilt(b_ellip, a_ellip, neseli_ses);
neseli_filtrelenmis = (neseli_cheby1 + neseli_cheby2 + neseli_ellip) / 3;

% Nötr ses
notr_cheby1 = filtfilt(b_cheby1, a_cheby1, notr_ses);
notr_cheby2 = filtfilt(b_cheby2, a_cheby2, notr_ses);
notr_ellip = filtfilt(b_ellip, a_ellip, notr_ses);
notr_filtrelenmis = (notr_cheby1 + notr_cheby2 + notr_ellip) / 3;

% Şaşkın ses
saskin_cheby1 = filtfilt(b_cheby1, a_cheby1, saskin_ses);
saskin_cheby2 = filtfilt(b_cheby2, a_cheby2, saskin_ses);
saskin_ellip = filtfilt(b_ellip, a_ellip, saskin_ses);
saskin_filtrelenmis = (saskin_cheby1 + saskin_cheby2 + saskin_ellip) / 3;

% Spektral analiz
nfft = 1024;

% Her duygu için FFT analizi
X_ofkeli = fft(ofkeli_filtrelenmis, nfft);
f_ofkeli = (0:nfft/2)*(ofkeli_fs/nfft);
ofkeli_spektrum = abs(X_ofkeli(1:nfft/2+1))/nfft;

X_neseli = fft(neseli_filtrelenmis, nfft);
f_neseli = (0:nfft/2)*(neseli_fs/nfft);
neseli_spektrum = abs(X_neseli(1:nfft/2+1))/nfft;

X_notr = fft(notr_filtrelenmis, nfft);
f_notr = (0:nfft/2)*(notr_fs/nfft);
notr_spektrum = abs(X_notr(1:nfft/2+1))/nfft;

X_saskin = fft(saskin_filtrelenmis, nfft);
f_saskin = (0:nfft/2)*(saskin_fs/nfft);
saskin_spektrum = abs(X_saskin(1:nfft/2+1))/nfft;

% Görselleştirme
figure('Name', 'Duygu Analizi - Zaman Domeni');

% Zaman domeni analizi
subplot(4,1,1);
plot(ofkeli_filtrelenmis);
title('Öfkeli Konuşma');
ylabel('Genlik');

subplot(4,1,2);
plot(neseli_filtrelenmis);
title('Neşeli Konuşma');
ylabel('Genlik');

subplot(4,1,3);
plot(notr_filtrelenmis);
title('Nötr Konuşma');
ylabel('Genlik');

subplot(4,1,4);
plot(saskin_filtrelenmis);
title('Şaşkın Konuşma');
xlabel('Örnek');
ylabel('Genlik');

% Spektral analiz görselleştirmesi
figure('Name', 'Duygu Analizi - Spektral Analiz');

% Güç spektral yoğunluğu
subplot(2,2,1);
plot(f_ofkeli, 10*log10(ofkeli_spektrum));
title('Öfkeli Konuşma Spektrumu');
xlabel('Frekans (Hz)');
ylabel('Güç/Frekans (dB/Hz)');
grid on;

subplot(2,2,2);
plot(f_neseli, 10*log10(neseli_spektrum));
title('Neşeli Konuşma Spektrumu');
xlabel('Frekans (Hz)');
ylabel('Güç/Frekans (dB/Hz)');
grid on;

subplot(2,2,3);
plot(f_notr, 10*log10(notr_spektrum));
title('Nötr Konuşma Spektrumu');
xlabel('Frekans (Hz)');
ylabel('Güç/Frekans (dB/Hz)');
grid on;

subplot(2,2,4);
plot(f_saskin, 10*log10(saskin_spektrum));
title('Şaşkın Konuşma Spektrumu');
xlabel('Frekans (Hz)');
ylabel('Güç/Frekans (dB/Hz)');
grid on;

% Spektrogram analizi
figure('Name', 'Duygu Analizi - Spektrogram');

subplot(2,2,1);
specgram(ofkeli_filtrelenmis, 512, ofkeli_fs);
title('Öfkeli Konuşma Spektrogramı');
ylabel('Frekans (Hz)');

subplot(2,2,2);
specgram(neseli_filtrelenmis, 512, neseli_fs);
title('Neşeli Konuşma Spektrogramı');
ylabel('Frekans (Hz)');

subplot(2,2,3);
specgram(notr_filtrelenmis, 512, notr_fs);
title('Nötr Konuşma Spektrogramı');
ylabel('Frekans (Hz)');

subplot(2,2,4);
specgram(saskin_filtrelenmis, 512, saskin_fs);
title('Şaşkın Konuşma Spektrogramı');
ylabel('Frekans (Hz)');

% Ses Karşılaştırma Analizi
figure('Name', 'Ses Karşılaştırma Analizi');

% Zaman domeninde karşılaştırma
subplot(2,1,1);
hold on;
plot(ofkeli_filtrelenmis, 'r', 'DisplayName', 'Öfkeli');
plot(neseli_filtrelenmis, 'g', 'DisplayName', 'Neşeli');
plot(notr_filtrelenmis, 'b', 'DisplayName', 'Nötr');
plot(saskin_filtrelenmis, 'm', 'DisplayName', 'Şaşkın');
title('Tüm Duyguların Zaman Domeninde Karşılaştırması');
xlabel('Örnek');
ylabel('Genlik');
legend('show');
grid on;
hold off;

% Frekans domeninde karşılaştırma
subplot(2,1,2);
hold on;
plot(f_ofkeli, 10*log10(ofkeli_spektrum), 'r', 'DisplayName', 'Öfkeli');
plot(f_neseli, 10*log10(neseli_spektrum), 'g', 'DisplayName', 'Neşeli');
plot(f_notr, 10*log10(notr_spektrum), 'b', 'DisplayName', 'Nötr');
plot(f_saskin, 10*log10(saskin_spektrum), 'm', 'DisplayName', 'Şaşkın');
title('Tüm Duyguların Frekans Spektrumu Karşılaştırması');
xlabel('Frekans (Hz)');
ylabel('Güç/Frekans (dB/Hz)');
legend('show');
grid on;
hold off;
