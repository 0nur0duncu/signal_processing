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
