pkg load signal

% Ses kayıtlarını okuma
% Her ses için [ses_verisi, örnekleme_frekansı] şeklinde okuma yapılır
[ofkeli_ses, ofkeli_fs] = audioread('angry.wav');
[mutlu_ses, mutlu_fs] = audioread('happy.wav');
[notr_ses, notr_fs] = audioread('neutral.wav');
[saskin_ses, saskin_fs] = audioread('suprised.wav');

% Butterworth alçak geçiren filtre tasarımı (gürültü azaltma için)
% Kesme frekansı 4000 Hz olarak belirlenir
kesme_frekansi = 4000 / (ofkeli_fs/2);
[filtre_b, filtre_a] = butter(4, kesme_frekansi, 'low');

% Filtreleme işlemi - her ses için gürültü azaltma uygulanır
ofkeli_filtrelenmis = filter(filtre_b, filtre_a, ofkeli_ses);
mutlu_filtrelenmis = filter(filtre_b, filtre_a, mutlu_ses);
notr_filtrelenmis = filter(filtre_b, filtre_a, notr_ses);
saskin_filtrelenmis = filter(filtre_b, filtre_a, saskin_ses);

% FFT analizi için fonksiyon
% Bu fonksiyon sinyalin frekans spektrumunu hesaplar
function [frekans, genlik] = spektrum_analizi(sinyal, fs)
    Y = fft(sinyal);
    n = length(sinyal);
    frekans = (0:n-1)*(fs/n);
    genlik = abs(Y)/n;
end

% Her duygu için spektrum analizi yapılır
[ofkeli_f, ofkeli_genlik] = spektrum_analizi(ofkeli_filtrelenmis, ofkeli_fs);
[mutlu_f, mutlu_genlik] = spektrum_analizi(mutlu_filtrelenmis, mutlu_fs);
[notr_f, notr_genlik] = spektrum_analizi(notr_filtrelenmis, notr_fs);
[saskin_f, saskin_genlik] = spektrum_analizi(saskin_filtrelenmis, saskin_fs);

% Grafikleri çizme
figure('Name', 'Duygu Analizi');

% Öfkeli ses analizi - Zaman ve Frekans domeninde gösterim
subplot(4,2,1);
plot(ofkeli_filtrelenmis);
title('Öfkeli Ses (Zaman Domeninde)');
xlabel('Örnek');
ylabel('Genlik');

subplot(4,2,2);
plot(ofkeli_f(1:floor(length(ofkeli_f)/2)), ofkeli_genlik(1:floor(length(ofkeli_genlik)/2)));
title('Öfkeli Ses Spektrumu');
xlabel('Frekans (Hz)');
ylabel('Genlik');

% Mutlu ses analizi - Zaman ve Frekans domeninde gösterim
subplot(4,2,3);
plot(mutlu_filtrelenmis);
title('Mutlu Ses (Zaman Domeninde)');
xlabel('Örnek');
ylabel('Genlik');

subplot(4,2,4);
plot(mutlu_f(1:floor(length(mutlu_f)/2)), mutlu_genlik(1:floor(length(mutlu_genlik)/2)));
title('Mutlu Ses Spektrumu');
xlabel('Frekans (Hz)');
ylabel('Genlik');

% Nötr ses analizi - Zaman ve Frekans domeninde gösterim
subplot(4,2,5);
plot(notr_filtrelenmis);
title('Nötr Ses (Zaman Domeninde)');
xlabel('Örnek');
ylabel('Genlik');

subplot(4,2,6);
plot(notr_f(1:floor(length(notr_f)/2)), notr_genlik(1:floor(length(notr_genlik)/2)));
title('Nötr Ses Spektrumu');
xlabel('Frekans (Hz)');
ylabel('Genlik');

% Şaşkın ses analizi - Zaman ve Frekans domeninde gösterim
subplot(4,2,7);
plot(saskin_filtrelenmis);
title('Şaşırmış Ses (Zaman Domeninde)');
xlabel('Örnek');
ylabel('Genlik');

subplot(4,2,8);
plot(saskin_f(1:floor(length(saskin_f)/2)), saskin_genlik(1:floor(length(saskin_genlik)/2)));
title('Şaşırmış Ses Spektrumu');
xlabel('Frekans (Hz)');
ylabel('Genlik');

% Spektrogram analizi - Her duygu için zaman-frekans analizi
figure('Name', 'Spektrogramlar');

% Her duygu için spektrogram çizimi
subplot(2,2,1);
specgram(ofkeli_filtrelenmis, 256, ofkeli_fs);
title('Öfkeli Ses Spektrogramı');

subplot(2,2,2);
specgram(mutlu_filtrelenmis, 256, mutlu_fs);
title('Mutlu Ses Spektrogramı');

subplot(2,2,3);
specgram(notr_filtrelenmis, 256, notr_fs);
title('Nötr Ses Spektrogramı');

subplot(2,2,4);
specgram(saskin_filtrelenmis, 256, saskin_fs);
title('Şaşırmış Ses Spektrogramı'); 