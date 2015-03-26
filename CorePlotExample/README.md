# Core plot - библиотека для создания 2D графиков

Библиотека подключается с помощью PodFile. На момент написания актуальна 1.5.1 версия. 

В данном примере рассмотрены основные возможности:

  1. Создание и добавление графика с 2 плоскостями X и Y;
  2. Создание собственной темы для графиков (класс **_BBGraphTheme**). Кастомизация вида для темы с помощью *background*, *plot area* и *axis*;
  3. Создание разных видов линий (**CustomPlot** класс и **CustomPlotStyle** стили);
  4. Применение новой темы, редактирование plot space и axisSet; (**PlotController** в методе ```- (void)viewDidLoad```);
  5. Пример добавления новых линий на график. (**PlotController** в методе ```- (void)addNewPlot```);
  6. Добавление аннотаций (**PlotController** в методе ```- (void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index```).

Больше примеров можно посмотреть [на github](https://github.com/core-plot/core-plot). 

Документацию можно почитать [здесь](http://core-plot.github.io/iOS/annotated.html)

