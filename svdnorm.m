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
s