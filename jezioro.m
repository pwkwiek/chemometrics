clear; % usuwanie wszystkich zmiennych z przestrzeni roboczej Matlaba
close all; % zamykanie wszystkich rysunków i wykresów
load('jezioro.mat'); % wczytywanie danych z pliku jezioro.mat

%% 

jony={'Cl^-', 'SO_4^{2-}', 'PO_4^{3-}', 'NO_3^{-}'}; % definiowanie nazw jonów
figure; %1
subplot(1,3,1);
bar(jezioro); % wykres słupkowy
legend(jony); % legenda
xlabel('Jezioro');
ylabel('Stężenie / mg/L');

subplot(1,3,2);
bar(jezioro-mean(jezioro)); % centrowanie
legend(jony);
xlabel('Jezioro');
ylabel('Stężenie');

subplot(1,3,3);
bar(zscore(jezioro)); %standaryzacja
legend(jony);
xlabel('Jezioro');
ylabel('Stężenie'); 

%% 

nazwyjezior={'j1','j2','j3','j4','j5','j6','j7'};
figure; %2
spider_plot(jezioro, ...
    'AxesLabels', {'Cl^-', 'SO_4^{2-}', 'PO_4^{3-}', 'NO_3^{-}'}, ...
     'Color', [1, 0, 0;1, 0, 0;1, 0, 0;0, 1, 0;1, 0, 1;0, 1, 0;0, 1, 0;]);
legend(nazwyjezior, 'Location', 'Best');

%% 

typ={'1' '1' '1' '2' '3' '2' '2'}';

figure; %3
gplotmatrix(jezioro,[], [], [], [], [], [], [], jony,jony);

%%

figure; %4
gplotmatrix(jezioro,[], typ, [], [], [], [], [], jony, jony);

%%

figure; %5
gplotmatrix(jezioro,[],typ,'brg',[], [], [], 'hist',jony);

%%

figure; %6
gplotmatrix(jezioro,[],typ,'brg',[], [], [], 'variable',jony);

%%

figure; %7
glyphplot(jezioro,'glyph', 'face','obslabels',nazwyjezior,'grid',[1,7]);
box on;

%%

figure; %8
glyphplot(jezioro,'obslabels',nazwyjezior,'grid',[1,7]);
box on;

%%

figure; %9
X=zscore(jezioro); %autoskalowanie
Z = linkage(X, 'ward','euclidean'); % analiza skupień
h=dendrogram(Z, 0, 'ColorThreshold',2,'Orientation','top','Labels', nazwyjezior);
% wyświetlenie schematu dendrogramu
set(h,'LineWidth',2) % grubość linii = 2
xlabel('lake');
ylabel('distance');
box on;

%%

clustergram(jezioro, 'Standardize', 'Column', 'RowLabels', nazwyjezior, 'ColumnLabels', jony); %10


%%

figure; % rysowanie wykresu osypiska %11
X=zscore(jezioro); %autoskalowanie
[COEF, LT, EX] = pcacov(cov(X)); % w EX zwraca % opisywanej zmienności
bar(EX);
xlabel('Numer PC');
ylabel('% opisywanej zmienności');
box on;
grid on;

%%

figure; %12
[COEF, XSPCA, LT] = pca(X); % wykonanie PCA, w XSPCA zwraca wartości głównych składowych
gscatter(XSPCA(:,2), XSPCA(:,3), typ, 'brg'); % rzut na PC1/PC2
xlabel('PC2');
ylabel('PC3');
