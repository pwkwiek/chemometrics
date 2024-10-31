%% przygotowanie środowiska oraz wczytanie danych

clear; % usuwanie wszystkich zmiennych z przestrzeni roboczej Matlaba
close all; % zamykanie wszystkich rysunków i wykresów
load('kawa.mat'); % wczytywanie danych z pliku stand_kawa.mat

%% wstępna wizualizacja i przetwarzanie danych 

% zmienna 'pierwiastek' zawiera informację na temat nazw parametrów macierzy
% danych ('kawa')
% zmienna 'rodzaj' zawiera zdefiniowany rodzaj kawy (klasę) dla poszczególnych
% przypadków
% zmienna 'code' zawiera nazwy przypisane do poszczególnych próbek kawy

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

% warto zauważyć, że centrowanie i standaryzacja pozwalają na łatwiejsze
% porównanie wartości pierwiastków, które posiadają niskie zakresy wartości
% stężeń w porównaniu do innych paraetrów;
% przykładowo łatwiej analizować dane dla parametrów: P, Ca, Mg na
% wykresach 2 i 3, niż na wykresie 1

%% zdefiniowanie zmiennej 'kawa' po standaryzacji

stand_kawa = zscore(kawa);

%% wykres radarowy

% zdefiniowanie koloru wykresu w zależności od rodzaju kawy
% jeden z możliwych sposobów
rodzaj_kolor = regexprep(rodzaj, 'A', '#77AC30'); % zadanie koloru dla rodzaju A
rodzaj_kolor = regexprep(rodzaj_kolor, 'R', '#A2142F'); % zadanie koloru dla rodzaju R
rodzaj_kolor = hex2rgb(rodzaj_kolor); % zmiana z zapisu hex na rgb

figure; %2
spider_plot(stand_kawa, ...
    'AxesLabels', pierwiastek, ...
    'Color', rodzaj_kolor);
legend(code, 'Location', 'Best');

% promienie reprezentują poszczególne parametry - pierwiastki
% na wykresie zadano kolor linii na podstawie przynależności do klasy (A/R)
% podobieństwo kształtu jaki tworzą linie dla poszczególnych próbek może
% sugerować przynależność do danej klasy

% przykład wyświetlania danych dla 5 pierwszych obiektów

figure; %3 
spider_plot(kawa([1:5],:), ...
    'AxesLabels', pierwiastek);
legend(code([1:5]), 'Location', 'Best');

%% wykresy macierzowe - różne wariacje

figure; %4
gplotmatrix(stand_kawa,[], [], [], [], [], [], [], pierwiastek,pierwiastek);

figure; %5
gplotmatrix(stand_kawa,[], rodzaj, [], [], [], [], [], pierwiastek, pierwiastek);

figure; %6
gplotmatrix(stand_kawa,[],rodzaj,'brg',[], [], [], 'hist',pierwiastek);

figure; %7
gplotmatrix(stand_kawa,[],rodzaj,'brg',[], [], [], 'variable',pierwiastek);

% na wykresie macierzowym można zauważyć, że rzutowanie z wykorzystaniem
% parametru P pozwala na rozdzielenie próbek pomiędzy klasami

%% wykres twarzy Chernoffa

figure; %8
glyphplot(stand_kawa,'glyph', 'face','obslabels',code,'grid',[2,9]);
box on;

figure; %9
glyphplot(stand_kawa,'obslabels',code,'grid',[2,9]);
box on;

% można zauważyć, że rysowanie tak dużej ilości twarzy, przy tak
% różnorodnych parametrach sprawia, że wykresy stają się nieczytelne

%% twarze Chernoffa dla średnich wartości rodzajów kaw

% czasami wykonywane są wykresy twarzy Chernoffa dla średnich wartości
% parametrów danej klasy; jest to przydatne, gdy cechy pomiędzy grupami sa
% znacząco różne, a w samej grupie są stosunkowo zbliżone. Wtedy na
% podstawie podobieństwa istnieje możliwość porównania wykresów średnich z
% jakimś nowym, nieznanym nam pomiarem.
% przykład jak wykonać taką analizę przedstawiono poniżej

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

figure; %10
glyphplot(kawa_mean,'glyph', 'face','obslabels',c,'grid',[1,2]);
box on;

figure; %11
glyphplot(kawa_mean,'obslabels',c,'grid',[1,2]);
box on;

% widzimy, że część parametrów różni się pomiędzy typami kaw - przykładowo
% kształt twarzy

%% analiza skupień: dendrogram + mapa cieplna

figure; %12
X=zscore(kawa); %autoskalowanie
Z = linkage(X, 'ward','euclidean'); % analiza skupień
h=dendrogram(Z, 0, 'ColorThreshold',8,'Orientation','top','Labels', code);
% wyświetlenie schematu dendrogramu
set(h,'LineWidth',2) % grubość linii = 2
xlabel('code');
ylabel('distance');
box on;

% można zauważyć, że przy zastosowaniu odległości 8 część próbek została
% błędnie sklasyfikowana;
% po wykonaniu analizy dla wybranych parametrów okazuje się, że jest
% możliwym uzyskanie lepszego podziału, na przykład stosując jedynie
% parametry P i Mn

figure; %13
X=zscore(kawa(:,[2 3])); %autoskalowanie
Z = linkage(X, 'ward','euclidean'); % analiza skupień
h=dendrogram(Z, 0, 'ColorThreshold',4,'Orientation','top','Labels', code);
% wyświetlenie schematu dendrogramu
set(h,'LineWidth',2) % grubość linii = 2
xlabel('code');
ylabel('distance');
box on;

clustergram(stand_kawa, 'Standardize', 'Column', 'RowLabels', code, 'ColumnLabels', pierwiastek); %13 mapa cieplna

%% analiza składowych głównych

figure; % rysowanie wykresu osypiska %14
X=zscore(kawa); %autoskalowanie
[COEF, LT, EX] = pcacov(cov(X)); % w EX zwraca % opisywanej zmienności
bar(EX);
xlabel('Numer PC');
ylabel('% opisywanej zmienności');
box on;
grid on;

% stosując metodę procentu wariancji tłumaczonej przez główne składowe,
% zakładając, że chcemy osiągnąć 85% tłumaczonej wariancji oraz zachowując
% warunek, że żadna kolejna składowa nie tłumaczy więcej niż 5%,
% otrzymujemy 5 istotnych głównych składowych

figure; %15
[COEF, XSPCA, LT] = pca(X); % wykonanie PCA, w XSPCA zwraca wartości głównych składowych
gscatter(XSPCA(:,1), XSPCA(:,2), rodzaj, 'brg'); % rzut na PC1/PC2
xlabel('PC1');
ylabel('PC2');

% na rzucie na płaszczyznę PC1/PC2 widać, iż możliwym jest poprawny
% rozdział próbek na klasy