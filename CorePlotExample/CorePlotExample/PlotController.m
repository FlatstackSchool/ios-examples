//
//  PlotController.m
//  CorePlotExample
//
//  Created by Vladimir Goncharov on 10.02.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

#import "PlotController.h"

#import <CorePlot/CorePlot-CocoaTouch.h>
#import "_BBGraphTheme.h"

#pragma mark - 
typedef NS_ENUM(NSUInteger, CustomPlotStyle)
{
    CustomPlotStyleCenterLine   = 0,
    CustomPlotStyleControlLine,
    CustomPlotStyleWarningLine,
    CustomPlotStyleGradient
};

@interface CustomPlot: CPTScatterPlot

@property (nonatomic, assign, readonly) NSUInteger countValues;
@property (nonatomic, strong, readonly) NSArray *valuesX;
@property (nonatomic, strong, readonly) NSArray *valuesY;

@end

@implementation CustomPlot

@synthesize valuesX = _valuesX;
@synthesize valuesY = _valuesY;

- (instancetype)init
{
    self    = [super init];
    if (self)
    {
        _countValues    = 10 + arc4random_uniform(10);
    }
    return self;
}

- (NSArray *)valuesX
{
    if (!_valuesX)
    {
        _valuesX = [self __generateRandomValues:self.countValues];
    }
    return _valuesX;
}

- (NSArray *)valuesY
{
    if (!_valuesY)
    {
        _valuesY = [self __generateRandomValues:self.countValues];
    }
    return _valuesY;
}

- (NSArray *)__generateRandomValues:(NSUInteger)count
{
    return @[
             @(20 + arc4random_uniform(5)),
             @(35 + arc4random_uniform(5)),
             @(40 + arc4random_uniform(5)),
             @(50 + arc4random_uniform(5)),
             @(55 + arc4random_uniform(5)),
             @(65 + arc4random_uniform(5)),
             @(80 + arc4random_uniform(5)),
             @(95 + arc4random_uniform(5)),
             @(100 + arc4random_uniform(5)),
             @(110 + arc4random_uniform(5)),
             @(120 + arc4random_uniform(5)),
             @(135 + arc4random_uniform(5)),
             @(160 + arc4random_uniform(5)),
             @(175 + arc4random_uniform(5)),
             @(190 + arc4random_uniform(5)),
             @(200 + arc4random_uniform(5)),
             @(210 + arc4random_uniform(5)),
             @(220 + arc4random_uniform(5)),
             @(230 + arc4random_uniform(5)),
             @(240 + arc4random_uniform(5)),
             @(250 + arc4random_uniform(5))
             ];
}

- (void)updateWithStyle:(CustomPlotStyle)style
{
    switch (style)
    {
        case CustomPlotStyleCenterLine:
        {
            CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
            
            lineStyle.lineWidth          = 2.0;
            lineStyle.lineColor          = [CPTColor greenColor];
            
            self.dataLineStyle           = lineStyle;
        
        }; break;
            
        case CustomPlotStyleControlLine:
        {
            CPTMutableLineStyle *lineStyle  = [CPTMutableLineStyle lineStyle];
            
            lineStyle.lineWidth             = 2.0;
            lineStyle.lineColor             = [CPTColor redColor];
            lineStyle.dashPattern           = @[@10, @6];
            
            self.dataLineStyle              = lineStyle;
            
        }; break;
            
        case CustomPlotStyleWarningLine:
        {
            CPTMutableLineStyle *lineStyle  = [CPTMutableLineStyle lineStyle];
            
            lineStyle.lineWidth             = 1.0;
            lineStyle.lineColor             = [CPTColor orangeColor];
            lineStyle.dashPattern           = @[@5, @5];
            
            self.dataLineStyle              = lineStyle;
            
        }; break;
            
        case CustomPlotStyleGradient:
        {
            //setting line
            CPTMutableLineStyle *lineStyle   = [CPTMutableLineStyle lineStyle];
            lineStyle.lineColor              = [CPTColor clearColor];
            self.dataLineStyle = lineStyle;
            
            //add blue ellipse to point
            CPTMutableLineStyle *symbolLineStyle    = [CPTMutableLineStyle lineStyle];
            symbolLineStyle.lineColor               = [[CPTColor blackColor] colorWithAlphaComponent:0.5];
            CPTPlotSymbol *plotSymbol               = [CPTPlotSymbol ellipsePlotSymbol];
            plotSymbol.fill                         = [CPTFill fillWithColor:[[CPTColor blueColor] colorWithAlphaComponent:0.5]];
            plotSymbol.lineStyle                    = symbolLineStyle;
            plotSymbol.size                         = CGSizeMake(10.0, 10.0);
            self.plotSymbol                         = plotSymbol;
            
            //random gradients below line
            CGFloat startRed   = arc4random_uniform(255)/255.0f;
            CGFloat startGreen = arc4random_uniform(255)/255.0f;
            CGFloat startBlue  = arc4random_uniform(255)/255.0f;
            CGFloat startAlpha = 50 + arc4random_uniform(50)/100.0f;
            
            CGFloat endRed     = arc4random_uniform(255)/255.0f;
            CGFloat endGreen   = arc4random_uniform(255)/255.0f;
            CGFloat endBlue    = arc4random_uniform(255)/255.0f;
            CGFloat endAlpha   = 25 + arc4random_uniform(25)/100.0f;
            
            CPTColor *areaColor       = [CPTColor colorWithComponentRed:startRed green:startGreen blue:startBlue alpha:startAlpha];
            CPTColor *endingColor     = [CPTColor colorWithComponentRed:endRed green:endGreen blue:endBlue alpha:endAlpha];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor
                                                                    endingColor:endingColor
                                                              beginningPosition:0
                                                                 endingPosition:1];
            areaGradient.angle               = -90.0;
            CPTFill *areaGradientFill        = [CPTFill fillWithGradient:areaGradient];
            self.areaFill                   = areaGradientFill;
            self.areaBaseValue              = CPTDecimalFromDouble(1.75);
            
        }; break;
            
        default:
            break;
    }
}

@end

#pragma mark -
@interface PlotController ()

@property (nonatomic, weak) IBOutlet CPTGraphHostingView *graphHostingView;

@end

@interface PlotController (CPTScatterPlotDataSource) <CPTScatterPlotDataSource>

- (void)addNewPlot;

@end

@interface PlotController (CPTScatterPlotDelegate) <CPTScatterPlotDelegate>
@end

@implementation PlotController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //creating graph
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.graphHostingView.bounds
                                               xScaleType:CPTScaleTypeLinear
                                               yScaleType:CPTScaleTypeLinear];
    [graph applyTheme:[CPTTheme themeNamed:kBBTheme]];

//    //setting plot space
    CPTXYPlotSpace *plotSpace       = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.globalXRange          = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(50.0)
                                                                   length:CPTDecimalFromFloat(300.0)];
    plotSpace.globalYRange          = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                                   length:CPTDecimalFromFloat(300.0)];
    plotSpace.xRange          = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(100.0)
                                                             length:CPTDecimalFromFloat(200.0)];
    plotSpace.yRange          = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(150.0)
                                                             length:CPTDecimalFromFloat(250.0)];
    
    // Axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisConstraints     = [CPTConstraints constraintWithRelativeOffset:0.5];
    x.title       = @"X Axis";
    
    CPTXYAxis *y = axisSet.yAxis;
    y.title       = @"Y Axis";
    
    self.graphHostingView.hostedGraph   = graph;
    
    [self addNewPlot];
}

- (IBAction)add:(UIBarButtonItem *)sender
{
    [self addNewPlot];
}

@end

@implementation PlotController (CPTScatterPlotDataSource)

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [(CustomPlot *)plot countValues];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot
                      field:(NSUInteger)fieldEnum
                recordIndex:(NSUInteger)idx
{
    switch (fieldEnum)
    {
        case CPTScatterPlotFieldX:
        {
            return [[(CustomPlot *)plot valuesX] objectAtIndex:idx];
        }; break;
            
        case CPTScatterPlotFieldY:
        {
            return [[(CustomPlot *)plot valuesY] objectAtIndex:idx];
        }; break;
            
        default:
        {
            NSAssert(false, @"invalid field enum");
        }; break;
    }
    
    return @0;
}

- (void)addNewPlot
{
    // Create a green plot area
    CustomPlot *dataSourceLinePlot = [[CustomPlot alloc] init];
    dataSourceLinePlot.dataSource  = self;
    dataSourceLinePlot.delegate    = self;
    
    [dataSourceLinePlot updateWithStyle:arc4random_uniform(4)];
    
    //add new line
    [self.graphHostingView.hostedGraph addPlot:dataSourceLinePlot];
}

@end

@implementation PlotController (CPTScatterPlotDelegate)

- (void)scatterPlot:(CPTScatterPlot *)plot
plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    NSLog(@"click index %lu", (unsigned long)index);
    
    CustomPlot *customPlot    = (CustomPlot *)plot;
    
    CPTXYGraph *graph = (CPTXYGraph *)self.graphHostingView.hostedGraph;
    
    //remove all previos the annotations
    [graph.plotAreaFrame.plotArea removeAllAnnotations];
    
    // Setup a style for the annotation
    CPTMutableTextStyle *hitAnnotationTextStyle = [CPTMutableTextStyle textStyle];
    hitAnnotationTextStyle.color    = [CPTColor whiteColor];
    hitAnnotationTextStyle.fontName = @"Helvetica-Bold";
    
    NSNumber *x     = customPlot.valuesX[index];
    NSNumber *y     = customPlot.valuesY[index];
    NSArray *anchorPoint = @[x, y];
    
    // Add annotation
    // First make a string for the y value
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    NSString *yString = [formatter stringFromNumber:y];
    
    // Now add the annotation to the plot area
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:yString style:hitAnnotationTextStyle];
    textLayer.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    textLayer.paddingLeft   = 2.0;
    textLayer.paddingTop    = 2.0;
    textLayer.paddingRight  = 2.0;
    textLayer.paddingBottom = 2.0;
    
    CPTPlotSpaceAnnotation *annotation  = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:anchorPoint];
    annotation.contentLayer             = textLayer;
    annotation.contentAnchorPoint       = CGPointMake(0.5, 0.0);
    annotation.displacement             = CGPointMake(0.0, 10.0);
    [graph.plotAreaFrame.plotArea addAnnotation:annotation];
}

@end