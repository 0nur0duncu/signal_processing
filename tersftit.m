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

