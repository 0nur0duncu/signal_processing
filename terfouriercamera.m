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