%% przygotowanie środowiska oraz wczytanie danych

clear; % usuwanie wszystkich zmiennych z przestrzeni roboczej Matlaba
close all; % zamykanie wszystkich rysunków i wykresów
load('kawa.mat'); % wczytywanie danych z pliku stand_kawa.mat

%% wstępna wizualizacja i przetwarzanie danych 

% zmienna 'pierwiastek' zawiera informację na temat nazw parametrów macierzy
% danych ('kawa')
% zmienna 'rodzaj' zawiera zdefiniowany rodzaj kawy (klasę) dla poszczególnych
% przypadków

figure; %1
subplot(1,3,1);
bar(kawa); % wykres słupkowy
legend(pierwiastek); % legenda
xlabel('Kawa');
xticks(1:5);
xticklabels(code);
ylabel('Stężenie / mol/dm^3');

subplot(1,3,2);
bar(kawa-mean(kawa)); % centrowanie
legend(pierwiastek);
xlabel('Kawa');
ylabel('Stężenie');

subplot(1,3,3);
bar(zscore(kawa)); %standaryzacja
legend(pierwiastek);
xlabel('Kawa');
ylabel('Stężenie'); 

%% zdefiniowanie zmiennej 'kawa' po standaryzacji

stand_kawa = zscore(kawa);

%% wykres radarowy

% zdefiniowanie koloru wykresu w zależności od rodzaju kawy
rodzaj_kolor = regexprep(rodzaj, 'A', '#77AC30'); % zadanie koloru dla rodzaju A
rodzaj_kolor = regexprep(rodzaj_kolor, 'R', '#A2142F'); % zadanie koloru dla rodzaju R
rodzaj_kolor = hex2rgb(rodzaj_kolor); % zmiana z zapisu hex na rgb

figure; %2
spider_plot(stand_kawa, ...
    'AxesLabels', pierwiastek, ...
    'Color', rodzaj_kolor);
legend(code, 'Location', 'Best');

%% wykresy macierzowe - różne wariacje

figure; %3
gplotmatrix(stand_kawa,[], [], [], [], [], [], [], pierwiastek,pierwiastek);

figure; %4
gplotmatrix(stand_kawa,[], rodzaj, [], [], [], [], [], pierwiastek, pierwiastek);

figure; %5
gplotmatrix(stand_kawa,[],rodzaj,'brg',[], [], [], 'hist',pierwiastek);

figure; %6
gplotmatrix(stand_kawa,[],rodzaj,'brg',[], [], [], 'variable',pierwiastek);

%% wykres twarzy Chernoffa

figure; %7
glyphplot(stand_kawa,'glyph', 'face','obslabels',code,'grid',[2,9]);
box on;

figure; %8
glyphplot(stand_kawa,'obslabels',code,'grid',[2,9]);
box on;

%% twarze Chernoffa dla średnich wartości rodzajów kaw

% wektor indeksów kaw A
idx_A = [1,3,5,7,9,11,13,14,16];
% wektor indeksów kaw R
idx_R = [2,4,6,8,10,12,15,17,18];

% wybranie odpowiednich wersów macierzy i uśrednienie wartości z kolumn
kawa_A = kawa(idx_A,:);
columnMeansA = mean(kawa_A, 1);
kawa_R = kawa(idx_R,:);
columnMeansR = mean(kawa_R, 1);

% stworzenie macierzy dla średnich wartości parametrów dla poszczególnych
% kaw
kawa_mean = [columnMeansA; columnMeansR];

c = {'A','R'};

figure; %9
glyphplot(kawa_mean,'glyph', 'face','obslabels',c,'grid',[1,2]);
box on;

figure; %10
glyphplot(kawa_mean,'obslabels',c,'grid',[1,2]);
box on;

%% analiza skupień: dendrogram + mapa cieplna

figure; %11
X=zscore(stand_kawa); %autoskalowanie
Z = linkage(X, 'ward','euclidean'); % analiza skupień
h=dendrogram(Z, 0, 'ColorThreshold',8,'Orientation','top','Labels', code);
% wyświetlenie schematu dendrogramu
set(h,'LineWidth',2) % grubość linii = 2
xlabel('code');
ylabel('distance');
box on;

clustergram(stand_kawa, 'Standardize', 'Column', 'RowLabels', code, 'ColumnLabels', pierwiastek); %12 mapa cieplna

%% analiza składowych głównych

figure; % rysowanie wykresu osypiska %13
X=zscore(stand_kawa); %autoskalowanie
[COEF, LT, EX] = pcacov(cov(X)); % w EX zwraca % opisywanej zmienności
bar(EX);
xlabel('Numer PC');
ylabel('% opisywanej zmienności');
box on;
grid on;

figure; %14
[COEF, XSPCA, LT] = pca(X); % wykonanie PCA, w XSPCA zwraca wartości głównych składowych
gscatter(XSPCA(:,1), XSPCA(:,2), rodzaj, 'brg'); % rzut na PC1/PC2
xlabel('PC1');
ylabel('PC2');

%% PRZYKŁAD EKSTRAKCJI WYBRANYCH OBIEKTÓW I PARAMETRÓW
figure; %1
bar(kawa([4:7 10],:)); % wykres słupkowy
legend(pierwiastek); % legenda
xlabel('Kawa');
xticks(1:5);
xticklabels(code([4:7,10]));
ylabel('Stężenie / mol/dm^3');

figure; %2
spider_plot(kawa([4:7 18],:), ...
    'AxesLabels', pierwiastek);
legend(code([4:7,18]), 'Location', 'Best');

figure; %3
X=zscore(kawa(:,[2 3 6])); %autoskalowanie
Z = linkage(X, 'ward','euclidean'); % analiza skupień
h=dendrogram(Z, 0, 'ColorThreshold',4,'Orientation','top','Labels', code);
% wyświetlenie schematu dendrogramu
set(h,'LineWidth',2) % grubość linii = 2
xlabel('code');
ylabel('distance');
box on;