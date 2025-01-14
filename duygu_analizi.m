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

% Her duygu için FFT analizi
% Öfkeli ses için FFT
Y_ofkeli = fft(ofkeli_filtrelenmis);
n_ofkeli = length(ofkeli_filtrelenmis);
ofkeli_f = (0:n_ofkeli-1)*(ofkeli_fs/n_ofkeli);
ofkeli_genlik = abs(Y_ofkeli)/n_ofkeli;

% Mutlu ses için FFT
Y_mutlu = fft(mutlu_filtrelenmis);
n_mutlu = length(mutlu_filtrelenmis);
mutlu_f = (0:n_mutlu-1)*(mutlu_fs/n_mutlu);
mutlu_genlik = abs(Y_mutlu)/n_mutlu;

% Nötr ses için FFT
Y_notr = fft(notr_filtrelenmis);
n_notr = length(notr_filtrelenmis);
notr_f = (0:n_notr-1)*(notr_fs/n_notr);
notr_genlik = abs(Y_notr)/n_notr;

% Şaşkın ses için FFT
Y_saskin = fft(saskin_filtrelenmis);
n_saskin = length(saskin_filtrelenmis);
saskin_f = (0:n_saskin-1)*(saskin_fs/n_saskin);
saskin_genlik = abs(Y_saskin)/n_saskin;

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